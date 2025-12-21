extends Node

signal leaderboard_updated

# ==============================================================================
# MICRO ROGUE: LEADERBOARD MANAGER
# Özel PHP API ile iletişim kurar ve güvenli skor gönderir.
# ==============================================================================

const API_URL = "https://galaktikuzay.com/?micro_rogue_api=1"
const API_URL_HTTP = "http://galaktikuzay.com/?micro_rogue_api=1" # HTTPS başarısız olursa fallback
const SECRET_KEY = "COK_GIZLI_BIR_SIFRE_BELIRLE"
const TIMEOUT_SEC = 15.0

var http_request : HTTPRequest
var last_fetch_ok: bool = false
var is_fetching: bool = false
var _device_id := ""

func _ready():
	http_request = HTTPRequest.new()
	http_request.timeout = TIMEOUT_SEC
	add_child(http_request)
	http_request.request_completed.connect(_on_submit_completed)
	_device_id = Global.custom_device_id if Global.custom_device_id != "" else OS.get_unique_id()
	
	# Oyun açıldığında arka planda leaderboard'u çek
	call_deferred("fetch_leaderboard")
	
	# Bekleyen skor varsa göndermeyi dene
	call_deferred("_retry_pending_score")

# Admin veya test için özel gönderim
func submit_score_for_user(score: int, p_name: String, target_device_id: String) -> int:
	# MD5 Güvenlik İmzası: Ad + Skor + GizliAnahtar
	var raw_string = p_name + str(score) + SECRET_KEY
	var hash_str = raw_string.md5_text()
	
	var data = {
		"action": "submit",
		"name": p_name,
		"score": score,
		"device_id": target_device_id,
		"hash": hash_str
	}
	
	var json_str = JSON.stringify(data)
	var headers = ["Content-Type: application/json", "User-Agent: MicroRogueClient/1.0"]
	var err = http_request.request(API_URL, headers, HTTPClient.METHOD_POST, json_str)
	return err


# Oyuncu rekor kırdığında çağrılır
func submit_score(score: int):
	var p_name = Global.player_name
	var device_id = _device_id
	var err = submit_score_for_user(score, p_name, device_id)

	if err != OK:
		print("Skor gönderme isteği başlatılamadı: ", err)

# Kupon kodunu PHP API üzerinden doğrula
signal coupon_result(result: Dictionary)

func use_coupon_api(code: String, device_id: String):
	var coupon_request = HTTPRequest.new()
	coupon_request.timeout = TIMEOUT_SEC
	coupon_request.set_tls_options(TLSOptions.client_unsafe())
	add_child(coupon_request)
	
	var data = {
		"action": "use_coupon",
		"code": code.to_upper(),
		"device_id": device_id
	}
	
	var json_str = JSON.stringify(data)
	var headers = ["Content-Type: application/json", "User-Agent: MicroRogueClient/1.0"]
	
	coupon_request.request_completed.connect(func(result, response_code, _headers, body):
		coupon_request.queue_free()
		
		if result != HTTPRequest.RESULT_SUCCESS:
			print("Kupon doğrulama bağlantı hatası: ", result)
			emit_signal("coupon_result", {"success": false, "message": "CONNECTION_ERROR"})
			return
		
		if response_code == 200:
			var json = JSON.new()
			if json.parse(body.get_string_from_utf8()) == OK:
				var response = json.get_data()
				emit_signal("coupon_result", response)
			else:
				emit_signal("coupon_result", {"success": false, "message": "PARSE_ERROR"})
		else:
			emit_signal("coupon_result", {"success": false, "message": "SERVER_ERROR"})
	)
	
	# HTTP fallback
	var url = API_URL
	var err = coupon_request.request(url, headers, HTTPClient.METHOD_POST, json_str)
	if err != OK:
		coupon_request.queue_free()
		emit_signal("coupon_result", {"success": false, "message": "REQUEST_ERROR"})
		print("Kupon isteği başlatılamadı: ", err)

