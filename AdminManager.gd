extends Node

# ==============================================================================
# ADMIN MANAGER - GitHub Gist Entegrasyonu
# ==============================================================================

const GIST_ID = "383e47509e758c056a83fdc1d5c7370e"  # GitHub Gist ID
const GIST_RAW_URL = "https://gist.githubusercontent.com/ozguradmin/" + GIST_ID + "/raw/"
const GIST_API_URL = "https://api.github.com/gists/" + GIST_ID
const TOKEN_FILE = "user://admin_token.enc"
const ADMIN_CODE_FILE = "user://admin_code.enc"
const ENCRYPTION_PASS = "micro_rogue_admin_2024"

var github_token: String = ""
var admin_code: String = ""

var http_request: HTTPRequest
var admin_data: Dictionary = {
	"users": {},  # device_id -> {name: "", score: 0}
	"hidden_users": [], # Silinen kullanıcıların ID listesi
	"coupons": {}  # code -> {gold: 0, max_uses: -1, used_count: 0, used_by: []}
}

signal data_loaded
signal data_saved
signal save_error(error_message: String)

func _ready():
	http_request = HTTPRequest.new()
	http_request.timeout = 10.0
	http_request.set_tls_options(TLSOptions.client_unsafe())
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	_load_credentials()
	load_admin_data()

func _load_credentials():
	# Token'ı güvenli şekilde yükle
	if FileAccess.file_exists(TOKEN_FILE):
		var file = FileAccess.open_encrypted_with_pass(TOKEN_FILE, FileAccess.READ, ENCRYPTION_PASS)
		if file:
			github_token = file.get_as_text()
			file.close()
	else:
		# İlk kurulum - token'ı kaydet
		_save_token("TOKEN_REMOVED_FOR_SECURITY")
	
	# Admin kodunu güvenli şekilde yükle
	if FileAccess.file_exists(ADMIN_CODE_FILE):
		var file = FileAccess.open_encrypted_with_pass(ADMIN_CODE_FILE, FileAccess.READ, ENCRYPTION_PASS)
		if file:
			admin_code = file.get_as_text()
			file.close()
	else:
		# İlk kurulum - admin kodunu kaydet
		_save_admin_code("o86741711")

func _save_token(token: String):
	github_token = token
	var file = FileAccess.open_encrypted_with_pass(TOKEN_FILE, FileAccess.WRITE, ENCRYPTION_PASS)
	if file:
		file.store_string(token)
		file.close()

func _save_admin_code(code: String):
	admin_code = code
	var file = FileAccess.open_encrypted_with_pass(ADMIN_CODE_FILE, FileAccess.WRITE, ENCRYPTION_PASS)
	if file:
		file.store_string(code)
		file.close()

func get_admin_code() -> String:
	return admin_code

func load_admin_data():
	# Cache busting için rastgele sayı ekle
	var random_suffix = str(randi() % 1000000000).pad_zeros(9)
	var url = GIST_RAW_URL + "admin_data.json?" + random_suffix
	
	# Raw URL için basit GET isteği
	var raw_request = HTTPRequest.new()
	raw_request.timeout = 10.0
	add_child(raw_request)
	raw_request.request_completed.connect(func(result, code, _headers, body):
		raw_request.queue_free()
		if result == HTTPRequest.RESULT_SUCCESS and code == 200:
			var json = JSON.new()
			if json.parse(body.get_string_from_utf8()) == OK:
				admin_data = json.get_data()
				print("Admin data yüklendi")
				emit_signal("data_loaded")
			else:
				admin_data = {"users": {}, "coupons": {}}
		else:
			admin_data = {"users": {}, "coupons": {}}
	)
	raw_request.request(url)

