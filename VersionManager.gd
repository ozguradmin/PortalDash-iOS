extends Node

# ==============================================================================
# MICRO ROGUE: VERSION MANAGER (UPDATED)
# ==============================================================================

signal version_checked(is_blocking)

const CONFIG_URL = "https://gist.githubusercontent.com/ozguradmin/e016254f3f84af4858ba0b37025a9cc8/raw/game_config.json"
const CURRENT_VERSION_CODE = 1.0 

var http_request : HTTPRequest
var popup_message : String = ""
var store_url : String = ""
var maintenance_mode : bool = false

func _get_localized(val):
	# Destek: Düz string ya da { "en": "...", "tr": "..." }
	if typeof(val) == TYPE_DICTIONARY:
		var lang = Global.language if Global and Global.has_method("get") else "en"
		return val.get(lang, val.get("en", ""))
	elif typeof(val) == TYPE_STRING:
		return val
	return ""

func _ready():
	# Bu node arka planda çalışmaya hazır olsun ama otomatik başlamasın
	# MainMenu çağırınca çalışacak.
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

# MainMenu.gd bu fonksiyonu çağırıyor:
func check_version():
	# Cache (önbellek) sorununu aşmak için URL sonuna rastgele sayı ekliyoruz
	var random_param = "?v=" + str(randi())
	var final_url = CONFIG_URL + random_param
	http_request.request(final_url)

func _on_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		print("Sürüm kontrolü yapılamadı. Kod: ", response_code)
		return
	
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	
	if parse_result != OK:
		print("JSON verisi okunamadı.")
		return
 
	var data = json.get_data()
	
	# Verileri kaydet
	maintenance_mode = data.get("maintenance_mode", false)
	# Platforma göre store linki (tamamı JSON’dan, kodda default yok)
	var platform = OS.get_name()
	if platform == "iOS":
		store_url = data.get("store_url_ios", data.get("store_url_android", ""))
	else:
		store_url = data.get("store_url_android", data.get("store_url_ios", ""))
	store_url = str(store_url).strip_edges()
	
	# Özel mesaj varsa al (Yoksa MainMenu varsayılanı kullanır)
	if maintenance_mode:
		popup_message = _get_localized(data.get("maintenance_message", "Sunucular bakımda."))
		emit_signal("version_checked", true) # Blocking true
		return

	var min_ver = float(data.get("min_required_version", 0))
	
	if float(CURRENT_VERSION_CODE) < min_ver:
		popup_message = _get_localized(data.get("update_message", "Yeni güncelleme mevcut!"))
		emit_signal("version_checked", true) # Blocking true (Güncelleme gerekli)
	else:
		emit_signal("version_checked", false) # Blocking false (Sorun yok)