# Liderlik tablosunu sunucudan çeker
func fetch_leaderboard(retry_count: int = 0, use_http_fallback: bool = false):
	if is_fetching:
		return
	
	is_fetching = true
	
	var fetch_req = HTTPRequest.new()
	fetch_req.timeout = TIMEOUT_SEC
	# SSL doğrulamasını devre dışı bırak
	fetch_req.set_tls_options(TLSOptions.client_unsafe()) 
	add_child(fetch_req)
	
	fetch_req.request_completed.connect(func(result, code, _headers, body):
		is_fetching = false
		
		# Timeout veya bağlantı hatası (3=CantResolve, 13=CantOpen)
		if result != HTTPRequest.RESULT_SUCCESS:
			last_fetch_ok = false
			print("Leaderboard bağlantı hatası: ", result)
			
			# HTTP fallback dene (HTTPS failed)
			if not use_http_fallback and (result == 3 or result == 13):
				print("HTTP fallback deneniyor...")
				await get_tree().create_timer(1.0).timeout
				fetch_req.queue_free()
				fetch_leaderboard(0, true) # HTTP ile dene
				return
			# Normal retry
			elif retry_count < 1 and (result == 3 or result == 13):
				print("Yeniden deneniyor...")
				await get_tree().create_timer(2.0).timeout
				fetch_req.queue_free()
				fetch_leaderboard(retry_count + 1, use_http_fallback)
				return
			else:
				emit_signal("leaderboard_updated")
			
			fetch_req.queue_free()
			return
		
		last_fetch_ok = (code == 200)
		if last_fetch_ok:
			var json = JSON.new()
			if json.parse(body.get_string_from_utf8()) == OK:
				var data = json.get_data()
				if data is Array:
					# DEBUG: Ham API verisini logla
					print("=== RAW API DATA ===")
					for entry in data:
						print("  API Entry: name=", entry.get("name", "N/A"), " device_id=", entry.get("device_id", "N/A"), " score=", entry.get("score", 0))
					print("====================")
					
					Global.leaderboard_data = data
					_override_self_entry()
					print("Liderlik tablosu güncellendi. Kayıt sayısı: ", data.size())
		else:
			print("Liderlik tablosu çekilemedi. HTTP Kod: ", code)
		
		emit_signal("leaderboard_updated")
		fetch_req.queue_free()
	)
	
	# GET isteği - HTTPS veya HTTP
	# Cache-busting: Her istekte benzersiz timestamp ekle
	var timestamp = str(Time.get_unix_time_from_system()) + str(randi() % 10000)
	var url = (API_URL_HTTP if use_http_fallback else API_URL) + "&action=fetch&_t=" + timestamp
	var headers = [
		"User-Agent: MicroRogueClient/1.0",
		"Cache-Control: no-cache, no-store, must-revalidate",
		"Pragma: no-cache"
	]
	print("Leaderboard URL: ", url)
	var err = fetch_req.request(url, headers)
	if err != OK:
		is_fetching = false
		print("Leaderboard isteği başlatılamadı: ", err)
		fetch_req.queue_free()

func _on_submit_completed(result, response_code, _headers, _body):
	if result != HTTPRequest.RESULT_SUCCESS:
		print("Skor gönderme bağlantı hatası: ", result)
		# İnternet yoksa pending flag'i ayarla, sonra tekrar denenecek
		Global.pending_score_submit = true
		Global.save_game()
		return
		
	if response_code == 200:
		print("Skor başarıyla gönderildi.")
		last_fetch_ok = true
		# Pending flag'i temizle
		Global.pending_score_submit = false
		Global.save_game()
		# Skor gönderildikten sonra listeyi hemen güncelle
		fetch_leaderboard()
	else:
		print("Skor gönderilemedi. Hata kodu: ", response_code)

# Skorun listeye girmeye değer olup olmadığını kontrol eder (Top 25)
func is_score_worthy(score: int) -> bool:
	if Global.leaderboard_data.size() < 25:
		return true
	
	# Zaten listede miyim? (Cihaz ID kontrolü)
	for entry in Global.leaderboard_data:
		if entry.get("device_id") == _device_id:
			return true # Listedeyim, skorumu güncelliyor olabilirim

	# Listenin en sonuncusundan büyük mü?
	var last_entry = Global.leaderboard_data.back()
	if last_entry and score > last_entry.get("score", 0):
		return true

	return false

func _override_self_entry():
	# DEVRE DIŞI: Artık sunucu verisi doğrudan kullanılıyor.
	# Web Admin Paneli sunucu verisini düzenlediği için yerel override'a gerek yok.
	# Eski local isim override'ı kaldırıldı.
	pass
	
	# Eski kod (referans için):
	# _device_id = Global.custom_device_id if Global.custom_device_id != "" else OS.get_unique_id()
	# if Global.leaderboard_data is Array:
	#     for i in range(Global.leaderboard_data.size()):
	#         var e = Global.leaderboard_data[i]
	#         if e is Dictionary:
	#             if e.has("device_id") and str(e["device_id"]) == str(_device_id):
	#                 e["name"] = Global.player_name
	#                 Global.leaderboard_data[i] = e

func _retry_pending_score():
	# Önceki oturumda gönderilemeyen skor varsa tekrar dene
	if Global.pending_score_submit and Global.high_score > 0:
		print("Bekleyen skor gönderiliyor: ", Global.high_score)
		await get_tree().create_timer(2.0).timeout # Fetch'in bitmesini bekle
		submit_score(Global.high_score)