func save_admin_data():
	var url = GIST_API_URL
	var headers = [
		"Accept: application/vnd.github.v3+json",
		"Content-Type: application/json"
	]
	if github_token != "":
		headers.append("Authorization: token " + github_token)
	
	# Hidden_users listesinin varlığını garanti et
	if not admin_data.has("hidden_users"):
		admin_data["hidden_users"] = []
	
	# Gist'in mevcut dosyasını bul ve güncelle
	var payload = {
		"description": "Portal Dash Admin Data",
		"files": {
			"admin_data.json": {
				"content": JSON.stringify(admin_data)
			}
		}
	}
	
	# Her kaydetme için yeni HTTPRequest oluştur (ERR_BUSY önleme)
	var save_request = HTTPRequest.new()
	save_request.timeout = 15.0
	save_request.set_tls_options(TLSOptions.client_unsafe())
	add_child(save_request)
	
	save_request.request_completed.connect(func(result, code, _headers, _body):
		save_request.queue_free() # Temizlik
		if result == HTTPRequest.RESULT_SUCCESS and code == 200:
			print("Admin data kaydedildi")
			emit_signal("data_saved")
		else:
			print("Gist kaydetme hatası. Result: ", result, " HTTP: ", code)
			emit_signal("save_error", "HTTP error: " + str(code))
	)
	
	var json_str = JSON.stringify(payload)
	var err = save_request.request(url, headers, HTTPClient.METHOD_PATCH, json_str)
	if err != OK:
		save_request.queue_free()
		print("Admin data kaydetme hatası: ", err)

func _on_request_completed(result, response_code, _headers, _body):
	# Bu fonksiyon sadece save için kullanılıyor
	if result != HTTPRequest.RESULT_SUCCESS:
		print("HTTP isteği başarısız: ", result)
		emit_signal("save_error", "Network error: " + str(result))
		return
	
	if response_code == 200:
		print("Admin data kaydedildi")
		emit_signal("data_saved")
		# Kaydetme sonrası veriyi yeniden yüklemeye gerek yok (zaten local'de var)
		# load_admin_data() çağrısını kaldırdık çünkü döngü oluşturuyordu
	else:
		print("Gist kaydetme hatası. HTTP: ", response_code)
		emit_signal("save_error", "HTTP error: " + str(response_code))

func update_user(device_id: String, p_name: String, score: int):
	if not admin_data.has("users"):
		admin_data["users"] = {}
	admin_data["users"][device_id] = {"name": p_name, "score": score}
	save_admin_data()

func get_user_data(device_id: String) -> Dictionary:
	if admin_data.has("users") and admin_data["users"].has(device_id):
		return admin_data["users"][device_id]
	return {}

func add_coupon(code: String, gold: int, max_uses: int = -1):
	if not admin_data.has("coupons"):
		admin_data["coupons"] = {}
	admin_data["coupons"][code] = {
		"gold": gold,
		"max_uses": max_uses,  # -1 = sınırsız
		"used_count": 0,
		"used_by": []
	}
	save_admin_data()

func remove_coupon(code: String):
	if admin_data.has("coupons"):
		admin_data["coupons"].erase(code)
		save_admin_data()

func use_coupon(code: String, device_id: String) -> Dictionary:
	if not admin_data.has("coupons") or not admin_data["coupons"].has(code):
		return {"success": false, "message": "CODE_NOT_FOUND"}
	
	var coupon = admin_data["coupons"][code]
	
	# Kullanım limiti kontrolü
	if coupon["max_uses"] > 0 and coupon["used_count"] >= coupon["max_uses"]:
		return {"success": false, "message": "CODE_EXPIRED"}
	
	# Aynı kişi daha önce kullandı mı?
	if device_id in coupon["used_by"]:
		return {"success": false, "message": "ALREADY_USED"}
	
	# Kuponu kullan
	coupon["used_count"] += 1
	coupon["used_by"].append(device_id)
	save_admin_data()
	
	return {"success": true, "gold": coupon["gold"]}

func check_user_updates(device_id: String) -> Dictionary:
	var user_data = get_user_data(device_id)
	if user_data.is_empty():
		return {}
	return user_data
