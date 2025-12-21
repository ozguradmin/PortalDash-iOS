extends Control

# ==============================================================================
# PORTAL DASH: MAIN MENU (FINAL FIX V15 - STABLE)
# ==============================================================================

# --- AYARLAR ---
const FONT_PATH = "res://PressStart2P.ttf"
# LevelData removed

# --- RENKLER ---
const C_HERO_MAIN = Color(0.0, 0.7, 1.0)
const C_HERO_DARK = Color(0.0, 0.4, 0.7)
const C_MASK_BG   = Color(0.1, 0.1, 0.3)
const C_EYES      = Color(1, 1, 1)
const C_OUTLINE   = Color(0, 0, 0)

const C_ISLAND_GRASS   = Color("#63c74d")
const C_ISLAND_GRASS_S = Color("#2f6925")
const C_ISLAND_DIRT    = Color("#8b5e3c")
const C_ISLAND_SHADOW  = Color("#5e3f28")
const C_ISLAND_ROOT    = Color("#4a3b32")

const C_BG = Color("#212121")

# BUTON RENKLERİ
const C_PLAY_BG       = Color("#41c741")
const C_PLAY_HOVER    = Color("#42b442")
const C_PLAY_INNER_DK = Color("#2a6d2a")

const C_STORE_BG       = Color("#c74e35")
const C_STORE_HOVER    = Color("#b73e25")
const C_STORE_INNER_DK = Color("#8f3c2d")



# YENİ YÜZEN ADA RLE SPRITE (RENK HATASI DÜZELTİLDİ)
# --- DEĞİŞKENLER ---

# CoinIcon sınıfı
class MissionIcon extends Control:
	func _init():
		custom_minimum_size = Vector2(24, 24)
	func _draw():
		var px = 1.0
		var c = size / 2
		var board = Color("#5d4037")
		var paper = Color("#eceff1")
		var green = Color("#2e7d32")
		var clip = Color("#cfd8dc")
		var out = Color("#1b1b1b")
		draw_rect(Rect2(c.x-11*px, c.y-13*px, 22*px, 26*px), out)
		draw_rect(Rect2(c.x-9*px, c.y-11*px, 18*px, 22*px), board)
		draw_rect(Rect2(c.x-7*px, c.y-8*px, 14*px, 17*px), paper)
		draw_rect(Rect2(c.x-6*px, c.y-13*px, 12*px, 4*px), out)
		draw_rect(Rect2(c.x-4*px, c.y-11*px, 8*px, 2*px), clip)
		draw_rect(Rect2(c.x-5*px, c.y-5*px, 3*px, 3*px), green)
		draw_rect(Rect2(c.x-1*px, c.y-5*px, 7*px, 2*px), Color("#b0bec5"))
		draw_rect(Rect2(c.x-5*px, c.y+0*px, 3*px, 3*px), green)
		draw_rect(Rect2(c.x-1*px, c.y+0*px, 7*px, 2*px), Color("#b0bec5"))
		draw_rect(Rect2(c.x-5*px, c.y+5*px, 3*px, 3*px), green)
		draw_rect(Rect2(c.x-1*px, c.y+5*px, 5*px, 2*px), Color("#b0bec5"))

class CoinIcon extends Control:
	const C_GOLD_OUTLINE = Color(0.8, 0.4, 0.0)
	const C_GOLD_MAIN   = Color(1.0, 0.8, 0.0)
	const C_GOLD_SHINE  = Color(1.0, 1.0, 0.8)
	
	var is_static = false

	func _init():
		custom_minimum_size = Vector2(24, 24)
 
	func _process(_delta):
		queue_redraw()
 
	func _draw():
		var time = Time.get_ticks_msec() / 1000.0
		var s = size.x
		var center = size / 2
 
		# Oyun içi spin efekti veya statik duruş
		var spin_width_factor = 1.0
		if not is_static:
			spin_width_factor = abs(cos(time * 3.0)) 
 
		var max_w = s * 0.6
		var h = s * 0.7
		var current_w = max(2.0, max_w * spin_width_factor)
 
		var coin_pos = center - Vector2(current_w/2, h/2)
 
		# Çizim
		draw_rect(Rect2(coin_pos, Vector2(current_w, h)), C_GOLD_OUTLINE)
		if current_w > 4:
			draw_rect(Rect2(coin_pos.x + 2, coin_pos.y + 2, current_w - 4, h - 4), C_GOLD_MAIN)
			if current_w > 8:
				draw_rect(Rect2(coin_pos.x + 4, coin_pos.y + 4, 3, 6), C_GOLD_SHINE)

class TutorialVisual extends Control:
	var page = 0
	
	func _draw():
		var c = size / 2
		var s = 3.0 * (size.x / 300.0) # Scale based on container size
		var time = Time.get_ticks_msec() / 1000.0
		
		if page == 0:
			# Sayfa 1: Oyuncu ve Portal
			# PORTAL (Mavi/Mor döngü)
			var p_center = c + Vector2(0, -30 * s)
			# var rotation_base = time * 2.0 # Unused
			# var _C_PORTAL_CORE = Color(0.1, 0.0, 0.2) # Unused
			var C_PORTAL_RING = Color(0.4, 0.0, 0.8)
			var C_PORTAL_LIGHT = Color(0.8, 0.4, 1.0)
			
			for i in range(3):
				var size_p = (28.0 - (i * 6.0)) * s * 0.5
				var color = C_PORTAL_RING
				if i == 2: color = C_PORTAL_LIGHT
				var pulse = 1.0 + sin(time * 5.0 + i) * 0.1
				var r_size = Vector2(size_p, size_p) * pulse
				var r_pos = p_center - r_size/2
				draw_rect(Rect2(r_pos, r_size), color, false, 2.0 * s)
			
			# PLAYER (Gerçek Skin)
			var p_pos = c + Vector2(0, 20 * s)
			if get_parent().get_parent().get_parent().has_method("draw_user_pixel_hero"):
				# Ana menüdeki fonksiyonu simüle et
				pass
				
			# Manuel Player Çizimi (Main.gd ile birebir aynı olması için)
			# var vis_player_scale = Vector2(s, s) # Unused
			var center = p_pos
			
			if Global.owned_skins.has(Global.current_skin):
				# Skin çizimi için SkinManager kullanmak daha doğru olur ama burada basitçe kare çizelim
				# veya mainmenu'deki draw_user_pixel_hero'yu kopyalayalım
				var col_main = Color(0.0, 0.7, 1.0)
				var col_dark = Color(0.0, 0.4, 0.7)
				
				# Gövde
				draw_rect(Rect2(center.x - 6*s, center.y - 6*s, 12*s, 12*s), col_main)
				# Gözler
				draw_rect(Rect2(center.x - 2*s, center.y - 4*s, 2*s, 2*s), Color.WHITE)
				draw_rect(Rect2(center.x + 2*s, center.y - 4*s, 2*s, 2*s), Color.WHITE)
				# Maske/Kask detayları (Basitleştirilmiş)
				draw_rect(Rect2(center.x - 6*s, center.y - 6*s, 12*s, 4*s), col_dark)

			# Ok
			var arrow_col = Color("#fdd835")
			var arrow_start = p_pos + Vector2(0, -15 * s)
			var arrow_end = p_center + Vector2(0, 15 * s)
			draw_line(arrow_start, arrow_end, arrow_col, 2 * s)
			# Ok ucu
			draw_line(arrow_end, arrow_end + Vector2(-5*s, 5*s), arrow_col, 2 * s)
			draw_line(arrow_end, arrow_end + Vector2(5*s, 5*s), arrow_col, 2 * s)

		elif page == 1:
			# Sayfa 2: Düşmanlar (Gerçek Renkler)
			var C_ENEMY_MAIN = Color(0.9, 0.1, 0.3)
			var C_ENEMY_DARK = Color(0.6, 0.0, 0.2)
			var C_ENEMY_SPIKE = Color(0.2, 0.0, 0.1)
			var C_EYE_SCLERA = Color(1, 1, 1)
			var C_EYE_PUPIL = Color(0.1, 0.0, 0.0)
			
			var C_ENEMY_SLEEPY = Color("#8a6f30") # Altın/Kahve
			# var C_ENEMY_TURRET = Color("#ff6600") # Unused

			# 1. CHASER (Kırmızı - Sol)
			var ex = c.x - 40*s
			var center = Vector2(ex, c.y)
			var size_e = 20.0 * s
			var half = size_e / 2
			
			# Dikenler
			for j in range(4):
				var angle = (time * -4.0) + (j * (PI / 2.0))
				var dist = 18.0 * s
				var spike_v = Vector2(cos(angle), sin(angle)) * dist
				draw_rect(Rect2(center + spike_v - Vector2(3*s,3*s), Vector2(6*s,6*s)), C_ENEMY_SPIKE)
			
			draw_rect(Rect2(center.x - half, center.y + 2*s - half, size_e, size_e), C_ENEMY_DARK)
			draw_rect(Rect2(center.x - half, center.y - half, size_e, size_e - 2*s), C_ENEMY_MAIN)
			
			# Göz
			var eye_size = 10 * s
			var eye_pos = Vector2(center.x - eye_size/2, center.y - eye_size/2 - 2*s)
			draw_rect(Rect2(eye_pos, Vector2(eye_size, eye_size)), C_EYE_SCLERA)
			draw_rect(Rect2(center.x - 2*s, center.y - 2*s - 2*s, 4*s, 4*s), C_EYE_PUPIL)
			draw_rect(Rect2(eye_pos.x, eye_pos.y - 2*s, eye_size, 4*s), C_ENEMY_DARK)

			# 2. SLEEPY (Kahve - Sağ)
			ex = c.x + 40*s
			center = Vector2(ex, c.y)
			
			# Dikenler (Daha az hareketli)
			for j in range(4):
				var angle = (j * (PI / 2.0))
				var dist = 16.0 * s
				var spike_v = Vector2(cos(angle), sin(angle)) * dist
				draw_rect(Rect2(center + spike_v - Vector2(3*s,3*s), Vector2(6*s,6*s)), C_ENEMY_SPIKE)
				
			draw_rect(Rect2(center.x - half, center.y + 2*s - half, size_e, size_e), C_ENEMY_DARK)
			draw_rect(Rect2(center.x - half, center.y - half, size_e, size_e - 2*s), C_ENEMY_SLEEPY)
			
			# Uyuyan Göz (Çizgi)
			draw_rect(Rect2(center.x - 5*s, center.y - 2*s, 10*s, 2*s), C_ENEMY_DARK)
			
			# Zzz
			var z_y = center.y - 15*s + sin(time*3)*5*s
			draw_string(ThemeDB.fallback_font, Vector2(center.x + 10*s, z_y), "Zz", HORIZONTAL_ALIGNMENT_LEFT, -1, 16*s)


		elif page == 2:
			# Sayfa 3: Bufflar (Detaylı Pixel Art)
			var gap = 50 * s
			var start_x = c.x - gap
			var cy = c.y
			var sz = 24.0 * s # Base size
			
			# 1. HEART (Sol)
			var center = Vector2(start_x, cy)
			var px = (sz / 14.0) * 0.8
			var h_out = Color("#880e4f")
			var h_base = Color("#d50000")
			var h_shine = Color("#ffcdd2")
			
			draw_rect(Rect2(center.x-13*px, center.y-10*px, 12*px, 10*px), h_out)
			draw_rect(Rect2(center.x+1*px, center.y-10*px, 12*px, 10*px), h_out)
			draw_rect(Rect2(center.x-13*px, center.y, 26*px, 8*px), h_out)
			draw_rect(Rect2(center.x-9*px, center.y+8*px, 18*px, 4*px), h_out)
			draw_rect(Rect2(center.x-5*px, center.y+12*px, 10*px, 3*px), h_out)
			draw_rect(Rect2(center.x-11*px, center.y-8*px, 10*px, 10*px), h_base)
			draw_rect(Rect2(center.x+1*px, center.y-8*px, 10*px, 10*px), h_base)
			draw_rect(Rect2(center.x-11*px, center.y+2*px, 22*px, 6*px), h_base)
			draw_rect(Rect2(center.x-7*px, center.y+8*px, 14*px, 4*px), h_base)
			draw_rect(Rect2(center.x-3*px, center.y+12*px, 6*px, 2*px), h_base)
			draw_rect(Rect2(center.x-9*px, center.y-6*px, 4*px, 4*px), h_shine)
			
			# 2. SHIELD (Orta)
			center = Vector2(c.x, cy)
			var s_out = Color("#0d47a1")
			var s_border = Color("#90a4ae")
			var s_core = Color("#2196f3")
			
			draw_rect(Rect2(center.x-12*px, center.y-12*px, 24*px, 16*px), s_out)
			draw_rect(Rect2(center.x-10*px, center.y+4*px, 20*px, 4*px), s_out)
			draw_rect(Rect2(center.x-8*px, center.y+8*px, 16*px, 4*px), s_out)
			draw_rect(Rect2(center.x-4*px, center.y+12*px, 8*px, 4*px), s_out)
			draw_rect(Rect2(center.x-10*px, center.y-10*px, 20*px, 14*px), s_border)
			draw_rect(Rect2(center.x-8*px, center.y+4*px, 16*px, 4*px), s_border)
			draw_rect(Rect2(center.x-6*px, center.y+8*px, 12*px, 4*px), s_border)
			draw_rect(Rect2(center.x-2*px, center.y+12*px, 4*px, 2*px), s_border)
			draw_rect(Rect2(center.x-6*px, center.y-6*px, 12*px, 12*px), s_core)

			# 3. MAGNET (Sağ)
			center = Vector2(c.x + gap, cy)
			var red_base = Color("#d32f2f")
			var out = Color("#3e2723")
			var metal = Color("#cfd8dc")
			
			draw_rect(Rect2(center.x-12*px, center.y-12*px, 8*px, 20*px), out)
			draw_rect(Rect2(center.x+4*px, center.y-12*px, 8*px, 20*px), out)
			draw_rect(Rect2(center.x-8*px, center.y+6*px, 16*px, 6*px), out)
			draw_rect(Rect2(center.x-10*px, center.y-10*px, 4*px, 16*px), red_base)
			draw_rect(Rect2(center.x+6*px, center.y-10*px, 4*px, 16*px), red_base)
			draw_rect(Rect2(center.x-6*px, center.y+6*px, 12*px, 2*px), red_base)
			draw_rect(Rect2(center.x-10*px, center.y-10*px, 4*px, 2*px), metal)
			draw_rect(Rect2(center.x+6*px, center.y-10*px, 4*px, 2*px), metal)

		elif page == 3:
			# Sayfa 4: Kontroller (Swipe El)
			var hand_col = Color("#ffe0b2")
			var hand_pos = c + Vector2(0, 10*s)
			
			# El Hareketi Animasyonu
			var swipe_off = sin(time * 5.0) * 20 * s
			hand_pos.x += swipe_off
			
			# El Çizimi (Basit)
			draw_circle(hand_pos, 8*s, hand_col)
			draw_rect(Rect2(hand_pos.x - 6*s, hand_pos.y, 12*s, 10*s), hand_col)
			
			# Oklar (Yön Göstergesi)
			var arrow_col = Color(1, 1, 1, 0.5)
			draw_line(c - Vector2(40*s, 0), c + Vector2(40*s, 0), arrow_col, 2*s)
			draw_line(c - Vector2(0, 40*s), c + Vector2(0, 40*s), arrow_col, 2*s)
			
			# İkonik "Kaydırma" Oku
			draw_line(hand_pos, hand_pos + Vector2(15*s, 0), Color.WHITE, 3*s)
			draw_line(hand_pos + Vector2(15*s, 0), hand_pos + Vector2(10*s, -5*s), Color.WHITE, 3*s)
			draw_line(hand_pos + Vector2(15*s, 0), hand_pos + Vector2(10*s, 5*s), Color.WHITE, 3*s)




var custom_font : Font = null
var time_elapsed = 0.0
var stars = []
var particles = []
var screen_size = Vector2.ZERO
var ui_scale = 1.0
var blink_timer = 0.0
var is_blinking = false
var next_blink_time = 3.0

var area_top : Rect2
var area_mid : Rect2
var area_bot : Rect2

var play_btn : Button
var store_btn : Button
var btn_rank : Button
var btn_set : Button
var btn_daily : Button
var btn_mission : Button # Yeni Görev Butonu

var platform_texture : Texture2D = null
var platform_surface_row : int = 0

# Popup containers
var shop_popup : Control
var settings_popup : Control
var leaderboard_popup : Control
var daily_popup : Control
var mission_popup : Control 
var skin_detail_popup : Control 
var overlay : ColorRect
var tutorial_popup : Control
var gift_code_popup : Control
var admin_panel_popup : Control
var language_popup : Control

var tutorial_page = 0
var version_blocking_active : bool = false
var name_change_timestamp : float = 0.0 # Kullanıcının isim değiştirdiği zaman (server overwrite koruması)
const EXCLAIM_COL_BASE = Color("#ff5722")
const EXCLAIM_COL_OUT = Color("#5c1206")
const EXCLAIM_COL_SHADOW = Color("#8a2b0e")
const EXCLAIM_COL_HI = Color(1, 1, 1, 0.6)

func draw_exclaim_icon(node: CanvasItem, center: Vector2, px: float, pulse: float = 1.0):
	var bar_w = 3.0 * px
	var bar_h = 7.0 * px
	var dot_s = 3.0 * px
	var gap = 2.0 * px
	var total_h = bar_h + gap + dot_s
	var start = center - Vector2(bar_w / 2.0, total_h / 2.0)
	
	var col_base = EXCLAIM_COL_BASE
	var col_out = EXCLAIM_COL_OUT
	var col_shadow = EXCLAIM_COL_SHADOW
	var col_hi = EXCLAIM_COL_HI
	col_base.a *= pulse; col_out.a *= pulse; col_shadow.a *= pulse; col_hi.a *= pulse
	
	# Outline
	node.draw_rect(Rect2(start.x - px, start.y - px, bar_w + 2*px, bar_h + 2*px), col_out)
	var dot_y = start.y + bar_h + gap
	node.draw_rect(Rect2(start.x - px, dot_y - px, dot_s + 2*px, dot_s + 2*px), col_out)
	# Shadow
	node.draw_rect(Rect2(start.x + px, start.y + px, bar_w, bar_h), col_shadow)
	node.draw_rect(Rect2(start.x + px, dot_y + px, dot_s, dot_s), col_shadow)
	# Body
	node.draw_rect(Rect2(start.x, start.y, bar_w, bar_h), col_base)
	node.draw_rect(Rect2(start.x, dot_y, dot_s, dot_s), col_base)
	# Highlight
	node.draw_rect(Rect2(start.x, start.y, px, px*2), col_hi)
	node.draw_rect(Rect2(start.x, dot_y, px, px), col_hi)

# Liderlik tablosu durum bayrakları
var leaderboard_loading: bool = false
var leaderboard_error: bool = false
var leaderboard_best_label: Label = null  # BEST label referansı

# Sekme yönetimi için referanslar
var shop_tab_content : Dictionary = {} 
var rank_tab_content : Dictionary = {}

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_init_missions()
	set_anchors_preset(Control.PRESET_FULL_RECT)
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	texture_repeat = CanvasItem.TEXTURE_REPEAT_DISABLED
	screen_size = get_viewport_rect().size
	
	if ResourceLoader.exists(FONT_PATH):
		custom_font = load(FONT_PATH)
	
	# ASYA DİLLERİ İÇİN FONT FALLBACK (Dinamik Reload Gerekebilir)
	# Dil değişince Scene reload olduğu için _ready'de kontrol yeterli
	if Global.language in ["ja", "zh", "ko", "hi"]:
		if ResourceLoader.exists("res://unicode.ttf"):
			custom_font = load("res://unicode.ttf")
	
	# Menu müziğini başlat
	if SoundManager:
		SoundManager.play_menu_music()
	
	# AdminManager bağlantısı
	if AdminManager:
		AdminManager.data_loaded.connect(_on_admin_data_loaded)
	else:
		print("UYARI: 'PressStart2P.ttf' bulunamadı! Varsayılan font kullanılıyor.")
	
	if LeaderboardManager:
		if not LeaderboardManager.leaderboard_updated.is_connected(_on_leaderboard_updated):
			LeaderboardManager.leaderboard_updated.connect(_on_leaderboard_updated)
	
	# Global score güncellendiğinde leaderboard popup'ı yenile
	if not Global.high_score_updated.is_connected(_on_high_score_updated):
		Global.high_score_updated.connect(_on_high_score_updated)
	
	for i in range(60):
		stars.append({
			"pos": Vector2(randf() * screen_size.x, randf() * screen_size.y),
			"speed": randf_range(20, 80),
			"size": randf_range(1, 3),
			"color": Color.WHITE * randf_range(0.3, 0.8)
		})
 
	# load_platform_texture() # Bunu iptal ediyoruz, parallax kullanacağız
	setup_parallax_background() # Yeni fonksiyon
	setup_pixel_ui()
	
	# --- ONLINE SÜRÜM KONTROLÜ ---
	if VersionManager:
		if not VersionManager.version_checked.is_connected(_on_version_checked):
			VersionManager.version_checked.connect(_on_version_checked)
		VersionManager.check_version()

var background_texture: Texture2D
var bg_scroll_x: float = 0.0
var bg_scroll_speed: float = 30.0
var bg_scale: float = 1.0

func setup_parallax_background():
	if FileAccess.file_exists("res://background.jpeg"):
		background_texture = load("res://background.jpeg")
	elif FileAccess.file_exists("res://background.png"):
		background_texture = load("res://background.png")
	elif FileAccess.file_exists("res://background.jpg"):
		background_texture = load("res://background.jpg")
	
	if background_texture:
		# Resmi ekrana sığacak (yükseklik bazlı) şekilde ölçekle
		bg_scale = screen_size.y / float(background_texture.get_height())
		# Genişlik ekranı kaplamıyorsa en az ekran kadar yap
		if background_texture.get_width() * bg_scale < screen_size.x:
			bg_scale = screen_size.x / float(background_texture.get_width())

func setup_pixel_ui():
	recalculate_layout_zones()
	
	# 1. LOGO (PORTAL DASH)
	var title_container = VBoxContainer.new()
	title_container.alignment = BoxContainer.ALIGNMENT_CENTER
	title_container.add_theme_constant_override("separation", 0) # Sıfır boşluk, spacer ile kontrol edilecek
	# Önceki 120 yetmemiş, 160 yapalım ve butonlardan uzaklaşsın
	title_container.position = Vector2(0, area_top.position.y + (160 * ui_scale))
	title_container.size = Vector2(screen_size.x, 150 * ui_scale)
	add_child(title_container)

	var l_portal = Label.new()
	l_portal.text = "PORTAL"
	l_portal.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l_portal.add_theme_font_size_override("font_size", int(64 * ui_scale))
	# Kullanıcı beyazımsı istedi (Eski logo stili)
	l_portal.add_theme_color_override("font_color", Color("#e0e0e0")) 
	l_portal.add_theme_color_override("font_shadow_color", Color("#404040"))
	l_portal.add_theme_constant_override("shadow_offset_y", 4)
	
	# FONT FIX: Logo her zaman Pixel Art kalmali
	if ResourceLoader.exists(FONT_PATH):
		var pixel_font = load(FONT_PATH)
		l_portal.add_theme_font_override("font", pixel_font)
		
	title_container.add_child(l_portal)
	
	var l_dash = Label.new()
	l_dash.text = "DASH"
	l_dash.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l_dash.add_theme_font_size_override("font_size", int(64 * ui_scale))
	# Beyazımsı ama hafif farklı ton olabilir veya aynı
	l_dash.add_theme_color_override("font_color", Color("#ffffff"))
	l_dash.add_theme_color_override("font_shadow_color", Color("#801020")) # Hafif kırmızı gölge kalsın (Dash hissiyatı)
	l_dash.add_theme_constant_override("shadow_offset_y", 4)
	
	if ResourceLoader.exists(FONT_PATH):
		var pixel_font = load(FONT_PATH)
		l_dash.add_theme_font_override("font", pixel_font)
		
	# PORTAL ve DASH arasına 10 piksel boşluk ekle
	var dash_spacer = Control.new()
	dash_spacer.custom_minimum_size.y = 10 * ui_scale
	title_container.add_child(dash_spacer)
	title_container.add_child(l_dash)

	# 1. OYNA BUTONU
	play_btn = create_css_button(Global.get_text("PLAY"), C_PLAY_BG, C_PLAY_HOVER, C_PLAY_INNER_DK, int(6 * ui_scale), int(24 * ui_scale))
	play_btn.custom_minimum_size = Vector2(280, 85) * ui_scale
	# Eski direkt başlatma yerine Mod Seçimi açılıyor -> İPTAL, Direkt Sonsuz Mod
	play_btn.pressed.connect(func():
		_on_start_pressed()
	)
	add_child(play_btn)
	
	# 2. MAĞAZA BUTONU
	store_btn = create_css_button(Global.get_text("SHOP"), C_STORE_BG, C_STORE_HOVER, C_STORE_INNER_DK, int(4 * ui_scale), int(14 * ui_scale))
	store_btn.custom_minimum_size = Vector2(200, 60) * ui_scale
	store_btn.pressed.connect(_on_store_pressed)
	add_child(store_btn)
	
	# 3. İKONLAR
	btn_rank = create_icon_button("rank")
	btn_rank.pressed.connect(_on_rank_pressed)
	add_child(btn_rank)

	btn_set = create_icon_button("settings")
	btn_set.pressed.connect(_on_settings_pressed)
	add_child(btn_set)
	
	# --- GÖREV BUTONU ---
	btn_mission = create_icon_button("mission")
	btn_mission.pressed.connect(_on_mission_pressed)
	add_child(btn_mission)
	
	# 4. DAILY CHEST
	btn_daily = DailyChestButton.new()
	btn_daily.pressed.connect(func():
		if SoundManager: SoundManager.play_click()
	)
	btn_daily.pressed.connect(_on_daily_pressed)
	var st = Global.check_daily_status()
	btn_daily.can_claim = st["can_claim"]
	btn_daily.is_open = not st["can_claim"]
	add_child(btn_daily)
	
	# 5. POPUP OVERLAY
	overlay = ColorRect.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0, 0, 0, 0.7)
	overlay.visible = false
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(overlay)
	
	# 5. POPUP'LARI OLUŞTUR (Hata önlemi: Sadece gerekli olanları baştan kuruyoruz)
	setup_shop_popup()
	setup_settings_popup()
	setup_daily_popup()
	# Mission, Detail ve Leaderboard dinamik açılabilir.
	
	update_button_scales()
	
	update_button_scales()
	
	# OTOMATIK POPUP KALDIRILDI
	# Kullanıcı oyun açıldığında direkt interaktif öğreticiye girecek (main.gd üzerinden)
	# if not Global.tutorial_shown:
	# 	show_tutorial()




func show_tutorial():
	tutorial_page = 0
	setup_tutorial_popup()

func setup_tutorial_popup():
	if tutorial_popup: tutorial_popup.queue_free()
	
	tutorial_popup = Control.new()
	tutorial_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	tutorial_popup.z_index = 40 # En üstte
	add_child(tutorial_popup)
	
	overlay.visible = true
	
	# Boyutlandırma
	var panel_w = min(400 * ui_scale, screen_size.x - 40)
	var panel_h = min(450 * ui_scale, screen_size.y - 60)
	var panel_size = Vector2(panel_w, panel_h)
	
	# Pixel Art Panel (Standard)
	var panel = create_popup_panel(panel_size)
	# MERKEZLEME: Ekranın tam ortasına koy
	panel.position = (screen_size - panel_size) / 2.0
	tutorial_popup.add_child(panel)
	
	# İçerik Container
	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_top", 15)
	margin.add_theme_constant_override("margin_bottom", 15)
	margin.add_theme_constant_override("margin_left", 15)
	margin.add_theme_constant_override("margin_right", 15)
	panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 15)
	margin.add_child(vbox)
	
	# Başlık
	var lbl_title = Label.new()
	lbl_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if custom_font: lbl_title.add_theme_font_override("font", custom_font)
	lbl_title.add_theme_font_size_override("font_size", int(20 * ui_scale))
	lbl_title.add_theme_color_override("font_color", Color("#ffd700")) # Altın Sarısı
	vbox.add_child(lbl_title)
	
	vbox.add_child(HSeparator.new())
	
	# Görsel (Ortalanmış)
	var vis_container = CenterContainer.new()
	vis_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(vis_container)
	
	var visual = TutorialVisual.new()
	visual.page = tutorial_page
	visual.custom_minimum_size = Vector2(250, 150) * ui_scale
	vis_container.add_child(visual)
	
	# Açıklama
	var lbl_desc = Label.new()
	lbl_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lbl_desc.custom_minimum_size = Vector2(panel_w - 40, 60 * ui_scale)
	if custom_font: lbl_desc.add_theme_font_override("font", custom_font)
	lbl_desc.add_theme_font_size_override("font_size", int(12 * ui_scale))
	lbl_desc.add_theme_color_override("font_color", Color.WHITE)
	vbox.add_child(lbl_desc)
	
	# Buton
	var btn_next = create_css_button("NEXT >", Color("#2e7d32"), Color("#1b5e20"), Color("#003300"), 4, int(14 * ui_scale))
	btn_next.custom_minimum_size = Vector2(140, 50) * ui_scale
	btn_next.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	btn_next.pressed.connect(_on_tutorial_next)
	vbox.add_child(btn_next)
	
	# İçerik Güncelleme
	if tutorial_page == 0:
		lbl_title.text = Global.get_text("TUTORIAL_WELCOME_TITLE")
		lbl_desc.text = Global.get_text("TUTORIAL_WELCOME_DESC")
		btn_next.text_val = Global.get_text("NEXT")
	
	elif tutorial_page == 1:
		lbl_title.text = Global.get_text("TUTORIAL_ENEMIES_TITLE")
		lbl_desc.text = Global.get_text("TUTORIAL_ENEMIES_DESC")
		btn_next.text_val = Global.get_text("NEXT")

	elif tutorial_page == 2:
		lbl_title.text = Global.get_text("TUTORIAL_BUFFS_TITLE")
		lbl_desc.text = Global.get_text("TUTORIAL_BUFFS_DESC")
		btn_next.text_val = Global.get_text("NEXT")

	elif tutorial_page == 3:
		lbl_title.text = Global.get_text("TUTORIAL_CONTROLS_TITLE")
		lbl_desc.text = Global.get_text("TUTORIAL_CONTROLS_DESC")
		btn_next.text_val = Global.get_text("LETS_START")
		
		# --- PLAY TUTORIAL BUTTON ---
		var btn_play_tut = create_css_button(Global.get_text("PLAY_TUTORIAL"), Color("#0277bd"), Color("#01579b"), Color("#002f6c"), 4, int(14 * ui_scale))
		btn_play_tut.custom_minimum_size = Vector2(160, 50) * ui_scale
		btn_play_tut.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		# Mevcut "Başla/Kapat" butonunun altına ekle
		vbox.add_child(btn_play_tut)
		
		btn_play_tut.pressed.connect(func():
			if SoundManager: SoundManager.play_click()
			# Öğreticiyi zorla başlat
			Global.force_tutorial_start = true
			get_tree().change_scene_to_file("res://main.tscn")
		)
	
	btn_next.queue_redraw()

func _on_tutorial_next():
	tutorial_page += 1
	if tutorial_page > 3:
		if tutorial_popup: tutorial_popup.queue_free()
		overlay.visible = false
		
		# Tutorial tamamlandı, kaydet
		if not Global.tutorial_shown:
			Global.tutorial_shown = true
			Global.save_game()
	else:
		setup_tutorial_popup() # Yeniden çizerek sayfayı güncelle

func recalculate_layout_zones():
	screen_size = get_viewport_rect().size
	
	# Dinamik Scaling (Baz Genişlik: 500px)
	ui_scale = clamp(screen_size.x / 500.0, 0.6, 1.4)

	var h = screen_size.y
	area_top = Rect2(0, 0, screen_size.x, h * 0.40)
	area_mid = Rect2(0, h * 0.40, screen_size.x, h * 0.30)
	area_bot = Rect2(0, h * 0.70, screen_size.x, h * 0.30)
	
	update_button_scales()

func update_button_scales():
	if not play_btn: return
	
	# Buton boyut ve font güncellemeleri
	play_btn.custom_minimum_size = Vector2(280, 85) * ui_scale
	play_btn.font_size = int(24 * ui_scale)
	play_btn.border_width = int(6 * ui_scale)
	
	store_btn.custom_minimum_size = Vector2(200, 60) * ui_scale
	store_btn.font_size = int(14 * ui_scale)
	store_btn.border_width = int(4 * ui_scale)
	
	var icon_size = Vector2(70, 70) * ui_scale
	btn_rank.custom_minimum_size = icon_size
	btn_rank.size = icon_size
	btn_set.custom_minimum_size = icon_size
	btn_set.size = icon_size
	
	btn_mission.custom_minimum_size = icon_size
	btn_mission.size = icon_size
	
	btn_daily.custom_minimum_size = icon_size
	btn_daily.size = icon_size

func _process(delta):
	time_elapsed += delta
	var vp_size = get_viewport_rect().size
	if vp_size != screen_size:
		recalculate_layout_zones()
	
	# Scroll background variable update
	if background_texture:
		bg_scroll_x -= bg_scroll_speed * delta
		var scaled_w = background_texture.get_width() * bg_scale
		if bg_scroll_x <= -scaled_w:
			bg_scroll_x += scaled_w
	
	blink_timer += delta
	if not is_blinking:
		if blink_timer >= next_blink_time:
			is_blinking = true
			blink_timer = 0.0
	else:
		if blink_timer >= 0.15:
			is_blinking = false
			blink_timer = 0.0
			next_blink_time = randf_range(2.0, 5.0)
	
	var center_x = vp_size.x / 2.0
	
	# Dinamik Y konumlandırma:
	play_btn.position = Vector2(center_x - play_btn.custom_minimum_size.x / 2.0, area_bot.position.y + (10 * ui_scale))
	store_btn.position = Vector2(center_x - store_btn.custom_minimum_size.x / 2.0, play_btn.position.y + play_btn.custom_minimum_size.y + (20 * ui_scale))
	
	var margin = 20.0
	btn_rank.position = Vector2(margin, margin)
	btn_set.position = Vector2(vp_size.x - btn_set.size.x - margin, margin)
	
	# --- GÖREV BUTONU KONUMLANDIRMA ---
	if btn_mission:
		btn_mission.position = Vector2(vp_size.x - btn_mission.size.x - margin, margin + btn_set.size.y + 10 * ui_scale)
		btn_mission.queue_redraw()
	
	if btn_daily:
		btn_daily.position = Vector2(margin, vp_size.y - btn_daily.size.y - margin)

	update_background_effects(delta, vp_size)
	queue_redraw()

func update_background_effects(delta, vp_size):
	for s in stars:
		s["pos"].y += s["speed"] * delta
		if s["pos"].y > vp_size.y:
			s["pos"].y = -10
			s["pos"].x = randf() * vp_size.x
	
	if randf() < 0.02: # Parçacık üretme sıklığı azaltıldı (0.05 -> 0.02)
		particles.append({
			"pos": Vector2(randf() * vp_size.x, vp_size.y + 10),
			"vel": Vector2(randf_range(-5, 5), randf_range(-15, -30)), # Hız azaltıldı
			"size": randf_range(2, 4),
			"life": 2.5 # Ömür uzatıldı (yavaşladığı için)
		})
	for i in range(particles.size()-1, -1, -1):
		var p = particles[i]
		p["pos"] += p["vel"] * delta
		p["life"] -= delta
		p["size"] -= delta
		if p["life"] <= 0: particles.remove_at(i)

func _draw():
	if background_texture:
		var scaled_w = background_texture.get_width() * bg_scale
		var scaled_h = background_texture.get_height() * bg_scale
		var rect1 = Rect2(Vector2(bg_scroll_x, 0), Vector2(scaled_w, scaled_h))
		var rect2 = Rect2(Vector2(bg_scroll_x + scaled_w, 0), Vector2(scaled_w, scaled_h))
		draw_texture_rect(background_texture, rect1, false)
		draw_texture_rect(background_texture, rect2, false)
	else:
		draw_rect(Rect2(Vector2.ZERO, screen_size), C_BG)
	
	# Parallax var diye yıldızları ve parçacıkları kapatmıyoruz, atmosferik olsun
	for s in stars:
		draw_rect(Rect2(s["pos"], Vector2(s["size"], s["size"])), s["color"])
	for p in particles:
		var col = C_HERO_MAIN
		col.a = p["life"] * 0.5
		# Glow efekti: Ana parçacığın etrafına yarı şeffaf mor haleler çiz
		draw_rect(Rect2(p["pos"] - Vector2(2,2), Vector2(p["size"]+4, p["size"]+4)), Color(0.5, 0, 0.5, col.a * 0.3)) # Mor Glow
		draw_rect(Rect2(p["pos"], Vector2(p["size"], p["size"])), col)

	# Logo artık Label olarak ekleniyor setup_pixel_ui içinde
	pass

	# ZEMİN VE KARAKTER
	var showcase_center = area_mid.get_center()
	showcase_center.y -= 20 * ui_scale
	
	var char_scale = 3.4 * min(ui_scale, 1.1) 
	var platform_info = draw_custom_platform(showcase_center, char_scale)
	var char_pos_adjusted = Vector2(showcase_center.x, platform_info.surface_y - (15 * char_scale))
	
	if SkinManager:
		SkinManager.draw_skin_preview(self, char_pos_adjusted, char_scale, Global.current_skin, time_elapsed, is_blinking)
	else:
		draw_user_pixel_hero(char_pos_adjusted, char_scale)
	
	# SKOR GÖSTERGESİ
	draw_highscore_display()

func draw_pixel_logo(center):
	var text = "TOMB\nRUNNER"
	var font = custom_font if custom_font else get_theme_default_font()
	var base_font_size = 55
	var font_size = int(base_font_size * min(ui_scale, 1.0))
	var line_spacing = int(6 * ui_scale)
	var lines = text.split("\n")
	
	var total_h = (lines.size() * font_size) + ((lines.size() - 1) * line_spacing)
	var start_y = center.y - (total_h / 2.0)
	
	for i in range(lines.size()):
		var line = lines[i]
		var str_size = font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
		var pos = Vector2(center.x - str_size.x / 2.0, start_y + (i * (font_size + line_spacing)))
 
		draw_string(font, pos + Vector2(6, 6), line, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color("#222034"))
		draw_string_outline(font, pos, line, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, 10, Color.BLACK)
		draw_string(font, pos, line, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, C_HERO_MAIN)
		draw_string(font, pos + Vector2(2, 2), line, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.WHITE.darkened(0.1))

func draw_user_pixel_hero(center_pos, s_val):
	var s = Vector2(s_val, s_val)
	var time = Time.get_ticks_msec()
	var bounce = sin(time / 600.0) * 2.0 * s_val 
	
	draw_rect(Rect2(center_pos + (Vector2(-8, 12) * s), Vector2(6, 6) * s), C_HERO_DARK)
	draw_rect(Rect2(center_pos + (Vector2(2, 12) * s), Vector2(6, 6) * s), C_HERO_DARK)
	var body_pos = center_pos + Vector2(-7 * s_val, (6 * s_val) + bounce)
	draw_rect(Rect2(body_pos, Vector2(14, 10) * s), C_HERO_MAIN)
	draw_rect(Rect2(center_pos + Vector2(-14 * s_val, (8 * s_val) + bounce), Vector2(5, 5) * s), C_HERO_MAIN)
	draw_rect(Rect2(center_pos + Vector2(9 * s_val, (8 * s_val) + bounce), Vector2(5, 5) * s), C_HERO_MAIN)
	var head_pos = center_pos + Vector2(-13 * s_val, (-14 * s_val) + bounce)
	var head_size = Vector2(26, 24) * s
	draw_rect(Rect2(head_pos, head_size), C_HERO_MAIN)
	draw_rect(Rect2(head_pos.x, head_pos.y + head_size.y - (4*s_val), head_size.x, 4*s_val), C_HERO_DARK)
	draw_rect(Rect2(head_pos, head_size), C_OUTLINE, false, 2.0 * s_val)
	var mask_pos = Vector2(head_pos.x + (4*s_val), head_pos.y + (6*s_val))
	draw_rect(Rect2(mask_pos, Vector2(18, 12) * s), C_MASK_BG)
	if not is_blinking:
		draw_rect(Rect2(mask_pos.x + (2*s_val), mask_pos.y + (3*s_val), 4*s_val, 6*s_val), C_EYES)
		draw_rect(Rect2(mask_pos.x + (12*s_val), mask_pos.y + (3*s_val), 4*s_val, 6*s_val), C_EYES)
	else:
		draw_rect(Rect2(mask_pos.x + (2*s_val), mask_pos.y + (5*s_val), 4*s_val, 2*s_val), C_HERO_DARK)
		draw_rect(Rect2(mask_pos.x + (12*s_val), mask_pos.y + (5*s_val), 4*s_val, 2*s_val), C_HERO_DARK)

func load_platform_texture():
	if platform_texture:
		return
	var path = "res://zemin.png"
	if not ResourceLoader.exists(path):
		return
	
	# Fix Export Issue: Use standard load() for resources within res://
	var tex = load(path)
	if tex is Texture2D:
		platform_texture = tex
		var img = tex.get_image() # Safe to get image from loaded texture
		
		# Metadata calculation
		platform_surface_row = 0
		var w = img.get_width()
		var h = img.get_height()
		var threshold = int(float(w) * 0.25)
		for y in range(h):
			var count = 0
			for x in range(w):
				if img.get_pixel(x, y).a > 0.5:
					count += 1
			if count >= threshold:
				platform_surface_row = y
				break

func draw_custom_platform(center, s):
	load_platform_texture()
	if platform_texture == null:
		return {"surface_y": center.y - (10.0 * s)}
	var tex_size = platform_texture.get_size()
	var target_w = 50.0 * s # %50 küçültüldü
	var p_scale = max(0.5, target_w / tex_size.x) # kesirli ölçek izinli
	var draw_size = tex_size * p_scale
	var desired_surface_y = center.y - (6.0 * s)
	var draw_pos = Vector2(
		round(center.x - (draw_size.x / 2.0)),
		round(desired_surface_y - float(platform_surface_row) * p_scale)
	)
	draw_texture_rect(platform_texture, Rect2(draw_pos, draw_size), false)
	return {"surface_y": desired_surface_y}

func create_css_button(text, bg_col, hover_col, inner_dark, border_w, font_s):
	var btn = CSSPixelButton.new()
	btn.text_val = text
	btn.col_bg = bg_col
	btn.col_hover = hover_col
	btn.col_inner_dark = inner_dark
	btn.border_width = border_w
	btn.font_size = font_s
	
	if custom_font:
		btn.add_theme_font_override("font", custom_font)
	
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn.focus_mode = Control.FOCUS_NONE
	
	# Click sesi ekle
	btn.pressed.connect(func():
		if SoundManager: SoundManager.play_click()
	)
	
	return btn

func fit_css_button_text(btn: CSSPixelButton, padding: float = 16.0):
	var font = btn.get_theme_font("font")
	if font == null:
		return
	var max_w = max(0.0, btn.custom_minimum_size.x - padding)
	var fs = btn.font_size
	while fs > 8:
		var sz = font.get_string_size(btn.text_val, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
		if sz.x <= max_w:
			break
		fs -= 1
	btn.font_size = fs

func create_icon_button(type):
	var btn = PixelIconButton.new()
	btn.icon_type = type
	var s = Vector2(70, 70) * ui_scale
	btn.custom_minimum_size = s
	btn.size = s
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	# Click sesi ekle
	btn.pressed.connect(func():
		if SoundManager: SoundManager.play_click()
	)
	
	return btn

func _on_start_pressed():
	var path = "res://main.tscn"
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)
	else:
		print("HATA: main.tscn bulunamadı!")

func _on_store_pressed():
	# Her zaman skins sekmesi ile açılacak, default argüman
	setup_shop_popup("skins")
	show_popup(shop_popup)

func _on_rank_pressed():
	# Eğer zaten veri varsa hemen göster, arka planda güncelle
	if Global.leaderboard_data.size() > 0:
		leaderboard_loading = false
		leaderboard_error = false
	else:
		leaderboard_loading = true
		leaderboard_error = false
	
	# Arka planda güncelleme yap
	if LeaderboardManager and LeaderboardManager.has_method("fetch_leaderboard"):
		LeaderboardManager.fetch_leaderboard()
	
	setup_leaderboard_popup()
	show_popup(leaderboard_popup)

func _on_settings_pressed():
	show_popup(settings_popup)

# --- GÖREV BUTONU FONKSİYONU (DÜZELTİLDİ) ---
func _on_mission_pressed():
	setup_mission_popup()

func _init_missions():
	var default_missions = {
		"m1": {"desc": "M_COLLECT_COINS_DESC", "type": "lifetime_coins", "target": 100, "reward": 50, "level": 1, "is_daily": false},
		"m2": {"desc": "M_RUNNER_DESC", "type": "total_steps", "target": 500, "reward": 100, "level": 1, "is_daily": false},
		"d_coins": {"desc": "M_DAILY_GOLD_DESC", "type": "daily_coins", "target": 200, "reward": 50, "level": 1, "is_daily": true, "claimed_day": -1},
		"d_steps": {"desc": "M_DAILY_WALKER_DESC", "type": "daily_steps", "target": 2000, "reward": 100, "level": 1, "is_daily": true, "claimed_day": -1}
	}
	
	var m = Global.get("missions")
	if m == null or typeof(m) != TYPE_DICTIONARY:
		m = {}

	# Eski/İstenmeyen görevleri temizle
	var to_remove_keys = ["m3", "m4", "d1"]
	for key in to_remove_keys:
		if m.has(key):
			m.erase(key)

	# Yeni görevleri ekle
	for k in default_missions:
		if not m.has(k):
			m[k] = default_missions[k].duplicate(true)
	
	Global.set("missions", m)
	Global.save_game()

func _normalize_missions():
	var missions = Global.get("missions")
	if missions == null or typeof(missions) != TYPE_DICTIONARY:
		return
	var defaults = {
		"m1": "M_COLLECT_COINS_DESC",
		"m2": "M_RUNNER_DESC",
		"d_coins": "M_DAILY_GOLD_DESC",
		"d_steps": "M_DAILY_WALKER_DESC"
	}
	for k in missions.keys():
		if defaults.has(k):
			missions[k]["desc"] = defaults[k]
	Global.set("missions", missions)
	Global.save_game()

func setup_mission_popup():
	if Global.has_method("check_daily_stats_reset"):
		Global.check_daily_stats_reset()
	_normalize_missions()
	if mission_popup: mission_popup.queue_free()
	mission_popup = Control.new()
	mission_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	mission_popup.z_index = 25
	add_child(mission_popup)
	
	# Black Overlay
	overlay.visible = true
	
	# Center Container for robust centering
	var center_cont = CenterContainer.new()
	center_cont.set_anchors_preset(Control.PRESET_FULL_RECT)
	mission_popup.add_child(center_cont)
	
	# Calculate dimensions
	var p_w = min(500 * ui_scale, screen_size.x * 0.95)
	var p_h = min(600 * ui_scale, screen_size.y * 0.85)
	
	var panel = create_popup_panel(Vector2(p_w, p_h))
	# Reset position as CenterContainer controls it
	panel.position = Vector2.ZERO
	center_cont.add_child(panel)
	
	var margin = MarginContainer.new()
	var m_val = 20 * ui_scale
	margin.add_theme_constant_override("margin_top", m_val); margin.add_theme_constant_override("margin_bottom", m_val)
	margin.add_theme_constant_override("margin_left", m_val); margin.add_theme_constant_override("margin_right", m_val)
	panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 15 * ui_scale)
	margin.add_child(vbox)
	
	# HEADER
	var header = HBoxContainer.new()
	vbox.add_child(header)
	
	var title = Label.new()
	title.text = Global.get_text("MISSIONS") if Global.has_method("get_text") else "MISSIONS"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", int(24 * ui_scale))
	if custom_font: title.add_theme_font_override("font", custom_font)
	title.add_theme_color_override("font_color", Color("#ffd700"))
	header.add_child(title)
	
	var close_btn = create_css_button("X", Color("#e53935"), Color("#ef5350"), Color("#b71c1c"), 2, int(16 * ui_scale))
	close_btn.custom_minimum_size = Vector2(40, 40) * ui_scale
	close_btn.pressed.connect(func(): 
		mission_popup.queue_free()
		overlay.visible = false
	)
	header.add_child(close_btn)
	
	vbox.add_child(HSeparator.new())
	
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vbox.add_child(scroll)
	
	var list = VBoxContainer.new()
	list.add_theme_constant_override("separation", 10 * ui_scale)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)
	
	var missions = Global.get("missions")
	if missions == null or missions.size() == 0:
		_init_missions()
		missions = Global.get("missions")

	if missions:
		for k in missions:
			create_mission_row(list, k, missions[k])
			
	# Bottom Spacer
	var spacer2 = Control.new()
	spacer2.custom_minimum_size = Vector2(0, 20 * ui_scale)
	list.add_child(spacer2)

func create_mission_row(parent, key, data):
	var row = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color("#2a2a35")
	style.border_width_left = 4
	style.border_color = Color("#3e3e5e")
	style.set_corner_radius_all(4)
	row.add_theme_stylebox_override("panel", style)
	parent.add_child(row)
	
	var m = MarginContainer.new()
	m.add_theme_constant_override("margin_left", 10); m.add_theme_constant_override("margin_right", 10)
	m.add_theme_constant_override("margin_top", 10); m.add_theme_constant_override("margin_bottom", 10)
	row.add_child(m)
	
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 15)
	m.add_child(hbox)
	
	# Icon
	var icon_rect = MissionIcon.new()
	icon_rect.custom_minimum_size = Vector2(32, 32)
	hbox.add_child(icon_rect)
	
	# Info
	var info_vbox = VBoxContainer.new()
	info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(info_vbox)
	
	var desc_lbl = Label.new()
	var lvl_txt = Global.get_text("LEVEL_SHORT") if Global.has_method("get_text") else "LVL"
	desc_lbl.text = "%s (%s %d)" % [Global.get_text(data["desc"]), lvl_txt, int(data.get("level", 1))]
	if custom_font: desc_lbl.add_theme_font_override("font", custom_font)
	desc_lbl.add_theme_font_size_override("font_size", 12)
	desc_lbl.add_theme_color_override("font_color", Color("#ffffff"))
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_lbl.custom_minimum_size.x = 100 * ui_scale # Allow shrink
	info_vbox.add_child(desc_lbl)
	
	# Progress Logic
	var current = 0
	var target = data["target"]
	
	if data["type"] == "balance_coins" or data["type"] == "total_coins": # Legacy support for total_coins
		current = Global.coins
	elif data["type"] == "lifetime_coins":
		current = Global.get("total_coins_collected") if Global.get("total_coins_collected") else 0
	elif data["type"] == "total_steps":
		current = Global.get("total_steps") if Global.get("total_steps") else 0
	elif data["type"] == "daily_coins":
		current = Global.daily_stats.get("coins", 0)
	elif data["type"] == "daily_steps":
		current = Global.daily_stats.get("steps", 0)
	
	if data.get("is_daily", false):
		var today = int(Time.get_unix_time_from_system() / 86400)
		if data.get("claimed_day") == today:
			# Eğer ödül alındıysa progress'i tam göster (Görsel olarak)
			current = target
	
	var progress_lbl = Label.new()
	progress_lbl.text = "%d / %d" % [min(current, target), target]
	progress_lbl.add_theme_font_size_override("font_size", 10)
	progress_lbl.add_theme_color_override("font_color", Color("#aaaaaa"))
	if custom_font: progress_lbl.add_theme_font_override("font", custom_font)
	info_vbox.add_child(progress_lbl)
	
	# Reward & Button
	var reward = int(data["reward"])
	var is_done = current >= target
	var is_claimed = false
	if data.get("is_daily", false):
		var today = int(Time.get_unix_time_from_system() / 86400)
		is_claimed = (data.get("claimed_day") == today)

	if not is_claimed:
		# Button container without text (handled by children)
		var btn = create_css_button("", Color("#41c741"), Color("#42b442"), Color("#2a6d2a"), 2, 12)
		# Scale button size to ensure text fits
		btn.custom_minimum_size = Vector2(120, 45) * ui_scale
		btn.disabled = not is_done
		
		var h_center = HBoxContainer.new()
		h_center.set_anchors_preset(Control.PRESET_FULL_RECT)
		h_center.alignment = BoxContainer.ALIGNMENT_CENTER
		h_center.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h_center.add_theme_constant_override("separation", 5)
		btn.add_child(h_center)

		var l_reward = Label.new()
		l_reward.text = str(reward)
		if custom_font: l_reward.add_theme_font_override("font", custom_font)
		l_reward.add_theme_font_size_override("font_size", 12)

		var ci = CoinIcon.new()
		ci.is_static = true
		ci.custom_minimum_size = Vector2(16,16)
		ci.mouse_filter = Control.MOUSE_FILTER_IGNORE

		if not is_done:
			btn.col_bg = Color("#555555")
			btn.col_hover = Color("#555555")
			btn.col_inner_dark = Color("#333333")
			l_reward.add_theme_color_override("font_color", Color.GRAY)
		else:
			btn.col_bg = Color("#ffd700")
			btn.col_hover = Color("#ffe082")
			btn.col_inner_dark = Color("#ffb300")
			l_reward.add_theme_color_override("font_color", Color.BLACK)
		
		h_center.add_child(l_reward)
		h_center.add_child(ci)

		btn.pressed.connect(func(): _on_claim_mission(key, data, btn))
		hbox.add_child(btn)
	else:
		var done_lbl = Label.new()
		done_lbl.text = Global.get_text("DONE") if Global.has_method("get_text") else "DONE"
		done_lbl.add_theme_color_override("font_color", Color.GREEN)
		if custom_font: done_lbl.add_theme_font_override("font", custom_font)
		hbox.add_child(done_lbl)

func _on_claim_mission(_key, data, btn):
	# Give Reward
	Global.coins += data["reward"]
	
	# Level Up or Daily Mark
	if data.get("is_daily", false):
		# Unix epoch day kullanıyoruz artık
		data["claimed_day"] = int(Time.get_unix_time_from_system() / 86400)
	else:
		data["level"] += 1
		data["target"] *= 2
		data["reward"] *= 2
	
	Global.save_game()
	
	# Update UI
	btn.disabled = true
	# Hide children (HBox with Icon) so we can show simple text
	for c in btn.get_children():
		c.visible = false
	
	btn.text_val = "CLAIMED"
	btn.col_bg = Color("#555555")
	btn.queue_redraw()
	store_btn.queue_redraw() # Coin display update
	
	# Refresh popup after delay
	await get_tree().create_timer(0.6).timeout
	setup_mission_popup()

func show_popup(popup: Control):
	overlay.visible = true
	popup.visible = true

func close_popup(popup_node):
	if popup_node:
		popup_node.visible = false
	if not version_blocking_active:
		# Eğer başka bir popup açıksa overlay'i açık tut
		var any_popup_open = false
		if shop_popup and shop_popup.visible:
			any_popup_open = true
		if leaderboard_popup and leaderboard_popup.visible:
			any_popup_open = true
		if settings_popup and settings_popup.visible:
			any_popup_open = true
		if daily_popup and daily_popup.visible:
			any_popup_open = true
		if mission_popup and mission_popup.visible:
			any_popup_open = true
		if skin_detail_popup and skin_detail_popup.visible:
			any_popup_open = true
		if tutorial_popup and tutorial_popup.visible:
			any_popup_open = true
		if gift_code_popup and gift_code_popup.visible:
			any_popup_open = true
		if admin_panel_popup and admin_panel_popup.visible:
			any_popup_open = true
		
		if not any_popup_open:
			overlay.visible = false

func hide_all_popups():
	if not version_blocking_active:
		overlay.visible = false
	if shop_popup: shop_popup.visible = false
	if settings_popup: settings_popup.visible = false
	if leaderboard_popup: leaderboard_popup.visible = false
	if daily_popup: daily_popup.visible = false

func draw_coin_display():
	var font = custom_font if custom_font else get_theme_default_font()
	var fs = int(20 * ui_scale)
	var safe_y = 20.0 + (70.0 * ui_scale) + (30.0 * ui_scale)
	var pos = Vector2(screen_size.x - 20 * ui_scale, safe_y)
	
	var coin_size = 16 * ui_scale
	var coin_center = pos - Vector2(60 * ui_scale, -fs/4.0)
	draw_rect(Rect2(coin_center.x - coin_size/2, coin_center.y - coin_size/2, coin_size, coin_size), Color("#c79d41"))
	draw_rect(Rect2(coin_center.x - coin_size/2 + 2, coin_center.y - coin_size/2 + 2, coin_size - 4, coin_size - 4), Color("#ffd54f"))
	
	var coin_text = str(Global.coins)
	var text_size = font.get_string_size(coin_text, HORIZONTAL_ALIGNMENT_RIGHT, -1, fs)
	draw_string(font, pos - Vector2(text_size.x, 0), coin_text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color("#ffd54f"))

func draw_highscore_display():
	var font = custom_font if custom_font else get_theme_default_font()
	var fs = int(16 * ui_scale)
	var text = Global.get_text("HIGHSCORE") + ": " + str(Global.high_score)
	var text_size = font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, fs)
	# 25 piksel aşağı kaydırıldı
	var pos = Vector2(screen_size.x / 2 - text_size.x / 2, screen_size.y * 0.28 + (25 * ui_scale))
	draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color("#ffd54f"))

# --- POPUP KURULUMLARI (DÜZELTİLMİŞ) ---
func setup_shop_popup(start_tab = "skins"):
	if shop_popup: shop_popup.queue_free() # Yeniden oluştur ki tab sıfırlansın
	
	shop_popup = Control.new()
	shop_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	shop_popup.visible = false
	add_child(shop_popup)
	
	# Dimmer removed to avoid double darkening
	
	# Ekrana taşmaması için panel boyutunu ekrana oranla ayarla (ui_scale'den bağımsız)
	# Ekrana taşmaması için yüzde bazlı boyut (hem skins hem skills için)
	var panel_w = screen_size.x * 0.86
	var panel_h = screen_size.y * 0.8
	var panel_size = Vector2(panel_w, panel_h)
	
	var center_cont = CenterContainer.new()
	center_cont.set_anchors_preset(Control.PRESET_FULL_RECT)
	shop_popup.add_child(center_cont)
	
	var panel = create_popup_panel(panel_size)
	center_cont.add_child(panel)
	
	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	var m_val = int(4 * ui_scale)
	margin.add_theme_constant_override("margin_top", m_val)
	margin.add_theme_constant_override("margin_bottom", m_val)
	margin.add_theme_constant_override("margin_left", m_val)
	margin.add_theme_constant_override("margin_right", m_val)
	panel.add_child(margin)
	
	var main_vbox = VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", int(10 * ui_scale))
	margin.add_child(main_vbox)
	
	# --- HEADER & TABS ---
	var header = HBoxContainer.new()
	main_vbox.add_child(header)
	
	var tabs_hbox = HBoxContainer.new()
	tabs_hbox.add_theme_constant_override("separation", 10)
	header.add_child(tabs_hbox)
	
	var btn_skins = create_css_button(Global.get_text("SKINS") if Global.has_method("get_text") else "SKINS", Color("#4a4a6a"), Color("#5a5a7a"), Color("#3a3a5a"), 2, int(14*ui_scale))
	btn_skins.custom_minimum_size = Vector2(110, 38) * ui_scale
	fit_css_button_text(btn_skins, 14 * ui_scale)
	tabs_hbox.add_child(btn_skins)
	
	var btn_skills = create_css_button(Global.get_text("SKILLS"), Color("#4a4a6a"), Color("#5a5a7a"), Color("#3a3a5a"), 2, int(14*ui_scale))
	btn_skills.custom_minimum_size = Vector2(110, 38) * ui_scale
	fit_css_button_text(btn_skills, 14 * ui_scale)
	tabs_hbox.add_child(btn_skills)
	
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(spacer)
	
	var coin_cont = HBoxContainer.new()
	var c_icon = CoinIcon.new()
	c_icon.is_static = true
	c_icon.custom_minimum_size = Vector2(24,24) * ui_scale
	coin_cont.add_child(c_icon)
	var c_lbl = Label.new()
	c_lbl.text = str(Global.coins)
	c_lbl.add_theme_font_size_override("font_size", int(20*ui_scale))
	if custom_font: c_lbl.add_theme_font_override("font", custom_font)
	c_lbl.add_theme_color_override("font_color", Color("#ffd700"))
	coin_cont.add_child(c_lbl)
	header.add_child(coin_cont)
	
	var sp_c = Control.new()
	sp_c.custom_minimum_size = Vector2(10,0)
	header.add_child(sp_c)
	
	var close_btn = create_css_button("X", Color("#e53935"), Color("#c62828"), Color("#b71c1c"), 2, int(16 * ui_scale))
	close_btn.custom_minimum_size = Vector2(40, 40) * ui_scale
	close_btn.pressed.connect(hide_all_popups)
	header.add_child(close_btn)
	
	main_vbox.add_child(HSeparator.new())
	
	var content_area = MarginContainer.new()
	content_area.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(content_area)
	
	# 1. SKINS CONTAINER
	var cont_skins = ScrollContainer.new()
	cont_skins.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cont_skins.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cont_skins.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	cont_skins.theme = create_pixel_scrollbar_theme()
	
	var skin_vbox = VBoxContainer.new()
	skin_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cont_skins.add_child(skin_vbox)
	
	var grid = GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", int(4 * ui_scale))
	grid.add_theme_constant_override("v_separation", int(12 * ui_scale))
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	if SkinManager:
		var all_skins = SkinManager.get_all_skins()
		for i in range(all_skins.size()):
			for j in range(all_skins.size() - 1):
				var s1 = SkinManager.get_skin_data(all_skins[j])
				var s2 = SkinManager.get_skin_data(all_skins[j+1])
				if s1["price"] > s2["price"]:
					var temp = all_skins[j]; all_skins[j] = all_skins[j+1]; all_skins[j+1] = temp
		for skin_id in all_skins:
			grid.add_child(create_skin_card(skin_id))
			
	skin_vbox.add_child(grid)
	
	# Add padding at bottom
	var spacer_bottom = Control.new()
	spacer_bottom.custom_minimum_size = Vector2(0, 15 * ui_scale)
	skin_vbox.add_child(spacer_bottom)
	content_area.add_child(cont_skins)
	
	# 2. SKILLS CONTAINER (DÜZELTİLDİ: COIN ICON & INT PRICE)
	var cont_skills = ScrollContainer.new()
	cont_skills.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cont_skills.visible = false
	cont_skills.theme = create_pixel_scrollbar_theme()
	
	var skill_vbox = VBoxContainer.new()
	skill_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	skill_vbox.add_theme_constant_override("separation", 15)
	
	skill_vbox.add_child(create_upgrade_card("talent_max_hp", "MAX_HEALTH", 8, 500, Color("#e53935")))
	skill_vbox.add_child(create_upgrade_card("talent_score_value", "SCORE_VALUE", 5, 300, Color("#ffd700")))
	skill_vbox.add_child(create_upgrade_card("talent_luck", "LUCK", 10, 250, Color("#4b69ff")))
	
	# Padding at bottom
	var spacer_bottom_skills = Control.new()
	spacer_bottom_skills.custom_minimum_size = Vector2(0, 15 * ui_scale)
	skill_vbox.add_child(spacer_bottom_skills)
	
	cont_skills.add_child(skill_vbox)
	content_area.add_child(cont_skills)
	
	# Hediye Kodu Butonu (Sadece skills sekmesinde görünecek)
	var btn_gift_code = create_css_button(Global.get_text("GIFT_CODE"), Color("#9c27b0"), Color("#ab47bc"), Color("#7b1fa2"), 2, int(14 * ui_scale))
	btn_gift_code.custom_minimum_size = Vector2(0, 50) * ui_scale
	btn_gift_code.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn_gift_code.visible = false  # Başlangıçta gizli
	btn_gift_code.pressed.connect(show_gift_code_popup)
	main_vbox.add_child(btn_gift_code)
	
	shop_tab_content = {"skins": cont_skins, "skills": cont_skills}
	
	btn_skins.pressed.connect(func(): _switch_shop_tab("skins", btn_skins, btn_skills, btn_gift_code))
	btn_skills.pressed.connect(func(): _switch_shop_tab("skills", btn_skins, btn_skills, btn_gift_code))
	
	# Başlangıç Tabı
	_switch_shop_tab(start_tab, btn_skins, btn_skills, btn_gift_code)

func _switch_shop_tab(tab_name, btn1, btn2, gift_code_btn = null):
	for k in shop_tab_content:
		shop_tab_content[k].visible = (k == tab_name)
	
	# Gift code butonu sadece skills sekmesinde görünür
	if gift_code_btn:
		gift_code_btn.visible = (tab_name == "skills")
	
	var active_bg = Color("#41c741")
	var passive_bg = Color("#4a4a6a")
	
	btn1.col_bg = active_bg if tab_name == "skins" else passive_bg
	btn2.col_bg = active_bg if tab_name == "skills" else passive_bg
	btn1.queue_redraw()
	btn2.queue_redraw()

# --- YETENEK KARTI OLUŞTURMA (DÜZELTİLDİ: COIN ICON & GENİŞLİK) ---
func create_upgrade_card(key, title, max_lvl, base_price, color) -> Control:
	var current_lvl = Global.get(key) if Global.get(key) != null else 0
	if Global.get(key) == null: Global.set(key, 0)
	
	var next_price = int(base_price * (current_lvl + 1))
	var is_maxed = current_lvl >= max_lvl
	
	var p = PanelContainer.new()
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var style = StyleBoxFlat.new()
	style.bg_color = Color("#212129")
	style.border_color = color
	style.border_width_left = 4
	style.set_corner_radius_all(4)
	p.add_theme_stylebox_override("panel", style)
	
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)
	var m = MarginContainer.new()
	m.add_theme_constant_override("margin_left", 10); m.add_theme_constant_override("margin_right", 10)
	m.add_theme_constant_override("margin_top", 10); m.add_theme_constant_override("margin_bottom", 10)
	m.add_child(hbox)
	p.add_child(m)
	
	var vbox_info = VBoxContainer.new()
	vbox_info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var lbl_title = Label.new()
	# Translate description key
	lbl_title.text = Global.get_text(title)
	if custom_font: lbl_title.add_theme_font_override("font", custom_font)
	lbl_title.add_theme_color_override("font_color", color)
	lbl_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox_info.add_child(lbl_title)
	
	var lbl_lvl = Label.new()
	lbl_lvl.text = "Lvl %d/%d" % [current_lvl, max_lvl]
	lbl_lvl.add_theme_font_size_override("font_size", 12)
	lbl_lvl.add_theme_color_override("font_color", Color.GRAY)
	vbox_info.add_child(lbl_lvl)
	
	hbox.add_child(vbox_info)
	
	if not is_maxed:
		var btn = create_css_button("", Color("#41c741"), Color("#42b442"), Color("#2a6d2a"), 2, 12)
		btn.custom_minimum_size = Vector2(120, 44)
		
		# Layout for text + icon inside button
		var btn_layout = HBoxContainer.new()
		btn_layout.set_anchors_preset(Control.PRESET_FULL_RECT)
		btn_layout.alignment = BoxContainer.ALIGNMENT_CENTER
		btn_layout.mouse_filter = Control.MOUSE_FILTER_IGNORE
		btn_layout.add_theme_constant_override("separation", 5)
		btn.add_child(btn_layout)

		if Global.coins < next_price:
			btn.col_bg = Color("#b71c1c")
			btn.col_hover = Color("#b71c1c")
			btn.col_inner_dark = Color("#7f0000")
			btn.text_val = Global.get_text("NOT_ENOUGH") # Use builtin text for simple message
			btn.font_size = 8
			btn.disabled = true
		else:
			# Use container for price + icon
			var l_price = Label.new()
			l_price.text = str(next_price)
			if custom_font: l_price.add_theme_font_override("font", custom_font)
			l_price.add_theme_font_size_override("font_size", 12)
			btn_layout.add_child(l_price)

			var c_ico = CoinIcon.new()
			c_ico.custom_minimum_size = Vector2(20, 20)
			c_ico.is_static = true
			btn_layout.add_child(c_ico)
			
			btn.pressed.connect(func(): _on_upgrade_pressed(key, next_price, max_lvl))
		
		hbox.add_child(btn)
	else:
		var lbl_max = Label.new()
		lbl_max.text = Global.get_text("MAXED")
		lbl_max.add_theme_color_override("font_color", Color("#ffd700"))
		if custom_font: lbl_max.add_theme_font_override("font", custom_font)
		hbox.add_child(lbl_max)
		
	return p

func _on_upgrade_pressed(key, price, _max_lvl):
	if Global.coins >= price:
		Global.coins -= price
		var curr = Global.get(key)
		if curr == null: curr = 0
		Global.set(key, curr + 1)
		Global.save_game()
		
		# UI Yenile (Skills tabında kal)
		setup_shop_popup("skills")
		show_popup(shop_popup)

func create_skin_card(skin_id: String) -> Control:
	var skin_data = SkinManager.get_skin_data(skin_id)
	var is_owned = Global.owned_skins.has(skin_id)
	var is_selected = (Global.current_skin == skin_id)
	var price = skin_data["price"]
	var rarity = skin_data.get("rarity", "common")
	
	var skin_name = SkinManager.get_skin_name(skin_id)
	
	var btn = SkinCardButton.new()
	btn.custom_minimum_size = Vector2(0, 166) * ui_scale
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	btn.skin_id = skin_id
	btn.skin_name = skin_name
	btn.rarity = rarity
	btn.price = price
	btn.is_owned = is_owned
	btn.is_selected = is_selected
	btn.custom_font_ref = custom_font
	
	btn.pressed.connect(_on_skin_card_pressed.bind(skin_id, price))
	return btn

func _on_skin_card_pressed(skin_id, _price):
	setup_skin_detail_popup(skin_id)

# --- SKIN DETAY PENCERESİ (DÜZELTİLDİ: ÇÖKME YOK) ---
func setup_skin_detail_popup(skin_id):
	if skin_detail_popup: skin_detail_popup.queue_free()
	
	var data = SkinManager.get_skin_data(skin_id)
	var is_owned = Global.owned_skins.has(skin_id)
	
	skin_detail_popup = Control.new()
	skin_detail_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	skin_detail_popup.z_index = 30
	add_child(skin_detail_popup)
	
	# Black Overlay
	overlay.visible = true
	var dim = ColorRect.new()
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0, 0, 0, 0.7)
	skin_detail_popup.add_child(dim)
	
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	skin_detail_popup.add_child(center)
	
	# Daha kompakt ve güvenli boyutlandırma
	var safe_w = min(400, screen_size.x * 0.9)
	var safe_h = min(500, screen_size.y * 0.9)
	var panel = create_popup_panel(Vector2(safe_w, safe_h))
	center.add_child(panel)
	
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_top", 15)
	margin.add_theme_constant_override("margin_bottom", 15)
	margin.add_theme_constant_override("margin_left", 15)
	margin.add_theme_constant_override("margin_right", 15)
	panel.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	margin.add_child(vbox)
	
	# --- Header (Title + Close Button) ---
	var header_hbox = HBoxContainer.new()
	vbox.add_child(header_hbox)
	
	# Sol boşluk (Kapat butonu dengesi için)
	var sp_l = Control.new()
	sp_l.custom_minimum_size = Vector2(30 * ui_scale, 0)
	header_hbox.add_child(sp_l)
	
	var lbl = Label.new()
	var s_name = SkinManager.get_skin_name(skin_id) if SkinManager else data.get("name_en", "Unknown")
	lbl.text = s_name
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# Metin taşmasını kapat, sadece küçülme yapsın
	lbl.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING 
	
	# Dynamic Font Scaling (Agresif küçültme)
	var font = custom_font if custom_font else ThemeDB.fallback_font
	var available_w = safe_w - (80 * ui_scale) # Butonlar ve margin payı
	var f_size = int(22 * ui_scale)
	# Minimum 8px'e kadar küçülmesine izin ver
	while f_size > 8:
		var sz = font.get_string_size(s_name, HORIZONTAL_ALIGNMENT_CENTER, -1, f_size)
		if sz.x < available_w: 
			break
		f_size -= 1
	
	lbl.add_theme_font_size_override("font_size", f_size)
	if custom_font: lbl.add_theme_font_override("font", custom_font)
	lbl.add_theme_color_override("font_color", Color("#ffd700"))
	header_hbox.add_child(lbl)
	
	# Top Right Close Button
	var btn_close = create_css_button("X", Color("#e53935"), Color("#ef5350"), Color("#b71c1c"), 2, int(14 * ui_scale))
	btn_close.custom_minimum_size = Vector2(32, 32) * ui_scale
	btn_close.pressed.connect(func(): 
		skin_detail_popup.queue_free()
		# Fix overlay visibility: keep visible if shop is still open
		if shop_popup and shop_popup.visible:
			overlay.visible = true
		else:
			overlay.visible = false
	)
	header_hbox.add_child(btn_close)
	
	# PREVIEW
	var prev_rect = SkinPreviewControl.new()
	prev_rect.custom_minimum_size = Vector2(0, 140 * ui_scale)
	prev_rect.skin_id = skin_id
	prev_rect.skin_manager_ref = SkinManager
	prev_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(prev_rect)
	
	var desc = Label.new()
	var rarity_key = data.get("rarity", "common")
	var rarity_text = Global.get_text("RARITY_" + rarity_key.to_upper()) if Global.has_method("get_text") else rarity_key.to_upper()
	desc.text = "%s: %s" % [Global.get_text("RARITY"), rarity_text]
	desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if custom_font: desc.add_theme_font_override("font", custom_font)
	desc.add_theme_font_size_override("font_size", int(12 * ui_scale))
	vbox.add_child(desc)
	
	var btn_action = create_css_button(Global.get_text("BUY") if not is_owned else Global.get_text("EQUIP"), Color("#41c741"), Color("#42b442"), Color("#2a6d2a"), 4, int(18 * ui_scale))
	btn_action.custom_minimum_size.y = 50 * ui_scale
	
	if not is_owned and Global.coins < data["price"]:
		btn_action.text_val = Global.get_text("NOT_ENOUGH")
		btn_action.disabled = true
		btn_action.col_bg = Color("#b71c1c")
		btn_action.col_hover = Color("#b71c1c")
	
	btn_action.pressed.connect(func():
		if is_owned:
			Global.select_skin(skin_id)
		else:
			if Global.coins >= data["price"]:
				Global.coins -= data["price"]
				Global.owned_skins[skin_id] = true
				Global.select_skin(skin_id)
				Global.save_game()

		skin_detail_popup.queue_free()
		# Fix overlay visibility logic on action too
		if shop_popup and shop_popup.visible:
			overlay.visible = true
		else:
			overlay.visible = false
		
		_refresh_ui()
		if shop_popup: 
			shop_popup.visible = true
	)
	vbox.add_child(btn_action)

func setup_settings_popup():
	settings_popup = Control.new()
	settings_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	settings_popup.visible = false
	settings_popup.z_index = 20
	add_child(settings_popup)
	
	var p_size = Vector2(min(320, screen_size.x - 40), 380) * ui_scale
	var panel = create_popup_panel(p_size)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	settings_popup.add_child(panel)
	
	var margin = MarginContainer.new()
	var m_val = int(15 * ui_scale)
	margin.add_theme_constant_override("margin_top", m_val)
	margin.add_theme_constant_override("margin_bottom", m_val)
	margin.add_theme_constant_override("margin_left", m_val)
	margin.add_theme_constant_override("margin_right", m_val)
	panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", int(10 * ui_scale))
	margin.add_child(vbox)
	
	var lbl_title = Label.new()
	lbl_title.text = Global.get_text("SETTINGS")
	lbl_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_title.add_theme_font_size_override("font_size", int(22 * ui_scale))
	if custom_font: lbl_title.add_theme_font_override("font", custom_font)
	lbl_title.add_theme_color_override("font_color", Color("#ffd700"))
	vbox.add_child(lbl_title)
	
	var hs = HSeparator.new()
	vbox.add_child(hs)
	
	# === MÜZİK SATIRI ===
	var music_row = HBoxContainer.new()
	music_row.add_theme_constant_override("separation", int(8 * ui_scale))
	vbox.add_child(music_row)
	
	# Müzik toggle butonu
	var btn_music = create_css_button("", Color("#3e5ba9"), Color("#4e6bb9"), Color("#2e4b99"), 4, 12)
	var music_txt = Global.get_text("MUSIC") + ": " + (Global.get_text("ON") if Global.music_enabled else Global.get_text("OFF"))
	btn_music.text_val = music_txt
	if not Global.music_enabled:
		btn_music.col_bg = Color("#c74e35")
		btn_music.col_hover = Color("#b73e25")
		btn_music.col_inner_dark = Color("#8f3c2d")
	btn_music.custom_minimum_size = Vector2(0, 45 * ui_scale)
	btn_music.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn_music.pressed.connect(_toggle_music.bind(btn_music))
	music_row.add_child(btn_music)
	
	# Müzik ayar butonu (Pixel art gear icon)
	var btn_music_settings = SettingsGearButton.new()
	btn_music_settings.custom_minimum_size = Vector2(35, 35) * ui_scale
	btn_music_settings.pressed.connect(func(): _show_volume_popup("music"))
	music_row.add_child(btn_music_settings)
	
	# === SES EFEKTLERİ SATIRI ===
	var sfx_row = HBoxContainer.new()
	sfx_row.add_theme_constant_override("separation", int(8 * ui_scale))
	vbox.add_child(sfx_row)
	
	# Ses efektleri toggle butonu
	var btn_sfx = create_css_button("", Color("#3e5ba9"), Color("#4e6bb9"), Color("#2e4b99"), 4, 12)
	var sfx_txt = Global.get_text("SFX") + ": " + (Global.get_text("ON") if Global.sfx_enabled else Global.get_text("OFF"))
	btn_sfx.text_val = sfx_txt
	if not Global.sfx_enabled:
		btn_sfx.col_bg = Color("#c74e35")
		btn_sfx.col_hover = Color("#b73e25")
		btn_sfx.col_inner_dark = Color("#8f3c2d")
	btn_sfx.custom_minimum_size = Vector2(0, 45 * ui_scale)
	btn_sfx.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn_sfx.pressed.connect(_toggle_sfx.bind(btn_sfx))
	sfx_row.add_child(btn_sfx)
	
	# SFX ayar butonu (Pixel art gear icon)
	var btn_sfx_settings = SettingsGearButton.new()
	btn_sfx_settings.custom_minimum_size = Vector2(35, 35) * ui_scale
	btn_sfx_settings.pressed.connect(func(): _show_volume_popup("sfx"))
	sfx_row.add_child(btn_sfx_settings)
	
	# Dil butonu
	var btn_lang = create_css_button("", Color("#4a4a6a"), Color("#5a5a7a"), Color("#3a3a5a"), 4, 12)
	var lang_txt = Global.get_text("LANGUAGE") + ": " + Global.language.to_upper()
	btn_lang.text_val = lang_txt
	btn_lang.custom_minimum_size = Vector2(0, 40 * ui_scale)
	btn_lang.pressed.connect(_show_language_popup)
	vbox.add_child(btn_lang)
	
	# HOW TO PLAY BUTTON
	var btn_tut = create_css_button(Global.get_text("HOW_TO_PLAY"), Color("#00acc1"), Color("#26c6da"), Color("#00838f"), 4, 12)
	btn_tut.custom_minimum_size = Vector2(0, 40 * ui_scale)
	btn_tut.pressed.connect(func():
		settings_popup.visible = false
		show_tutorial()
	)
	vbox.add_child(btn_tut)
	
	var spacer = Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(spacer)
	
	var btn_close = create_css_button(Global.get_text("OK"), Color("#444"), Color("#555"), Color("#222"), 4, 12)
	btn_close.custom_minimum_size = Vector2(0, 38 * ui_scale)
	btn_close.pressed.connect(func(): close_popup(settings_popup))
	vbox.add_child(btn_close)

# --- LİDERLİK TABLOSU (RESTORED V11 STYLE) ---
func setup_leaderboard_popup():
	if leaderboard_popup: leaderboard_popup.queue_free()
	leaderboard_popup = Control.new()
	leaderboard_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	leaderboard_popup.visible = false
	leaderboard_popup.z_index = 20
	add_child(leaderboard_popup)
	
	# Overlay Dimmer
	var lb_overlay = ColorRect.new()
	lb_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	lb_overlay.color = Color(0, 0, 0, 0.7)
	leaderboard_popup.add_child(lb_overlay)
	
	# 1. Container Hesabı: Ekranın %90 genişliğini geçmesin
	var max_w = min(450 * ui_scale, screen_size.x * 0.9)
	var max_h = min(700 * ui_scale, screen_size.y * 0.85)
	var panel_size = Vector2(max_w, max_h)
	
	var panel = create_popup_panel(panel_size)
	# Manuel ortalama
	panel.position = (screen_size - panel_size) / 2.0
	leaderboard_popup.add_child(panel)
	
	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_top", 15); margin.add_theme_constant_override("margin_bottom", 15)
	margin.add_theme_constant_override("margin_left", 15); margin.add_theme_constant_override("margin_right", 15)
	panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)
	
	# --- TABS ---
	var tabs = HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 5)
	vbox.add_child(tabs)
	
	var tab_h = 50 * ui_scale
	
	var tab_rank = create_css_button(Global.get_text("RANK"), Color("#3e5ba9"), Color("#4e6bb9"), Color("#2e4b99"), 2, int(14 * ui_scale))
	tab_rank.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tab_rank.custom_minimum_size.y = tab_h
	tabs.add_child(tab_rank)
	
	var tab_stats = create_css_button(Global.get_text("STATS"), Color("#3e5ba9"), Color("#4e6bb9"), Color("#2e4b99"), 2, int(14 * ui_scale))
	tab_stats.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tab_stats.custom_minimum_size.y = tab_h
	tabs.add_child(tab_stats)
	
	var btn_close_top = create_css_button("X", Color("#e53935"), Color("#c62828"), Color("#b71c1c"), 2, int(16 * ui_scale))
	btn_close_top.custom_minimum_size = Vector2(tab_h, tab_h)
	btn_close_top.pressed.connect(func(): 
		close_popup(leaderboard_popup)
		# Overlay'i de gizle
		if overlay:
			overlay.visible = false
	)
	tabs.add_child(btn_close_top)
	
	vbox.add_child(HSeparator.new())
	
	# --- RANK CONTENT ---
	var cont_rank = VBoxContainer.new()
	cont_rank.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(cont_rank)
	
	var title = Label.new()
	title.text = Global.get_text("HIGHSCORE")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", int(20 * ui_scale))
	if custom_font: title.add_theme_font_override("font", custom_font)
	title.add_theme_color_override("font_color", Color("#ffd700"))
	cont_rank.add_child(title)
	
	cont_rank.add_child(HSeparator.new())
	
	# Columns Header
	var col_header = HBoxContainer.new()
	cont_rank.add_child(col_header)
	
	var font_s_header = int(12 * ui_scale)
	
	var h_rank = Label.new()
	h_rank.text = "#"
	h_rank.custom_minimum_size.x = 30 * ui_scale
	h_rank.add_theme_color_override("font_color", Color.GRAY)
	if custom_font: h_rank.add_theme_font_override("font", custom_font)
	h_rank.add_theme_font_size_override("font_size", font_s_header)
	
	var h_name = Label.new()
	h_name.text = Global.get_text("NAME")
	h_name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h_name.add_theme_color_override("font_color", Color.GRAY)
	if custom_font: h_name.add_theme_font_override("font", custom_font)
	h_name.add_theme_font_size_override("font_size", font_s_header)
	
	var h_score = Label.new()
	h_score.text = Global.get_text("SCORE")
	h_score.custom_minimum_size.x = 80 * ui_scale
	h_score.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h_score.add_theme_color_override("font_color", Color.GRAY)
	if custom_font: h_score.add_theme_font_override("font", custom_font)
	h_score.add_theme_font_size_override("font_size", font_s_header)
	
	col_header.add_child(h_rank)
	col_header.add_child(h_name)
	col_header.add_child(h_score)
	
	# Scroll Data
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED # Yatay kaydırma kesinlikle kapalı
	scroll.theme = create_pixel_scrollbar_theme()
	cont_rank.add_child(scroll)
	
	var list_vbox = VBoxContainer.new()
	list_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list_vbox)
	
	var data = Global.leaderboard_data
	
	if leaderboard_loading:
		var lbl_load = Label.new()
		lbl_load.text = Global.get_text("LOADING")
		lbl_load.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if custom_font: lbl_load.add_theme_font_override("font", custom_font)
		list_vbox.add_child(lbl_load)
	elif (LeaderboardManager and not LeaderboardManager.last_fetch_ok) or leaderboard_error:
		var lbl_fail = Label.new()
		lbl_fail.text = Global.get_text("FAILED_TO_LOAD")
		lbl_fail.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if custom_font: lbl_fail.add_theme_font_override("font", custom_font)
		list_vbox.add_child(lbl_fail)
		
		var btn_retry = Button.new()
		btn_retry.text = Global.get_text("RETRY")
		btn_retry.flat = true
		btn_retry.pressed.connect(func(): 
			leaderboard_loading = true
			leaderboard_error = false
			if LeaderboardManager and LeaderboardManager.has_method("fetch_leaderboard"):
				LeaderboardManager.fetch_leaderboard()
			setup_leaderboard_popup()
			show_popup(leaderboard_popup)
		)
		list_vbox.add_child(btn_retry)
	elif data.size() == 0:
		var lbl_load = Label.new()
		lbl_load.text = Global.get_text("NO_SCORES_YET")
		lbl_load.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if custom_font: lbl_load.add_theme_font_override("font", custom_font)
		list_vbox.add_child(lbl_load)
	else:
		var font_s_item = int(12 * ui_scale)
		for i in range(min(50, data.size())):
			var entry = data[i]
			var line = HBoxContainer.new()
			# Satırın genişlemesini sınırla
			line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			
			# DEBUG: Sunucu verisini logla
			if i == 0:
				var my_dev_id = Global.custom_device_id if Global.custom_device_id != "" else OS.get_unique_id()
				print("DEBUG LEADERBOARD - My Device ID: ", my_dev_id)
				print("DEBUG LEADERBOARD - Entry from server: name=", entry.get("name", "N/A"), " device_id=", entry.get("device_id", "N/A"), " score=", entry.get("score", 0))
			
			var l_r = Label.new()
			l_r.text = str(i + 1)
			l_r.custom_minimum_size.x = 30 * ui_scale
			
			# FONT FIX: Sira no (Rank) her zaman Pixel Art
			if ResourceLoader.exists(FONT_PATH):
				var pixel_font = load(FONT_PATH)
				l_r.add_theme_font_override("font", pixel_font)
				
			l_r.add_theme_font_size_override("font_size", font_s_item)
			
			var l_n = Label.new()
			# Sunucu verisini doğrudan kullan (Web Admin Panel ile senkron kalması için)
			var entry_name = entry.get("name", "")
			l_n.text = str(entry_name)
			l_n.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			# Uzun ismin taşmasını engelle: Clip Text
			l_n.clip_text = true
			l_n.custom_minimum_size.x = 10 # Küçülmeye izin ver
			if custom_font: l_n.add_theme_font_override("font", custom_font)
			l_n.add_theme_font_size_override("font_size", font_s_item)
			
			var l_s = Label.new()
			# Kendi cihazımız için Global.high_score kullan (sunucu gecikebilir)
			var entry_device_id = str(entry.get("device_id", ""))
			var display_score = entry.get("score", 0)
			# Outer my_device_id variable used here (defined below in footer or global)
			# Using Global directly to avoid shadowing issues
			if entry_device_id == str(Global.custom_device_id if Global.custom_device_id != "" else OS.get_unique_id()):
				# Kendi skorumuz - yerel kaynak güvenilir
				display_score = max(int(display_score), Global.high_score)
			l_s.text = str(int(display_score))
			l_s.custom_minimum_size.x = 80 * ui_scale
			l_s.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			
			# FONT FIX: Skor sayisi her zaman Pixel Art
			if ResourceLoader.exists(FONT_PATH):
				var pixel_font = load(FONT_PATH)
				l_s.add_theme_font_override("font", pixel_font)
				
			l_s.add_theme_font_size_override("font_size", font_s_item)
			
			var col = Color.WHITE
			if i == 0: col = Color("#ffd700")
			elif i == 1: col = Color("#c0c0c0")
			elif i == 2: col = Color("#cd7f32")
			
			l_r.add_theme_color_override("font_color", col)
			l_n.add_theme_color_override("font_color", col)
			l_s.add_theme_color_override("font_color", col)
			
			line.add_child(l_r); line.add_child(l_n); line.add_child(l_s)
			list_vbox.add_child(line)
	
	# Footer (Name Input)
	cont_rank.add_child(HSeparator.new())
	var footer = HBoxContainer.new()
	cont_rank.add_child(footer)
	
	var l_best = Label.new()
	l_best.text = Global.get_text("BEST") + " " + str(Global.high_score)
	l_best.add_theme_color_override("font_color", Color("#ffd54f"))
	if custom_font: l_best.add_theme_font_override("font", custom_font)
	l_best.add_theme_font_size_override("font_size", int(12 * ui_scale))
	footer.add_child(l_best)
	leaderboard_best_label = l_best  # Referansı sakla
	
	var sp = Control.new()
	sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	footer.add_child(sp)
	
	var btn_save = create_css_button(Global.get_text("OK"), Color("#41c741"), Color("#42b442"), Color("#2a6d2a"), 2, int(10 * ui_scale))
	# Tamam butonu için daha geniş alan
	btn_save.custom_minimum_size = Vector2(60, 30) * ui_scale
	
	var name_edit = LineEdit.new()
	# Sunucu verisinden ismi al (eğer varsa)
	var my_device_id = Global.custom_device_id if Global.custom_device_id != "" else OS.get_unique_id()
	var display_name = Global.player_name
	if Global.leaderboard_data is Array:
		for entry in Global.leaderboard_data:
			if str(entry.get("device_id", "")) == str(my_device_id):
				display_name = entry.get("name", Global.player_name)
				break
	name_edit.text = display_name
	name_edit.placeholder_text = "NAME"
	# Mobilde taşmaması için width kısıtlaması
	name_edit.custom_minimum_size = Vector2(100 * ui_scale, 30 * ui_scale)
	name_edit.max_length = 10
	name_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
	if custom_font: name_edit.add_theme_font_override("font", custom_font)
	name_edit.add_theme_font_size_override("font_size", int(10 * ui_scale))
	
	name_edit.text_submitted.connect(func(_new_text): _on_save_name_pressed(name_edit, btn_save))
	footer.add_child(name_edit)

	btn_save.pressed.connect(func(): _on_save_name_pressed(name_edit, btn_save))
	footer.add_child(btn_save)
	
	# --- STATS CONTENT ---
	var cont_stats = VBoxContainer.new()
	cont_stats.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cont_stats.visible = false
	vbox.add_child(cont_stats)
	
	var st_title = Label.new()
	st_title.text = Global.get_text("STATS")
	st_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	st_title.add_theme_font_size_override("font_size", int(18 * ui_scale))
	st_title.add_theme_color_override("font_color", Color("#ffd700"))
	if custom_font: st_title.add_theme_font_override("font", custom_font)
	cont_stats.add_child(st_title)
	
	cont_stats.add_child(HSeparator.new())
	
	var t_steps = Global.get("total_steps") if Global.get("total_steps") else 0
	var t_deaths = Global.get("total_deaths") if Global.get("total_deaths") else 0
	var t_games = Global.get("total_games_played") if Global.get("total_games_played") else 0
	var t_time = Global.get("total_time_played") if Global.get("total_time_played") else 0.0
	var t_coins = Global.get("total_coins_collected") if Global.get("total_coins_collected") else 0
	var t_skins = Global.owned_skins.size()

	var vbox_st_list = VBoxContainer.new()
	vbox_st_list.add_theme_constant_override("separation", int(25 * ui_scale))
	cont_stats.add_child(vbox_st_list)

	# Helper func to add stat row
	var add_stat = func(txt, col=Color.WHITE):
		var l = Label.new()
		l.text = txt
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l.add_theme_color_override("font_color", col)
		if custom_font: l.add_theme_font_override("font", custom_font)
		l.add_theme_font_size_override("font_size", int(16 * ui_scale))
		vbox_st_list.add_child(l)

	# Steps (Boşluklu)
	var spacer_step = Control.new()
	spacer_step.custom_minimum_size = Vector2(0, 5 * ui_scale)
	vbox_st_list.add_child(spacer_step)
	add_stat.call(Global.get_text("TOTAL_STEPS") + ": " + str(t_steps), Color.WHITE)

	add_stat.call(Global.get_text("TOTAL_DEATHS") + ": " + str(t_deaths), Color.RED)
	add_stat.call(Global.get_text("TOTAL_GAMES") + ": " + str(t_games), Color.YELLOW)
	add_stat.call(Global.get_text("TIME") + ": " + "%d " % (int(t_time / 60.0)) + Global.get_text("MIN"), Color.CYAN)
	add_stat.call(Global.get_text("COLLECTED_COINS") + ": " + str(t_coins), Color("#ffd700"))
	add_stat.call(Global.get_text("SKINS_OWNED") + ": " + str(t_skins), Color.GREEN)
	
	# Tab Logic
	tab_rank.pressed.connect(func(): 
		cont_rank.visible = true
		cont_stats.visible = false
		tab_rank.col_bg = Color("#41c741")
		tab_stats.col_bg = Color("#3e5ba9")
		tab_rank.queue_redraw()
		tab_stats.queue_redraw()
	)
	tab_stats.pressed.connect(func(): 
		cont_rank.visible = false
		cont_stats.visible = true
		tab_rank.col_bg = Color("#3e5ba9")
		tab_stats.col_bg = Color("#41c741")
		tab_rank.queue_redraw()
		tab_stats.queue_redraw()
	)
	
	tab_rank.col_bg = Color("#41c741")

func _on_save_name_pressed(edit_node, btn_ref):
	var new_name = edit_node.text.strip_edges()
	if new_name == "":
		return
	
	Global.player_name = new_name
	Global.save_game()
	name_change_timestamp = Time.get_unix_time_from_system() # Koruma başlat (10 saniye)
	
	var current_device_id = Global.custom_device_id if Global.custom_device_id != "" else OS.get_unique_id()
	
	# AdminManager cache'ini temizle (eski admin ismi geri gelmesin)
	if AdminManager and AdminManager.admin_data.has("users"):
		if AdminManager.admin_data["users"].has(current_device_id):
			AdminManager.admin_data["users"][current_device_id]["name"] = new_name
		# Kullanıcı kendi değiştirdiği için admin verisini de güncelle
		AdminManager.update_user(current_device_id, new_name, Global.high_score)
	
	# Yerel leaderboard verisini güncelle
	if Global.leaderboard_data is Array:
		for i in range(Global.leaderboard_data.size()):
			var entry = Global.leaderboard_data[i]
			if str(entry.get("device_id")) == str(current_device_id):
				entry["name"] = new_name
				break
	
	# Feedback göster
	btn_ref.text_val = "SAVING..."
	btn_ref.col_bg = Color("#ff9800")
	btn_ref.queue_redraw()
	
	# Submit score with new name
	if LeaderboardManager:
		# Sunucudaki mevcut skoru bul (varsa)
		var server_score = Global.high_score
		if Global.leaderboard_data is Array:
			for entry in Global.leaderboard_data:
				if str(entry.get("device_id", "")) == str(current_device_id):
					server_score = max(server_score, int(entry.get("score", 0)))
					break
		
		var score_to_send = max(server_score, Global.high_score)
		if score_to_send == 0:
			score_to_send = 1
		
		LeaderboardManager.submit_score(score_to_send)
		
		# Submit'in sunucuda işlenmesi için bekle
		await get_tree().create_timer(1.5).timeout
		
		# Şimdi güncel veriyi çek
		leaderboard_loading = true
		LeaderboardManager.fetch_leaderboard()
		
		# Fetch tamamlandığında popup otomatik yenienir (_on_leaderboard_updated)
	
	# Son feedback
	await get_tree().create_timer(0.5).timeout
	if is_instance_valid(btn_ref):
		btn_ref.text_val = "SAVED!"
		btn_ref.col_bg = Color("#4CAF50")
		btn_ref.queue_redraw()
		
		await get_tree().create_timer(1.0).timeout
		if is_instance_valid(btn_ref):
			btn_ref.text_val = Global.get_text("OK")
			btn_ref.col_bg = Color("#41c741")
			btn_ref.queue_redraw()

func _on_leaderboard_updated():
	leaderboard_loading = false
	leaderboard_error = false
	if LeaderboardManager:
		leaderboard_error = not LeaderboardManager.last_fetch_ok
	
	# Leaderboard listesinde kendi ismimizi doğru göster
	# NOT: Global.player_name sunucudan asla değiştirilmez (race condition önleme)
	# Admin değişiklikleri sadece oyun yeniden başlatıldığında yansır
	var my_device_id = Global.custom_device_id if Global.custom_device_id != "" else OS.get_unique_id()
	if Global.leaderboard_data is Array:
		for i in range(Global.leaderboard_data.size()):
			var entry = Global.leaderboard_data[i]
			if str(entry.get("device_id", "")) == str(my_device_id):
				# Leaderboard listesinde kendi ismimizi Global.player_name olarak göster
				# NOT: Sunucudaki isim "ozgur" ise ve yerel isim "ozgur123" ise bu override yanlış anlaşılmaya sebep oluyor.
				# Kullanıcı sunucudaki gerçek ismini görsün diye bu override'ı devre dışı bırakıyoruz.
				
				# if entry.get("name", "") != Global.player_name:
				# 	entry["name"] = Global.player_name
				# 	Global.leaderboard_data[i] = entry
				break
	
	# Popup açıkken otomatik yenile
	if leaderboard_popup and leaderboard_popup.visible:
		setup_leaderboard_popup()
		leaderboard_popup.visible = true
		overlay.visible = true

func _on_high_score_updated(_new_score: int):
	# Score güncellendiğinde leaderboard popup açıksa BEST label'ını güncelle
	if leaderboard_popup and leaderboard_popup.visible and leaderboard_best_label:
		leaderboard_best_label.text = Global.get_text("BEST") + " " + str(Global.high_score)

func _on_daily_pressed():
	if daily_popup:
		daily_popup.visible = true
		show_popup(daily_popup)

func setup_daily_popup():
	if daily_popup: daily_popup.queue_free()
	
	daily_popup = Control.new()
	daily_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	daily_popup.visible = false
	daily_popup.z_index = 25
	add_child(daily_popup)
	
	# Dimmer removed to avoid double darkening
	
	# Strict sizing
	var panel_w = min(600 * ui_scale, screen_size.x - 40)
	var panel_h = min(400 * ui_scale, screen_size.y - 100)
	var panel_size = Vector2(panel_w, panel_h)
	
	var panel = create_popup_panel(panel_size)
	panel.position = (screen_size - panel_size) / 2.0
	daily_popup.add_child(panel)
	
	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 15)
	margin.add_child(vbox)
	
	# Header
	var header = HBoxContainer.new()
	header.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(header)
	
	var title = Label.new()
	title.text = Global.get_text("DAILY_REWARD")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var fs_title = int(clamp(panel_w / 20.0, 16, 28))
	title.add_theme_font_size_override("font_size", fs_title)
	if custom_font: title.add_theme_font_override("font", custom_font)
	title.add_theme_color_override("font_color", Color("#ffd700"))
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)
	
	var close_btn = create_css_button("X", Color("#e53935"), Color("#c62828"), Color("#b71c1c"), 2, int(fs_title * 0.7))
	close_btn.custom_minimum_size = Vector2(32, 32) * (ui_scale if ui_scale > 0.8 else 0.8)
	close_btn.pressed.connect(func(): close_popup(daily_popup))
	header.add_child(close_btn)
	
	vbox.add_child(HSeparator.new())
	
	# Rewards Grid (7 Days)
	# Use HBox for wide screens, Grid for narrow?
	# 7 items is a lot for width. Let's do FlowContainer or GridContainer.
	# HBoxContainer with ScrollContainer is safest for mobile responsive.
	
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED # Horizontal only
	scroll.theme = create_pixel_scrollbar_theme()
	vbox.add_child(scroll)
	
	var list_grid = GridContainer.new()
	list_grid.columns = 4
	list_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	list_grid.add_theme_constant_override("h_separation", int(10 * ui_scale))
	list_grid.add_theme_constant_override("v_separation", int(10 * ui_scale))
	# Center grid in scroll
	var center_cont = CenterContainer.new()
	center_cont.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center_cont.add_child(list_grid)
	scroll.add_child(center_cont)
	
	var st = Global.check_daily_status()
	var current_day = st["reward_day"] # 1 to 7
	var can_claim = st["can_claim"]
	var rewards = {1: 100, 2: 200, 3: 350, 4: 500, 5: 750, 6: 1000, 7: 2000}
	
	for d in range(1, 8):
		var item_panel = PanelContainer.new()
		var p_style = StyleBoxFlat.new()
		p_style.set_corner_radius_all(4)
		p_style.border_width_bottom = 4
 
		# Determine State
		var state = "locked" # locked, active, claimed
		if d < current_day:
			state = "claimed"
		elif d == current_day:
			if can_claim: state = "active"
			else: state = "claimed"
		else:
			state = "locked"
 
		# Colors
		if state == "claimed":
			p_style.bg_color = Color("#444444")
			p_style.border_color = Color("#222222")
		elif state == "active":
			p_style.bg_color = Color("#ffd700")
			p_style.border_color = Color("#c5a000")
		else: # locked
			p_style.bg_color = Color("#222034")
			p_style.border_color = Color("#11111a")
 
		item_panel.add_theme_stylebox_override("panel", p_style)
		item_panel.custom_minimum_size = Vector2(70, 80) * ui_scale
		list_grid.add_child(item_panel)
 
		var i_vbox = VBoxContainer.new()
		i_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		item_panel.add_child(i_vbox)
 
		# Day Label
		var l_day = Label.new()
		l_day.text = Global.get_text("DAY") + "\n" + str(d)
		l_day.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l_day.add_theme_font_size_override("font_size", int(10 * ui_scale))
		if custom_font: l_day.add_theme_font_override("font", custom_font)
		if state == "active": l_day.add_theme_color_override("font_color", Color.BLACK)
		else: l_day.add_theme_color_override("font_color", Color.GRAY)
		i_vbox.add_child(l_day)
 
		# Icon (Coin)
		var ic = CoinIcon.new()
		ic.is_static = (state != "active")
		ic.custom_minimum_size = Vector2(24, 24) * ui_scale
		var cent = CenterContainer.new()
		cent.add_child(ic)
		i_vbox.add_child(cent)
 
		# Amount
		var l_amt = Label.new()
		l_amt.text = str(rewards[d])
		l_amt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l_amt.add_theme_font_size_override("font_size", int(10 * ui_scale))
		if custom_font: l_amt.add_theme_font_override("font", custom_font)
		if state == "active": l_amt.add_theme_color_override("font_color", Color.BLACK)
		else: l_amt.add_theme_color_override("font_color", Color.WHITE)
		i_vbox.add_child(l_amt)
 
		# Overlay Icon (Lock or Check)
		if state == "claimed":
			var l_chk = Label.new()
			l_chk.text = "✓"
			l_chk.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			l_chk.add_theme_color_override("font_color", Color.GREEN)
			i_vbox.add_child(l_chk)
		elif state == "locked":
			var l_lck = Label.new()
			l_lck.text = "🔒" # ASCII lock symbol or similar
			l_lck.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			i_vbox.add_child(l_lck)
 
	vbox.add_child(HSeparator.new())
	
	# Footer Claim Button (Only if claimable)
	if can_claim:
		var btn_claim = create_css_button(Global.get_text("CLAIM"), Color("#41c741"), Color("#42b442"), Color("#2a6d2a"), 4, int(18 * ui_scale))
		btn_claim.custom_minimum_size = Vector2(200, 60) * ui_scale
		btn_claim.pressed.connect(func(): _on_claim_daily_pressed(btn_claim))
 
		var cent_btn = CenterContainer.new()
		cent_btn.add_child(btn_claim)
		vbox.add_child(cent_btn)
	else:
		# Just a label
		var l_info = Label.new()
		l_info.text = Global.get_text("COME_BACK_TOMORROW")
		l_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		l_info.add_theme_color_override("font_color", Color.GRAY)
		l_info.add_theme_font_size_override("font_size", int(12 * ui_scale))
		if custom_font: l_info.add_theme_font_override("font", custom_font)
		vbox.add_child(l_info)

func _on_claim_daily_pressed(btn):
	var amt = Global.claim_daily_reward()
	if amt > 0:
		# Success - Just update UI state without destroying popup stack
		btn.disabled = true
		btn.text_val = "CLAIMED!"
 
		# Update Chest Button State
		if btn_daily:
			btn_daily.can_claim = false
			btn_daily.is_open = true
 
		# Manually update coin display instead of full refresh
		if store_btn: store_btn.queue_redraw()
 
		# Refresh the popup content after a short delay
		await get_tree().create_timer(0.5).timeout
		setup_daily_popup()
		daily_popup.visible = true

func create_popup_panel(sz: Vector2) -> PanelContainer:
	var panel = PanelContainer.new()
	panel.custom_minimum_size = sz
	panel.position = -sz / 2
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color("#1a1a2e")
	style.border_width_left = 4
	style.border_width_right = 4
	style.border_width_top = 4
	style.border_width_bottom = 4
	style.border_color = Color("#3e3e5e")
	style.set_corner_radius_all(0)
	panel.add_theme_stylebox_override("panel", style)
	return panel

# --- HELPER: PIXEL ART SCROLLBAR THEME ---
func create_pixel_scrollbar_theme() -> Theme:
	var theme = Theme.new()
	
	# Scroller Track (Background)
	var style_scroll = StyleBoxFlat.new()
	style_scroll.bg_color = Color("#2e2e42") 
	style_scroll.border_width_left = 2
	style_scroll.border_width_right = 2
	style_scroll.border_color = Color("#181825")
	style_scroll.content_margin_left = 6
	style_scroll.content_margin_right = 6
	style_scroll.content_margin_top = 0
	style_scroll.content_margin_bottom = 0
	
	# Grabber (Thumb)
	var style_grabber = StyleBoxFlat.new()
	style_grabber.bg_color = Color("#5a5a7a")
	style_grabber.border_width_top = 2
	style_grabber.border_width_bottom = 2
	style_grabber.border_color = Color("#3a3a5a")
	
	# Grabber Highlight
	var style_grabber_hl = style_grabber.duplicate()
	style_grabber_hl.bg_color = Color("#6a6a8a")
	
	# Grabber Pressed
	var style_grabber_pr = style_grabber.duplicate()
	style_grabber_pr.bg_color = Color("#4a4a6a")
	
	theme.set_stylebox("scroll", "VScrollBar", style_scroll)
	theme.set_stylebox("scroll_focus", "VScrollBar", style_scroll)
	theme.set_stylebox("grabber", "VScrollBar", style_grabber)
	theme.set_stylebox("grabber_highlight", "VScrollBar", style_grabber_hl)
	theme.set_stylebox("grabber_pressed", "VScrollBar", style_grabber_pr)
	
	return theme

func _set_language(lang_code: String):
	Global.language = lang_code
	Global.save_game()
	print("Language set to: ", Global.language)
	_refresh_ui()
	
	# Re-open settings if needed, or just stay on language popup?
	# User wanted a dropdown. Usually you select and it closes the dropdown.
	# We should update UI and probably keep settings open but close language popup.
	if language_popup:
		language_popup.visible = false
	
	if settings_popup:
		settings_popup.visible = true
		show_popup(settings_popup)

func _show_language_popup():
	setup_language_popup()
	if language_popup:
		language_popup.visible = true
		show_popup(language_popup)

func setup_language_popup():
	if language_popup:
		language_popup.queue_free()
		
	language_popup = Control.new()
	language_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	language_popup.visible = false
	language_popup.z_index = 25 # Settings is 20, so this is on top
	add_child(language_popup)
	
	# Create a backdrop to close on click outside
	var backdrop = ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0, 0, 0, 0.5)
	# backdrop.gui_input.connect(...) # Can act as close
	language_popup.add_child(backdrop)
	
	var p_size = Vector2(min(300, screen_size.x - 60), 400) * ui_scale
	var panel = create_popup_panel(p_size)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	language_popup.add_child(panel)
	
	var margin = MarginContainer.new()
	var m_val = int(15 * ui_scale)
	margin.add_theme_constant_override("margin_top", m_val)
	margin.add_theme_constant_override("margin_bottom", m_val)
	margin.add_theme_constant_override("margin_left", m_val)
	margin.add_theme_constant_override("margin_right", m_val)
	panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", int(10 * ui_scale))
	margin.add_child(vbox)
	
	# Header
	var lbl_title = Label.new()
	lbl_title.text = Global.get_text("LANGUAGE")
	lbl_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_title.add_theme_font_size_override("font_size", int(20 * ui_scale))
	if custom_font: lbl_title.add_theme_font_override("font", custom_font)
	lbl_title.add_theme_color_override("font_color", Color("#ffd700"))
	vbox.add_child(lbl_title)
	
	var hs = HSeparator.new()
	vbox.add_child(hs)
	
	# ScrollContainer for languages
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.theme = create_pixel_scrollbar_theme() # Apply custom theme!
	vbox.add_child(scroll)
	
	var lang_vbox = VBoxContainer.new()
	lang_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lang_vbox.add_theme_constant_override("separation", int(8 * ui_scale))
	scroll.add_child(lang_vbox)
	
	var lang_names = {
		"en": "ENGLISH",
		"tr": "TÜRKÇE",
		"es": "ESPAÑOL",
		"pt": "PORTUGUÊS",
		"fr": "FRANÇAIS",
		"de": "DEUTSCH",
		"hi": "HINDI",
		"ja": "JAPANESE",
		"zh": "CHINESE",
		"ko": "KOREAN"
	}
	
	for lang_code in Global.SUPPORTED_LANGUAGES:
		var btn_txt = lang_names.get(lang_code, lang_code.to_upper())
		var is_selected = (Global.language == lang_code)
		
		# Highlight selected
		var col_bg = Color("#4a4a6a")
		var col_hov = Color("#5a5a7a")
		if is_selected:
			col_bg = Color("#4caf50")
			col_hov = Color("#66bb6a")
			
		var btn = create_css_button(btn_txt, col_bg, col_hov, Color("#1b1b2f"), 2, int(14 * ui_scale))
		btn.custom_minimum_size = Vector2(0, 45 * ui_scale)
		btn.pressed.connect(func(): _set_language(lang_code))
		lang_vbox.add_child(btn)

	# Close Button
	var btn_close = create_css_button(Global.get_text("BACK"), Color("#e53935"), Color("#c62828"), Color("#b71c1c"), 2, int(14 * ui_scale))
	btn_close.custom_minimum_size = Vector2(0, 40 * ui_scale)
	btn_close.pressed.connect(func(): language_popup.visible = false)
	vbox.add_child(btn_close)

func _toggle_music(btn_ref = null):
	Global.music_enabled = not Global.music_enabled
	Global.save_game()
	
	# SoundManager'ı güncelle
	if SoundManager:
		SoundManager.set_music_enabled(Global.music_enabled)
	
	# Sadece buton metnini güncelle
	if btn_ref:
		var music_text = Global.get_text("MUSIC") + ": " + (Global.get_text("ON") if Global.music_enabled else Global.get_text("OFF"))
		btn_ref.text_val = music_text
 
		# Görsel olarak OFF ise kırmızımsı yap
		if not Global.music_enabled:
			btn_ref.col_bg = Color("#c74e35")
			btn_ref.col_hover = Color("#b73e25")
			btn_ref.col_inner_dark = Color("#8f3c2d")
		else:
			btn_ref.col_bg = Color("#3e5ba9")
			btn_ref.col_hover = Color("#4e6bb9")
			btn_ref.col_inner_dark = Color("#2e4b99")
 
		btn_ref.queue_redraw()

func _toggle_sfx(btn_ref = null):
	Global.sfx_enabled = not Global.sfx_enabled
	Global.save_game()
	
	# SoundManager'ı güncelle
	if SoundManager:
		SoundManager.set_sfx_enabled(Global.sfx_enabled)
	
	# Sadece buton metnini güncelle
	if btn_ref:
		var sfx_text = Global.get_text("SFX") + ": " + (Global.get_text("ON") if Global.sfx_enabled else Global.get_text("OFF"))
		btn_ref.text_val = sfx_text
 
		# Görsel olarak OFF ise kırmızımsı yap
		if not Global.sfx_enabled:
			btn_ref.col_bg = Color("#c74e35")
			btn_ref.col_hover = Color("#b73e25")
			btn_ref.col_inner_dark = Color("#8f3c2d")
		else:
			btn_ref.col_bg = Color("#3e5ba9")
			btn_ref.col_hover = Color("#4e6bb9")
			btn_ref.col_inner_dark = Color("#2e4b99")
 
		btn_ref.queue_redraw()

func _toggle_step(btn_ref = null):
	Global.step_enabled = not Global.step_enabled
	Global.save_game()
	
	# SoundManager'ı güncelle
	if SoundManager:
		SoundManager.set_step_enabled(Global.step_enabled)
	
	# Sadece buton metnini güncelle
	if btn_ref:
		var step_text = Global.get_text("STEP_SOUND") + ": " + (Global.get_text("ON") if Global.step_enabled else Global.get_text("OFF"))
		btn_ref.text_val = step_text
 
		# Görsel olarak OFF ise kırmızımsı yap
		if not Global.step_enabled:
			btn_ref.col_bg = Color("#6a4a4a")
			btn_ref.col_hover = Color("#7a5a5a")
			btn_ref.col_inner_dark = Color("#5a3a3a")
		else:
			btn_ref.col_bg = Color("#4a6a4a")
			btn_ref.col_hover = Color("#5a7a5a")
			btn_ref.col_inner_dark = Color("#3a5a3a")
 
		btn_ref.queue_redraw()

func _show_volume_popup(type: String):
	# Mevcut popup varsa kaldır
	var existing = get_node_or_null("VolumePopup")
	if existing: existing.queue_free()
	
	var popup = Control.new()
	popup.name = "VolumePopup"
	popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	popup.z_index = 25
	add_child(popup)
	
	# Overlay
	var popup_overlay = ColorRect.new()
	popup_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	popup_overlay.color = Color(0, 0, 0, 0.5)
	popup_overlay.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed:
			popup.queue_free()
	)
	popup.add_child(popup_overlay)
	
	var p_size = Vector2(280, 180) * ui_scale if type == "music" else Vector2(280, 240) * ui_scale
	var panel = create_popup_panel(p_size)
	panel.set_anchors_preset(Control.PRESET_CENTER)
	popup.add_child(panel)
	
	var margin = MarginContainer.new()
	var m_val = int(15 * ui_scale)
	margin.add_theme_constant_override("margin_top", m_val)
	margin.add_theme_constant_override("margin_bottom", m_val)
	margin.add_theme_constant_override("margin_left", m_val)
	margin.add_theme_constant_override("margin_right", m_val)
	panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", int(10 * ui_scale))
	margin.add_child(vbox)
	
	# Başlık
	var title = Label.new()
	title.text = Global.get_text("MUSIC") if type == "music" else Global.get_text("SFX")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", int(18 * ui_scale))
	if custom_font: title.add_theme_font_override("font", custom_font)
	title.add_theme_color_override("font_color", Color("#ffd700"))
	vbox.add_child(title)
	
	# Ses seviyesi slider
	var vol_container = HBoxContainer.new()
	vol_container.add_theme_constant_override("separation", int(8 * ui_scale))
	vbox.add_child(vol_container)
	
	var vol_label = Label.new()
	vol_label.text = Global.get_text("VOLUME") + ":"
	vol_label.add_theme_font_size_override("font_size", int(12 * ui_scale))
	if custom_font: vol_label.add_theme_font_override("font", custom_font)
	vol_container.add_child(vol_label)
	
	var slider = HSlider.new()
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.1
	slider.value = Global.music_volume if type == "music" else Global.sfx_volume
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.custom_minimum_size.y = 25 * ui_scale
	vol_container.add_child(slider)
	
	var percent_label = Label.new()
	percent_label.text = str(int(slider.value * 100)) + "%"
	percent_label.custom_minimum_size.x = 50 * ui_scale
	percent_label.add_theme_font_size_override("font_size", int(12 * ui_scale))
	if custom_font: percent_label.add_theme_font_override("font", custom_font)
	vol_container.add_child(percent_label)
	
	slider.value_changed.connect(func(val):
		percent_label.text = str(int(val * 100)) + "%"
		if type == "music":
			if SoundManager: SoundManager.set_music_volume(val)
		else:
			if SoundManager: SoundManager.set_sfx_volume(val)
	)
	
	# Ses efektleri için adım sesi toggle
	if type == "sfx":
		var hs = HSeparator.new()
		vbox.add_child(hs)
		
		var btn_step = create_css_button("", Color("#4a6a4a"), Color("#5a7a5a"), Color("#3a5a3a"), 4, 11)
		var step_txt = Global.get_text("STEP_SOUND") + ": " + (Global.get_text("ON") if Global.step_enabled else Global.get_text("OFF"))
		btn_step.text_val = step_txt
		if not Global.step_enabled:
			btn_step.col_bg = Color("#6a4a4a")
			btn_step.col_hover = Color("#7a5a5a")
			btn_step.col_inner_dark = Color("#5a3a3a")
		btn_step.custom_minimum_size = Vector2(0, 40 * ui_scale)
		btn_step.pressed.connect(_toggle_step.bind(btn_step))
		vbox.add_child(btn_step)
	
	# Kapat butonu
	var btn_close = create_css_button(Global.get_text("OK"), Color("#444"), Color("#555"), Color("#222"), 4, 12)
	btn_close.custom_minimum_size = Vector2(0, 35 * ui_scale)
	btn_close.pressed.connect(func(): popup.queue_free())
	vbox.add_child(btn_close)

func _refresh_ui():
	# 1. Update Buttons
	if play_btn:
		play_btn.text_val = Global.get_text("PLAY")
		play_btn.queue_redraw()
	if store_btn:
		store_btn.text_val = Global.get_text("SHOP")
		store_btn.queue_redraw()
 
	# 2. Recreate Popups (Destroy Old ones)
	if shop_popup: shop_popup.queue_free()
	if settings_popup: settings_popup.queue_free()
	if leaderboard_popup: leaderboard_popup.queue_free()
	if daily_popup: daily_popup.queue_free()
	
	# 3. Build New Popups
	setup_shop_popup()
	setup_settings_popup()
	setup_leaderboard_popup()
	setup_daily_popup()
	
	# 4. Redraw Menu
	queue_redraw()

# --- VERSIYON KONTROL POPUP'I ---
func _on_version_checked(is_blocking):
	if is_blocking:
		version_blocking_active = true
		overlay.visible = true
		overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
		overlay.size = get_viewport_rect().size 
 
		# Panel oluştur
		var p = PanelContainer.new()
		var vp_size = get_viewport_rect().size
		var max_w = min(320, vp_size.x * 0.85)
		p.custom_minimum_size = Vector2(max_w, 0)
		
		# Ortala - Anchor kullanarak
		p.anchor_left = 0.5
		p.anchor_right = 0.5
		p.anchor_top = 0.5
		p.anchor_bottom = 0.5
		p.offset_left = -max_w / 2
		p.offset_right = max_w / 2
		p.offset_top = -100
		p.offset_bottom = 100
		p.grow_horizontal = Control.GROW_DIRECTION_BOTH
		p.grow_vertical = Control.GROW_DIRECTION_BOTH
		
		overlay.add_child(p)
 
		var style = StyleBoxFlat.new()
		style.bg_color = Color("#1a1a2e")
		style.border_width_left = 4; style.border_width_top = 4
		style.border_width_right = 4; style.border_width_bottom = 8
		style.border_color = Color.WHITE
		style.shadow_color = Color(0,0,0,0.5); style.shadow_size = 10
		style.corner_radius_top_left = 8
		style.corner_radius_top_right = 8
		style.corner_radius_bottom_left = 8
		style.corner_radius_bottom_right = 8
		p.add_theme_stylebox_override("panel", style)
 
		var m = MarginContainer.new()
		m.add_theme_constant_override("margin_top", 15); m.add_theme_constant_override("margin_bottom", 15)
		m.add_theme_constant_override("margin_left", 15); m.add_theme_constant_override("margin_right", 15)
		p.add_child(m)
 
		var vbox = VBoxContainer.new()
		vbox.add_theme_constant_override("separation", 15)
		m.add_child(vbox)
 
		# Font Seçimi
		var font = custom_font if custom_font else ThemeDB.fallback_font
 
		# Başlık (DİL DESTEKLİ)
		var title = Label.new()
		title.text = Global.get_text("UPDATE_REQ") if Global.has_method("get_text") else "UPDATE REQUIRED"
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		title.add_theme_color_override("font_color", Color("#ff4444"))
		if font: title.add_theme_font_override("font", font)
		title.add_theme_font_size_override("font_size", 18)
		vbox.add_child(title)
 
		# --- MESAJ KISMI ---
		var msg_text = ""
		if VersionManager.popup_message != "" and VersionManager.popup_message != "Update Required":
			msg_text = VersionManager.popup_message
		else:
			msg_text = Global.get_text("UPDATE_MSG") if Global.has_method("get_text") else "A new version is available!"
			if VersionManager.maintenance_mode:
				msg_text = Global.get_text("MAINTENANCE_MSG") if Global.has_method("get_text") else "Server is under maintenance."

		var msg = Label.new()
		msg.text = msg_text
		msg.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		msg.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		msg.custom_minimum_size.x = max_w - 40
		if font: msg.add_theme_font_override("font", font)
		msg.add_theme_font_size_override("font_size", 11)
		msg.add_theme_color_override("font_color", Color("#cccccc"))
		vbox.add_child(msg)
 
		# Buton
		var btn_txt = Global.get_text("UPDATE_BTN") if Global.has_method("get_text") else "UPDATE NOW"
 
		var btn = CSSPixelButton.new()
		btn.text_val = btn_txt
		btn.col_bg = Color("#41c741")
		btn.col_hover = Color("#42b442")
		btn.col_inner_dark = Color("#2a6d2a")
		btn.border_width = 3
		btn.font_size = 14
		
		btn.custom_minimum_size = Vector2(0, 45)
		if font: btn.add_theme_font_override("font", font) 
		btn.pressed.connect(func():
			if VersionManager and VersionManager.store_url != "":
				OS.shell_open(VersionManager.store_url)
		)
		vbox.add_child(btn)

# --- DÜZELTİLMİŞ BUTON ÇİZİMİ ---
class CSSPixelButton extends Button:
	var text_val = ""
	var col_bg = Color.WHITE
	var col_hover = Color.WHITE
	var col_inner_dark = Color.BLACK
	var border_width = 4
	var font_size = 20
	
	func _ready():
		flat = true
		text = "" 
	
	func _draw():
		var rect = Rect2(Vector2.ZERO, size)
		var is_hover = is_hovered()
		var is_down = is_pressed()
 
		var offset_y = 0.0
		if is_down: offset_y = 6.0 if border_width > 4 else 4.0
 
		var draw_rect_final = rect
		draw_rect_final.position.y += offset_y
 
		draw_rect(Rect2(draw_rect_final.position - Vector2(border_width, border_width), draw_rect_final.size + Vector2(border_width*2, border_width*2)), Color.BLACK)
 
		var final_bg = col_hover if is_hover else col_bg
		draw_rect(draw_rect_final, final_bg)
 
		var inner_border = 4.0 
		draw_rect(Rect2(draw_rect_final.position, Vector2(draw_rect_final.size.x, inner_border)), Color(1,1,1,0.7)) 
		draw_rect(Rect2(draw_rect_final.position, Vector2(inner_border, draw_rect_final.size.y)), Color(1,1,1,0.7)) 
 
		draw_rect(Rect2(draw_rect_final.position.x, draw_rect_final.position.y + draw_rect_final.size.y - inner_border, draw_rect_final.size.x, inner_border), col_inner_dark) 
		draw_rect(Rect2(draw_rect_final.position.x + draw_rect_final.size.x - inner_border, draw_rect_final.position.y, inner_border, draw_rect_final.size.y), col_inner_dark) 
 
		# --- METİN HİZALAMA DÜZELTMESİ ---
		var font = get_theme_font("font")
		var str_size = font.get_string_size(text_val, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
		var ascent = font.get_ascent(font_size)
 
		# Tam merkez pozisyonunu hesapla (Baseline'a göre ayarla)
		var text_pos_x = draw_rect_final.position.x + (draw_rect_final.size.x - str_size.x) / 2.0
		var text_pos_y = draw_rect_final.position.y + (draw_rect_final.size.y - str_size.y) / 2.0 + ascent
		var text_pos = Vector2(text_pos_x, text_pos_y)
 
		draw_string(font, text_pos + Vector2(2, 2), text_val, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color("#291529"))
		draw_string(font, text_pos + Vector2(1, 1), text_val, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color("#5d275d"))
		draw_string(font, text_pos, text_val, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.WHITE)

# Bu sınıfı script dosyanızın en altına, diğer fonksiyonların dışına yapıştırın.
class PixelIconButton extends Button:
	var icon_type = ""
	
	func _draw_exclaim_local(center: Vector2, px: float, pulse: float = 1.0):
		var bar_w = 3.0 * px
		var bar_h = 7.0 * px
		var dot_s = 3.0 * px
		var gap = 2.0 * px
		var total_h = bar_h + gap + dot_s
		var start = center - Vector2(bar_w / 2.0, total_h / 2.0)
		
		var col_base = EXCLAIM_COL_BASE
		var col_out = EXCLAIM_COL_OUT
		var col_shadow = EXCLAIM_COL_SHADOW
		var col_hi = EXCLAIM_COL_HI
		
		# Outline
		draw_rect(Rect2(start.x - px, start.y - px, bar_w + 2*px, bar_h + 2*px), col_out)
		var dot_y = start.y + bar_h + gap
		draw_rect(Rect2(start.x - px, dot_y - px, dot_s + 2*px, dot_s + 2*px), col_out)
		# Shadow
		draw_rect(Rect2(start.x + px, start.y + px, bar_w, bar_h), col_shadow)
		draw_rect(Rect2(start.x + px, dot_y + px, dot_s, dot_s), col_shadow)
		# Body
		draw_rect(Rect2(start.x, start.y, bar_w, bar_h), col_base)
		draw_rect(Rect2(start.x, dot_y, dot_s, dot_s), col_base)
		# Highlight
		draw_rect(Rect2(start.x, start.y, px, px*2), col_hi)
		draw_rect(Rect2(start.x, dot_y, px, px), col_hi)
	
	func _ready():
		focus_mode = Control.FOCUS_NONE
		var style = StyleBoxFlat.new()
		style.bg_color = Color("#33334d")
		style.set_corner_radius_all(0)
		style.anti_aliasing = false
 
		# 3D buton efekti için kenarlıklar
		style.border_width_left = 4
		style.border_width_right = 4
		style.border_width_top = 4
		style.border_width_bottom = 12
		style.border_color = Color("#1a1a2e")
 
		var style_p = style.duplicate()
		style_p.border_width_bottom = 4
		style_p.border_width_top = 12
 
		add_theme_stylebox_override("normal", style)
		add_theme_stylebox_override("hover", style)
		add_theme_stylebox_override("pressed", style_p)



	func _draw():
		var c = self.size / 2.0
		var col = Color("#ffcc00") # İkon rengi

		# Shift icon up by 2 pixels as requested
		c.y -= 2.0
 
		# Basıldığında ikonu aşağı kaydır
		if is_pressed(): 
			c.y += 4 
 
		if icon_type == "rank": 
			draw_rank_icon(c, col)
		elif icon_type == "settings": 
			draw_settings_icon(c, col)
		elif icon_type == "mission":
			draw_mission_icon(c, col)
			
			# Unlem sadece odul varsa
			var has_claim = false
			var missions = Global.get("missions")
			if missions:
				for k in missions:
					var m = missions[k]
					var cur = 0
					
					if m["type"] == "lifetime_coins":
						cur = Global.get("total_coins_collected") if Global.get("total_coins_collected") else 0
					elif m["type"] == "total_steps":
						cur = Global.get("total_steps") if Global.get("total_steps") else 0
					elif m["type"] == "daily_coins":
						cur = Global.daily_stats.get("coins", 0)
					elif m["type"] == "daily_steps":
						cur = Global.daily_stats.get("steps", 0)
					elif m["type"] == "balance_coins":
						cur = Global.coins

					var is_done = cur >= m["target"]
					var is_clm = false
					
					if m.get("is_daily", false):
						var current_day = int(Time.get_unix_time_from_system() / 86400)
						is_clm = (m.get("claimed_day") == current_day)
						# Daily: If done for day (claimed), hide notification. If not claimed, check target.
						if is_clm: is_done = false
					
					if is_done and not is_clm:
						has_claim = true
						break
			
			if has_claim:
				var _time = Time.get_ticks_msec() / 1000.0
				var scale_px = min(size.x, size.y) * 0.03
				var bob = sin(_time * 4.0) * (2.0 * scale_px)
				var center_icon = Vector2(size.x - (6 * scale_px), (6 * scale_px) + bob)
				_draw_exclaim_local(center_icon, scale_px, 1.0)

	# YENİ TASARIM: KRAL TACI (CROWN)
	func draw_rank_icon(c, col):
		# Tacın tabanı
		draw_rect(Rect2(c.x - 12, c.y + 8, 24, 4), col)
		# Sol diş
		draw_rect(Rect2(c.x - 12, c.y - 4, 6, 10), col)
		draw_rect(Rect2(c.x - 14, c.y - 8, 4, 4), col) # Sol uç
		# Orta diş (Daha uzun)
		draw_rect(Rect2(c.x - 4, c.y - 8, 8, 14), col)
		draw_rect(Rect2(c.x - 2, c.y - 12, 4, 4), col) # Orta uç
		# Sağ diş
		draw_rect(Rect2(c.x + 6, c.y - 4, 6, 10), col)
		draw_rect(Rect2(c.x + 10, c.y - 8, 4, 4), col) # Sağ uç

	# YENİ TASARIM: AYAR ÇUBUKLARI (SLIDERS)
	func draw_settings_icon(c, col):
		# Üst Çizgi ve Düğmesi
		draw_rect(Rect2(c.x - 12, c.y - 10, 24, 4), col)   # Çizgi
		draw_rect(Rect2(c.x + 4, c.y - 12, 6, 8), col)    # Düğme (Sağda)
 
		# Orta Çizgi ve Düğmesi
		draw_rect(Rect2(c.x - 12, c.y - 2, 24, 4), col)   # Çizgi
		draw_rect(Rect2(c.x - 8, c.y - 4, 6, 8), col)    # Düğme (Solda)
 
		# Alt Çizgi ve Düğmesi
		draw_rect(Rect2(c.x - 12, c.y + 6, 24, 4), col)   # Çizgi
		draw_rect(Rect2(c.x - 2, c.y + 4, 6, 8), col)    # Düğme (Ortada)
		
	# YENİ TASARIM: GÖREV/MİSYON (CLIPBOARD)
	func draw_mission_icon(c, col):
		var px = 1.0
		var c0 = c
		var p_light = Color("#fff3e0")
		var p_dark = Color("#ffe0b2")
		var wood = Color("#5d4037")
		var out = Color("#3e2723")
		var ink = Color("#795548")
		draw_rect(Rect2(c0.x-12*px, c0.y-12*px, 24*px, 6*px), out)
		draw_rect(Rect2(c0.x-10*px, c0.y-11*px, 20*px, 4*px), p_light)
		draw_rect(Rect2(c0.x-14*px, c0.y-12*px, 2*px, 6*px), wood)
		draw_rect(Rect2(c0.x+12*px, c0.y-12*px, 2*px, 6*px), wood)
		draw_rect(Rect2(c0.x-10*px, c0.y-7*px, 20*px, 20*px), out)
		draw_rect(Rect2(c0.x-8*px, c0.y-7*px, 16*px, 18*px), p_dark)
		draw_rect(Rect2(c0.x-8*px, c0.y+9*px, 4*px, 2*px), out)
		draw_rect(Rect2(c0.x+4*px, c0.y+8*px, 4*px, 3*px), out)
		draw_rect(Rect2(c0.x-6*px, c0.y-3*px, 12*px, 2*px), ink)
		draw_rect(Rect2(c0.x-6*px, c0.y+1*px, 8*px, 2*px), ink)
		draw_rect(Rect2(c0.x-6*px, c0.y+5*px, 10*px, 2*px), ink)

class SkinPreviewControl extends Control:
	var skin_id = ""
	var skin_manager_ref = null
	func _process(_delta):
		queue_redraw()
	func _draw():
		if skin_manager_ref and skin_id != "":
			skin_manager_ref.draw_skin_preview(self, size/2, 4.0, skin_id, Time.get_ticks_msec()/1000.0)

class SkinCardButton extends Button:
	const RARITY_COLORS = {
		"default": Color("#ffffff"),
		"common": Color("#b0b0b0"),
		"rare": Color("#4b69ff"),
		"epic": Color("#d32ce6"),
		"legendary": Color("#ff8000"),
		"mythic": Color("#ff0000")
	}

	var skin_id = ""
	var skin_name = ""
	var rarity = "common"
	var price = 0
	var is_owned = false
	var is_selected = false
	var rarity_color = Color.WHITE
	var custom_font_ref = null
	
	# Child Nodes
	var coin_icon_node = null
	
	func _ready():
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		rarity_color = RARITY_COLORS.get(rarity, Color("#b0b0b0"))
 
		# Prosedürel Coin İkonu Ekle (Fiyat varsa)
		if not is_owned and price > 0:
			coin_icon_node = CoinIcon.new()
			coin_icon_node.custom_minimum_size = Vector2(12, 12) # Küçük icon
			coin_icon_node.is_static = true # Fiyat yanındaki ikon sabit olsun
			coin_icon_node.mouse_filter = Control.MOUSE_FILTER_IGNORE
			add_child(coin_icon_node)
	
	func _process(_delta):
		queue_redraw()
	
	func _draw():
		var rect = Rect2(Vector2.ZERO, size)
		var font = custom_font_ref if custom_font_ref else get_theme_default_font()
 
		# 1. Background & Border
		draw_rect(rect, Color("#151520")) # Dark background
 
		var border_col = rarity_color
		var border_w = 2
 
		if is_hovered():
			border_col = border_col.lightened(0.2)
			border_w = 3
 
		if is_selected:
			border_col = Color("#ffd700")
			border_w = 4
 
		draw_rect(rect, border_col, false, border_w)
 
		# 2. Skin Name Banner (Top)
		var name_bg_h = 28
		draw_rect(Rect2(2, 2, size.x - 4, name_bg_h), border_col.darkened(0.6))
 
		# Name Text (Dynamic Scaling + truncation)
		var fs_name = 10
		var max_w = size.x - 10
		while fs_name > 5:
			var check_size = font.get_string_size(skin_name, HORIZONTAL_ALIGNMENT_CENTER, -1, fs_name)
			if check_size.x <= max_w:
				break
			fs_name -= 1
		var display_name = skin_name
		var str_size = font.get_string_size(display_name, HORIZONTAL_ALIGNMENT_CENTER, -1, fs_name)
		if str_size.x > max_w:
			# Truncate with ellipsis
			for i in range(display_name.length() - 1, 0, -1):
				display_name = display_name.substr(0, i) + "..."
				str_size = font.get_string_size(display_name, HORIZONTAL_ALIGNMENT_CENTER, -1, fs_name)
				if str_size.x <= max_w:
					break
		var name_pos = Vector2(size.x/2 - str_size.x/2, 20)
		draw_string(font, name_pos, display_name, HORIZONTAL_ALIGNMENT_LEFT, -1, fs_name, Color.WHITE)
 
		# 3. Preview (Center)
		# %10 küçültüldü: 2.2 -> 2.0
		var preview_center = Vector2(size.x/2, size.y/2 + 5)
		if SkinManager:
			var time = Time.get_ticks_msec() / 1000.0
			SkinManager.draw_skin_preview(self, preview_center, 2.0, skin_id, time)
 
		# 4. Bottom Info (Price/Status)
		var info_h = 32
		var info_rect = Rect2(2, size.y - info_h - 2, size.x - 4, info_h)
 
		# Status Background
		# User isteği: Sahip olunan skinlerde siyah katman kalksın.
		var status_bg = Color(0, 0, 0, 0.0) 
		if not is_owned:
			status_bg = Color(0, 0, 0, 0.5) 
		draw_rect(info_rect, status_bg)
 
		# Status Text
		var center_y = info_rect.get_center().y + 4
		var fs_price = 10
 
		if is_selected:
			# Seçili İkonu (Tik) - Sağ Üst Köşe için çizim (Aşağıda)
			pass 
		elif is_owned:
			draw_string_centered(font, Vector2(info_rect.get_center().x, center_y), Global.get_text("OWNED"), fs_price, Color("#90caf9"))
		else:
			# Price with Icon
			var price_text = str(price)
			if price == 0: price_text = Global.get_text("FREE")
 
			var icon_s = 12
			var gap = 4
			var text_w = font.get_string_size(price_text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs_price).x
			var total_w = icon_s + gap + text_w
 
			var start_x = info_rect.get_center().x - total_w / 2.0
 
			# Coin Icon Node Pozisyonlama
			if coin_icon_node:
				coin_icon_node.visible = true
				coin_icon_node.custom_minimum_size = Vector2(icon_s, icon_s)
				coin_icon_node.size = Vector2(icon_s, icon_s)
				# Manuel pozisyon set ediyoruz (Button control olduğu için layout karışabilir ama child ekledik)
				coin_icon_node.position = Vector2(start_x, center_y - 4 - icon_s/2.0)
 
			# Text
			draw_string(font, Vector2(start_x + icon_s + gap, center_y), price_text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs_price, Color("#ffd54f"))
 
			# Lock Icon (Top Right, Beautiful Pixel art)
			var lock_pos = Vector2(size.x - 20, name_bg_h + 6)
			draw_lock_icon(lock_pos, Color("#ef5350"))

		if is_selected:
			# Seçili Tik İkonu (Sağ Üst, Güzel bir rozet)
			var check_pos = Vector2(size.x - 20, name_bg_h + 6)
			draw_check_badge(check_pos, Color("#66bb6a"))

	func draw_lock_icon(pos, col):
		# Kilit Gövde
		draw_rect(Rect2(pos.x, pos.y + 5, 10, 8), col)
		# Kilit Halka (Üst)
		draw_rect(Rect2(pos.x + 2, pos.y, 6, 5), col, false, 2)
		# Keyhole
		draw_rect(Rect2(pos.x + 4, pos.y + 7, 2, 4), Color.BLACK.lightened(0.2))

	func draw_check_badge(pos, col):
		# Rozet (Circle bg)
		draw_circle(pos + Vector2(5, 5), 9, col)
		# Tik işareti (Beyaz)
		var c = pos + Vector2(5, 5)
		draw_line(c + Vector2(-3, 0), c + Vector2(-1, 3), Color.WHITE, 2)
		draw_line(c + Vector2(-1, 3), c + Vector2(4, -4), Color.WHITE, 2)

	func draw_string_centered(font, center, txt, sz, color):
		var str_size = font.get_string_size(txt, HORIZONTAL_ALIGNMENT_CENTER, -1, sz)
		draw_string(font, center - Vector2(str_size.x/2, -str_size.y/3), txt, HORIZONTAL_ALIGNMENT_CENTER, -1, sz, color)
# --- DAILY CHEST BUTTON CLASS ---
class DailyChestButton extends Button:
	var can_claim = false
	var is_open = false
	
	func _draw_exclaim_local(center: Vector2, px: float, pulse: float = 1.0):
		var bar_w = 3.0 * px
		var bar_h = 7.0 * px
		var dot_s = 3.0 * px
		var gap = 2.0 * px
		var total_h = bar_h + gap + dot_s
		var start = center - Vector2(bar_w / 2.0, total_h / 2.0)
		
		var col_base = EXCLAIM_COL_BASE
		var col_out = EXCLAIM_COL_OUT
		var col_shadow = EXCLAIM_COL_SHADOW
		var col_hi = EXCLAIM_COL_HI
		col_base.a *= pulse; col_out.a *= pulse; col_shadow.a *= pulse; col_hi.a *= pulse
		
		# Outline
		draw_rect(Rect2(start.x - px, start.y - px, bar_w + 2*px, bar_h + 2*px), col_out)
		var dot_y = start.y + bar_h + gap
		draw_rect(Rect2(start.x - px, dot_y - px, dot_s + 2*px, dot_s + 2*px), col_out)
		# Shadow
		draw_rect(Rect2(start.x + px, start.y + px, bar_w, bar_h), col_shadow)
		draw_rect(Rect2(start.x + px, dot_y + px, dot_s, dot_s), col_shadow)
		# Body
		draw_rect(Rect2(start.x, start.y, bar_w, bar_h), col_base)
		draw_rect(Rect2(start.x, dot_y, dot_s, dot_s), col_base)
		# Highlight
		draw_rect(Rect2(start.x, start.y, px, px*2), col_hi)
		draw_rect(Rect2(start.x, dot_y, px, px), col_hi)
	
	func _ready():
		focus_mode = Control.FOCUS_NONE
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		flat = true

	func _process(_delta):
		queue_redraw()
 
	func _draw_ellipse(center: Vector2, _size: Vector2, color: Color):
		# Simple ellipse via scale + circle
		if _size.x == 0:
			return
		draw_set_transform(center, 0, Vector2(1.0, _size.y / _size.x))
		draw_circle(Vector2.ZERO, _size.x, color)
		draw_set_transform(Vector2.ZERO, 0, Vector2(1,1))


	func _draw():

		var c = size / 2.0
		var s = min(size.x, size.y) / 50.0 

		# Chest dimensions
		var w = 34.0 * s
		var h = 26.0 * s
		var base_pos = c - Vector2(w/2, h/2 - 6*s)
		
		var chest_rect = Rect2(base_pos.x, base_pos.y, w, h)

		# Colors
		var C_WOOD_DARK = Color("#4b332a")
		var C_WOOD_LITE = Color("#805b46")
		var C_WOOD_HIGH = Color("#a67c52")
		var C_GOLD = Color("#ffbf3f")
		var C_GOLD_LITE = Color("#ffe28a")
		var C_SHADOW = Color(0,0,0,0.4)

		# Soft shadow
		_draw_ellipse(c + Vector2(0, h/2), Vector2(w * 0.6, 6*s), Color(0,0,0,0.25))

		if is_open:
			# Lid lifted slightly
			var lid_h = h * 0.45
			var lid_rect = Rect2(chest_rect.position.x, chest_rect.position.y - (lid_h * 0.7), w, lid_h)
			draw_rect(lid_rect, C_WOOD_DARK)
			draw_rect(Rect2(lid_rect.position + Vector2(2,2)*s, lid_rect.size - Vector2(4,4)*s), C_WOOD_HIGH)
			
			# Back interior glow
			draw_rect(chest_rect, Color(0.1, 0.08, 0.02, 0.85))
			draw_rect(Rect2(chest_rect.position + Vector2(4,4)*s, chest_rect.size - Vector2(8,8)*s), Color(1, 0.9, 0.4, 0.3))

			# Front body
			var front_h = h * 0.7
			var front_rect = Rect2(chest_rect.position.x, chest_rect.end.y - front_h, w, front_h)
			draw_rect(front_rect, C_WOOD_DARK)
			draw_rect(Rect2(front_rect.position + Vector2(2,2)*s, front_rect.size - Vector2(4,4)*s), C_WOOD_LITE)
			
			# Bands
			draw_rect(Rect2(front_rect.position.x + 5*s, front_rect.position.y, 4*s, front_h), C_GOLD)
			draw_rect(Rect2(front_rect.end.x - 9*s, front_rect.position.y, 4*s, front_h), C_GOLD)

			# Inner shine
			draw_rect(Rect2(front_rect.position.x + 2*s, front_rect.position.y + 2*s, w - 4*s, 3*s), Color(1,1,1,0.15))
		else:
			# CLOSED CHEST
			draw_rect(chest_rect, C_WOOD_DARK)
			draw_rect(Rect2(chest_rect.position + Vector2(2,2)*s, chest_rect.size - Vector2(4,4)*s), C_WOOD_LITE)
			
			# Lid separation
			var lid_y = chest_rect.position.y + h * 0.42
			draw_line(Vector2(chest_rect.position.x, lid_y), Vector2(chest_rect.end.x, lid_y), C_SHADOW, 2.0*s)

			# Gold bands
			var band_w = 4.0 * s
			draw_rect(Rect2(chest_rect.position.x + 6*s, chest_rect.position.y, band_w, h), C_GOLD)
			draw_rect(Rect2(chest_rect.end.x - 10*s, chest_rect.position.y, band_w, h), C_GOLD)

			# Lock plate
			var lock_size = 7.0 * s
			var lock_pos = c - Vector2(lock_size/2, lock_size/2) + Vector2(0, 2*s)
			draw_rect(Rect2(lock_pos, Vector2(lock_size, lock_size)), C_GOLD_LITE)
			draw_rect(Rect2(lock_pos, Vector2(lock_size, lock_size)), C_SHADOW, false, 1.0*s)
			draw_rect(Rect2(lock_pos + Vector2(2,2)*s, Vector2(lock_size - 4*s, lock_size - 4*s)), C_WOOD_DARK)

			# Top highlight
			draw_rect(Rect2(chest_rect.position.x + 2*s, chest_rect.position.y + 2*s, w - 4*s, 2*s), Color(1,1,1,0.18))

		# Claim badge (exclamation) - always drawn on top of chest
		if can_claim:
			var _time = Time.get_ticks_msec() / 1000.0
			var bob = sin(_time * 4.0) * (2.0 * s)
			var badge_pos = chest_rect.position + Vector2(chest_rect.size.x - 6*s, -10*s + bob)
			_draw_exclaim_local(badge_pos, 1.2 * s, 1.0)

# --- HEDİYE KODU POPUP ---
func show_gift_code_popup():
	if gift_code_popup: gift_code_popup.queue_free()
	
	gift_code_popup = Control.new()
	gift_code_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	gift_code_popup.visible = false
	gift_code_popup.z_index = 30
	add_child(gift_code_popup)
	
	var overlay_bg = ColorRect.new()
	overlay_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay_bg.color = Color(0, 0, 0, 0.8)
	gift_code_popup.add_child(overlay_bg)
	
	var panel_w = min(400 * ui_scale, screen_size.x * 0.9)
	var panel_h = min(350 * ui_scale, screen_size.y * 0.6)
	var panel = create_popup_panel(Vector2(panel_w, panel_h))
	panel.position = (screen_size - Vector2(panel_w, panel_h)) / 2.0
	gift_code_popup.add_child(panel)
	
	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 15)
	margin.add_child(vbox)
	
	# Header with title and close button
	var header = HBoxContainer.new()
	vbox.add_child(header)
	
	var title = Label.new()
	title.text = Global.get_text("GIFT_CODE")
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", int(24 * ui_scale))
	if custom_font: title.add_theme_font_override("font", custom_font)
	title.add_theme_color_override("font_color", Color("#ffd700"))
	header.add_child(title)
	
	var btn_close = create_css_button("X", Color("#e53935"), Color("#c62828"), Color("#b71c1c"), 2, int(16 * ui_scale))
	btn_close.custom_minimum_size = Vector2(40, 40) * ui_scale
	btn_close.pressed.connect(func(): close_popup(gift_code_popup))
	header.add_child(btn_close)
	
	vbox.add_child(HSeparator.new())
	
	var lbl_desc = Label.new()
	lbl_desc.text = Global.get_text("ENTER_CODE")
	lbl_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if custom_font: lbl_desc.add_theme_font_override("font", custom_font)
	vbox.add_child(lbl_desc)
	
	var code_input = LineEdit.new()
	code_input.placeholder_text = "XXXXX"
	code_input.add_theme_font_size_override("font_size", int(20 * ui_scale))
	if custom_font: code_input.add_theme_font_override("font", custom_font)
	code_input.custom_minimum_size.y = 50 * ui_scale
	vbox.add_child(code_input)
	
	# Hata mesajı için sabit yükseklik (taşmayı önlemek için)
	var lbl_error = Label.new()
	lbl_error.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_error.add_theme_color_override("font_color", Color("#ff4444"))
	lbl_error.visible = false
	lbl_error.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lbl_error.custom_minimum_size.y = 40 * ui_scale  # Sabit yükseklik
	lbl_error.clip_contents = true
	if custom_font: lbl_error.add_theme_font_override("font", custom_font)
	vbox.add_child(lbl_error)
	
	var btn_submit = create_css_button(Global.get_text("SUBMIT"), Color("#41c741"), Color("#42b442"), Color("#2a6d2a"), 2, int(16 * ui_scale))
	btn_submit.custom_minimum_size.y = 50 * ui_scale
	btn_submit.pressed.connect(func():
		var code = code_input.text.strip_edges().to_lower()
		if code == "":
			lbl_error.text = Global.get_text("ENTER_CODE")
			lbl_error.visible = true
			return
		
		# Admin kodu kontrolü
		if AdminManager and code == AdminManager.get_admin_code().to_lower():
			close_popup(gift_code_popup)
			show_admin_panel()
			return
		
		# Kupon kodu kontrolü (PHP API üzerinden)
		if LeaderboardManager:
			btn_submit.text = "..."
			btn_submit.disabled = true
			lbl_error.visible = false
			
			var device_id = Global.custom_device_id if Global.custom_device_id != "" else OS.get_unique_id()
			LeaderboardManager.use_coupon_api(code, device_id)
			
			var result = await LeaderboardManager.coupon_result
			
			if is_instance_valid(btn_submit):
				btn_submit.text = Global.get_text("SUBMIT")
				btn_submit.disabled = false
			
			if result.get("success", false):
				var gold_amount = int(result.get("gold", 0))
				Global.add_coins(gold_amount)
				Global.save_game()
				# Coin display güncelle
				if shop_popup and shop_popup.visible:
					setup_shop_popup("skills")
					show_popup(shop_popup)
				# Başarı popup göster
				close_popup(gift_code_popup)
				show_code_success_popup(gold_amount)
			else:
				var error_key = result.get("message", "CODE_NOT_FOUND")
				if is_instance_valid(lbl_error):
					lbl_error.text = Global.get_text(error_key)
					lbl_error.visible = true
		else:
			lbl_error.text = Global.get_text("CODE_NOT_FOUND")
			lbl_error.visible = true
	)
	vbox.add_child(btn_submit)
	
	show_popup(gift_code_popup)
	code_input.grab_focus()

# --- ADMIN PANEL POPUP ---
func show_admin_panel():
	if admin_panel_popup: admin_panel_popup.queue_free()
	
	# Open olduğunda taze veri çek
	if LeaderboardManager:
		LeaderboardManager.fetch_leaderboard()
	
	admin_panel_popup = Control.new()
	admin_panel_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	admin_panel_popup.visible = false
	admin_panel_popup.z_index = 40
	add_child(admin_panel_popup)
	
	var overlay_bg = ColorRect.new()
	overlay_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay_bg.color = Color(0, 0, 0, 0.9)
	admin_panel_popup.add_child(overlay_bg)
	
	var panel_w = min(800 * ui_scale, screen_size.x * 0.95)
	var panel_h = min(700 * ui_scale, screen_size.y * 0.9)
	var panel = create_popup_panel(Vector2(panel_w, panel_h))
	panel.position = (screen_size - Vector2(panel_w, panel_h)) / 2.0
	admin_panel_popup.add_child(panel)
	
	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_top", 15)
	margin.add_theme_constant_override("margin_bottom", 15)
	margin.add_theme_constant_override("margin_left", 15)
	margin.add_theme_constant_override("margin_right", 15)
	panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)
	
	var title = Label.new()
	title.text = Global.get_text("ADMIN_PANEL")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", int(28 * ui_scale))
	if custom_font: title.add_theme_font_override("font", custom_font)
	title.add_theme_color_override("font_color", Color("#ff0000"))
	vbox.add_child(title)
	
	vbox.add_child(HSeparator.new())
	
	# Tabs
	var tabs = HBoxContainer.new()
	var tab_users = create_css_button("USERS", Color("#3e5ba9"), Color("#4e6bb9"), Color("#2e4b99"), 2, int(14 * ui_scale))
	tab_users.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tabs.add_child(tab_users)
	
	var tab_coupons = create_css_button("COUPONS", Color("#3e5ba9"), Color("#4e6bb9"), Color("#2e4b99"), 2, int(14 * ui_scale))
	tab_coupons.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tabs.add_child(tab_coupons)
	
	var btn_close_admin = create_css_button("X", Color("#e53935"), Color("#c62828"), Color("#b71c1c"), 2, int(16 * ui_scale))
	btn_close_admin.custom_minimum_size = Vector2(40, 40) * ui_scale
	btn_close_admin.pressed.connect(func(): close_popup(admin_panel_popup))
	tabs.add_child(btn_close_admin)
	
	# REFRESH Button (Tab bar'ın sağına)
	var btn_refresh = create_css_button("REFRESH", Color("#FF9800"), Color("#FFB74D"), Color("#F57C00"), 2, int(12 * ui_scale))
	btn_refresh.custom_minimum_size = Vector2(80 * ui_scale, 40 * ui_scale)
	btn_refresh.pressed.connect(func():
		if LeaderboardManager:
			btn_refresh.text = "..."
			btn_refresh.disabled = true
			
			LeaderboardManager.fetch_leaderboard()
			
			# Signal'i bekle (timeoutlu)
			var timer = get_tree().create_timer(5.0)
			await LeaderboardManager.leaderboard_updated
			
			if is_instance_valid(btn_refresh):
				btn_refresh.text = "REFRESH"
				btn_refresh.disabled = false
				# Paneli tamamen yenile (Veriler güncellendiği için)
				show_admin_panel()
	)
	tabs.add_child(btn_refresh)
	
	# GLOBAL SAVE Button (Tüm değişiklikleri sunucuya zorla)
	var btn_save_all = create_css_button("SAVE ALL", Color("#43A047"), Color("#66BB6A"), Color("#2E7D32"), 2, int(12 * ui_scale))
	btn_save_all.custom_minimum_size = Vector2(80 * ui_scale, 40 * ui_scale)
	btn_save_all.pressed.connect(func():
		if LeaderboardManager and AdminManager:
			btn_save_all.text = "SAVING..."
			btn_save_all.disabled = true
			
			# 1. Admin Data'yı Gist'e kaydet
			AdminManager.save_admin_data()
			
			# 2. Tüm yerel değişiklikleri sunucuya zorla gönder
			if AdminManager.admin_data.has("users"):
				for did in AdminManager.admin_data["users"]:
					# Gizli kullanıcıları atla
					if AdminManager.admin_data.has("hidden_users") and did in AdminManager.admin_data["hidden_users"]:
						continue
						
					var u_data = AdminManager.admin_data["users"][did]
					var u_name = u_data.get("name", "Unknown")
					var u_score = int(u_data.get("score", 0))
					
					# SMART SYNC: Server mevcut skoru kontrol et
					var server_score = 0
					if Global.leaderboard_data is Array:
						for entry in Global.leaderboard_data:
							if str(entry.get("device_id")) == str(did):
								server_score = int(entry.get("score", 0))
								break
					
					# Eğer yerel skor sunucudan düşükse, sunucu skorunu gönder (isim güncellemesi için)
					var score_to_send = u_score
					if u_score < server_score:
						score_to_send = server_score
					
					# Gönder
					LeaderboardManager.submit_score_for_user(score_to_send, u_name, str(did))
					await get_tree().create_timer(0.1).timeout # Flood koruması için ufak bekleme
			
			# 3. UI Feedback ve Yenileme
			btn_save_all.text = "DONE!"
			await get_tree().create_timer(1.0).timeout
			
			if is_instance_valid(btn_save_all):
				btn_save_all.text = "SAVE ALL"
				btn_save_all.disabled = false
				# Refresh tetikle
				btn_refresh.pressed.emit()
	)
	tabs.add_child(btn_save_all)
	
	vbox.add_child(tabs)
	vbox.add_child(HSeparator.new())
	
	# Content area
	var content_area = MarginContainer.new()
	content_area.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(content_area)
	
	# Users tab content
	var users_scroll = ScrollContainer.new()
	users_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var users_vbox = VBoxContainer.new()
	users_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	users_scroll.add_child(users_vbox)
	
	# Load users from leaderboard (max 50) + kendi cihazımız
	if AdminManager:
		# Önce leaderboard'dan kullanıcıları yükle

		var my_device_id = Global.custom_device_id if Global.custom_device_id != "" else OS.get_unique_id()
	
		# Load users from leaderboard (max 50) + local admin data
		# Merge sources: AdminData acts as master for names, Leaderboard for recent scores
		var merged_users = {}
		
		# 1. Start with Live Leaderboard Data (Truth for existence and score)
		if Global.leaderboard_data is Array:
			for entry in Global.leaderboard_data:
				var did = str(entry.get("device_id", ""))
				if did != "":
					# Skip hidden users
					if AdminManager.admin_data.has("hidden_users") and did in AdminManager.admin_data["hidden_users"]:
						continue

					merged_users[did] = {
						"name": entry.get("name", "Unknown"), 
						"score": int(entry.get("score", 0)), 
						"device_id": did
					}
		
		# 2. AdminData artık nam/skor için kullanılmıyor (sunucu verisi geçerli)
		# Sadece hidden_users filtresi uygulanıyor (yukarıda zaten yapılıyor)
		# Eski merge mantığı kaldırıldı - sunucu verisi doğrudan gösteriliyor
		
		# Convert back to array for display
		var users_to_show = []
		for k in merged_users:
			users_to_show.append(merged_users[k])
		
		# Sort by score descending
		users_to_show.sort_custom(func(a, b): return a["score"] > b["score"])
	
		# Status mesajı için label (genel)
		var status_label = Label.new()
		status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		status_label.add_theme_font_size_override("font_size", int(12 * ui_scale))
		status_label.visible = false
		if custom_font: status_label.add_theme_font_override("font", custom_font)
		users_vbox.add_child(status_label)
		
		# Kullanıcıları göster (leaderboard + kendi cihazımız)
		if users_to_show.size() > 0:
			for user_entry in users_to_show:
				var device_id = user_entry["device_id"]
				var user_name = user_entry["name"]
				var user_score = user_entry["score"]
				var is_self = (device_id == my_device_id) 
				
				# Her kullanıcı için panel oluştur
				var user_panel = PanelContainer.new()
				var panel_style = StyleBoxFlat.new()
				# Kendi cihazımızı farklı renkle göster
				if is_self:
					panel_style.bg_color = Color("#2a3a2a")  # Yeşilimsi
					panel_style.border_color = Color("#41c741")
				else:
					panel_style.bg_color = Color("#2a2a3a")
					panel_style.border_color = Color("#444455")
				panel_style.set_corner_radius_all(4)
				panel_style.border_width_left = 2
				user_panel.add_theme_stylebox_override("panel", panel_style)
				user_panel.custom_minimum_size.y = 80 * ui_scale
				
				var user_margin = MarginContainer.new()
				user_margin.add_theme_constant_override("margin_top", 8)
				user_margin.add_theme_constant_override("margin_bottom", 8)
				user_margin.add_theme_constant_override("margin_left", 10)
				user_margin.add_theme_constant_override("margin_right", 10)
				user_panel.add_child(user_margin)
				
				var user_vbox = VBoxContainer.new()
				user_vbox.add_theme_constant_override("separation", 8)
				user_margin.add_child(user_vbox)
				
				# Device ID (küçük) + Kendi cihazımız etiketi
				var lbl_id = Label.new()
				var id_text = "ID: " + device_id.substr(0, 12) + "..."
				if is_self or device_id == my_device_id:
					id_text += " (YOU)"
				lbl_id.text = id_text
				lbl_id.add_theme_font_size_override("font_size", int(10 * ui_scale))
				lbl_id.add_theme_color_override("font_color", Color.GRAY if not (is_self or device_id == my_device_id) else Color("#41c741"))
				if custom_font: lbl_id.add_theme_font_override("font", custom_font)
				user_vbox.add_child(lbl_id)
				
				# Name ve Score yan yana
				var name_score_hbox = HBoxContainer.new()
				name_score_hbox.add_theme_constant_override("separation", 10)
				user_vbox.add_child(name_score_hbox)
				
				# Name input
				var name_label = Label.new()
				name_label.text = "Name:"
				name_label.custom_minimum_size.x = 60 * ui_scale
				name_label.add_theme_font_size_override("font_size", int(12 * ui_scale))
				if custom_font: name_label.add_theme_font_override("font", custom_font)
				name_score_hbox.add_child(name_label)
				
				var name_input = LineEdit.new()
				name_input.text = user_name
				name_input.placeholder_text = Global.get_text("USER_NAME")
				name_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				name_input.custom_minimum_size.y = 35 * ui_scale
				name_input.add_theme_font_size_override("font_size", int(12 * ui_scale))
				if custom_font: name_input.add_theme_font_override("font", custom_font)
				name_score_hbox.add_child(name_input)
				
				# Score input
				var score_label = Label.new()
				score_label.text = "Score:"
				score_label.custom_minimum_size.x = 60 * ui_scale
				score_label.add_theme_font_size_override("font_size", int(12 * ui_scale))
				if custom_font: score_label.add_theme_font_override("font", custom_font)
				name_score_hbox.add_child(score_label)
				
				var score_input = LineEdit.new()
				score_input.text = str(user_score)
				score_input.placeholder_text = Global.get_text("USER_SCORE")
				score_input.custom_minimum_size = Vector2(120 * ui_scale, 35 * ui_scale)
				score_input.add_theme_font_size_override("font_size", int(12 * ui_scale))
				if custom_font: score_input.add_theme_font_override("font", custom_font)
				name_score_hbox.add_child(score_input)
				
				# Save button
				var btn_save_user = create_css_button(Global.get_text("SAVE"), Color("#41c741"), Color("#42b442"), Color("#2a6d2a"), 2, int(12 * ui_scale))
				btn_save_user.custom_minimum_size = Vector2(80 * ui_scale, 35 * ui_scale)
				var current_device_id = device_id  # Closure için kopyala
				btn_save_user.pressed.connect(func():
					if not is_instance_valid(status_label) or not is_instance_valid(btn_save_user):
						return
					# Loading mesajı
					status_label.text = "Saving..."
					status_label.add_theme_color_override("font_color", Color("#ffd700"))
					status_label.visible = true
					btn_save_user.disabled = true
					
					var new_name = name_input.text.strip_edges()
					var new_score = int(score_input.text) if score_input.text.is_valid_int() else 0
					
					# Admin data'yı güncelle
					if not AdminManager.admin_data.has("users"):
						AdminManager.admin_data["users"] = {}
					AdminManager.admin_data["users"][current_device_id] = {"name": new_name, "score": new_score}
					
					AdminManager.update_user(current_device_id, new_name, new_score)
					
					# SMART SYNC: Server asla düşük skoru kabul etmez. İsim güncellemesi için MAX skoru gönder.
					var score_to_send = new_score
					var server_score = 0
					
					# Serverdaki mevcut skoru bul
					if Global.leaderboard_data is Array:
						for entry in Global.leaderboard_data:
							if str(entry.get("device_id")) == str(current_device_id):
								server_score = int(entry.get("score", 0))
								break
					
					if new_score < server_score:
						score_to_send = server_score
						# Kullanıcıyı uyar (İsim değişti ama skor düşmedi)
						status_label.text = "Name updated! Score kept at max (" + str(server_score) + ") by server."
						status_label.add_theme_color_override("font_color", Color("#ffd700"))
					
					# Eğer bu kullanıcı şu anki cihazsa, local high_score'u admin'in verdiği score ile değiştir (Localde düşebilir)
					if current_device_id == my_device_id:
						# Admin'in verdiği score'u kaydet ve eski rekoru sil
						Global.set("admin_set_score", new_score)
						Global.set("admin_set_name", new_name)
						Global.high_score = new_score
						Global.player_name = new_name
						Global.save_game()
						
						# Sunucuya da bildir (Doğru ID ve İsim ile)
						if LeaderboardManager:
							LeaderboardManager.submit_score_for_user(score_to_send, new_name, current_device_id)
					else:
						# Başka kullanıcı ise sadece sunucuya bildir (Global değişikliği yok)
						if LeaderboardManager:
							LeaderboardManager.submit_score_for_user(score_to_send, new_name, current_device_id)
					
					# Leaderboard'u güncelle
					if Global.leaderboard_data is Array:
						for i in range(Global.leaderboard_data.size()):
							var entry = Global.leaderboard_data[i]
							if entry.get("device_id") == current_device_id:
								entry["name"] = new_name
								entry["score"] = new_score
								break
					
					# Leaderboard popup açıksa yeniden oluştur
					if leaderboard_popup and leaderboard_popup.visible:
						setup_leaderboard_popup()
						show_popup(leaderboard_popup)
					else:
						# Popup açık değilse de setup'ı çağır ki bir sonraki açılışta güncel olsun
						setup_leaderboard_popup()
				)
				name_score_hbox.add_child(btn_save_user)
				
				users_vbox.add_child(user_panel)
				
				# Save sonrası status güncelleme (signal yerine await kullan)
				var update_status_func = func():
					await get_tree().create_timer(1.5).timeout
					if is_instance_valid(status_label) and is_instance_valid(btn_save_user):
						if admin_panel_popup and admin_panel_popup.visible:
							status_label.text = "Saved!"
						status_label.add_theme_color_override("font_color", Color.GREEN)
						btn_save_user.disabled = false
						# Auto hide status
						await get_tree().create_timer(2.0).timeout
						if is_instance_valid(status_label): status_label.visible = false
				btn_save_user.pressed.connect(update_status_func)
	
				# RESET IDENTITY BUTTON
				var btn_reset_id = create_css_button("NEW ID", Color("#AB47BC"), Color("#BA68C8"), Color("#8E24AA"), 2, int(10 * ui_scale))
				btn_reset_id.custom_minimum_size = Vector2(60 * ui_scale, 35 * ui_scale)
				# Sadece kendi cihazımız için aktif olsun
				if current_device_id != OS.get_unique_id() and current_device_id != Global.custom_device_id:
					btn_reset_id.disabled = true
					btn_reset_id.modulate.a = 0.5
				
				btn_reset_id.pressed.connect(func():
					if not is_instance_valid(status_label): return
					
					# Yeni rastgele ID oluştur (UUID v4 benzeri)
					var uuid = str(randi()) + str(Time.get_unix_time_from_system()) + str(OS.get_unique_id())
					var new_id = uuid.md5_text()
					var final_id = "{" + new_id.substr(0,8) + "-" + new_id.substr(8,4) + "-" + new_id.substr(12,4) + "-" + new_id.substr(16,4) + "-" + new_id.substr(20) + "}"
					
					Global.custom_device_id = final_id
					Global.high_score = 0 # Yeni kimlik, yeni skor
					Global.save_game()
					
					status_label.text = "ID Reset! Restart Game."
					status_label.add_theme_color_override("font_color", Color("#AB47BC"))
					status_label.visible = true
					btn_reset_id.disabled = true
					
					# Ekranda ID metnini güncelle
					lbl_id.text = "ID: " + final_id.substr(0, 12) + "... (NEW)"
					lbl_id.add_theme_color_override("font_color", Color("#AB47BC"))
				)
				name_score_hbox.add_child(btn_reset_id)
				
				# DELETE USER BUTTON (Only removes from Admin Gist & Local view)
				var btn_del_user = create_css_button("DEL", Color("#b71c1c"), Color("#c62828"), Color("#7f0000"), 2, int(10 * ui_scale))
				btn_del_user.custom_minimum_size = Vector2(40 * ui_scale, 35 * ui_scale)
				btn_del_user.pressed.connect(func():
					if not is_instance_valid(status_label): return
					
					# Gizleme mantığı (Server silme desteklemiyor)
					if not AdminManager.admin_data.has("hidden_users"):
						AdminManager.admin_data["hidden_users"] = []
					
					if not device_id in AdminManager.admin_data["hidden_users"]:
						AdminManager.admin_data["hidden_users"].append(device_id)
					
					# Yerel veriden de sil (Optional, but clean)
					if AdminManager.admin_data.has("users") and AdminManager.admin_data["users"].has(device_id):
						AdminManager.admin_data["users"].erase(device_id)
						
					AdminManager.save_admin_data()
					
					# UI update
					user_panel.visible = false
					
					# 3. Not: PHP sunucusundan (galaktikuzay) silinemez, API desteklemiyor.
				)
				name_score_hbox.add_child(btn_del_user)
				

	
	content_area.add_child(users_scroll)
	
	# Coupons tab content (simplified for now)
	var coupons_scroll = ScrollContainer.new()
	coupons_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	coupons_scroll.visible = false
	var coupons_vbox = VBoxContainer.new()
	coupons_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	coupons_scroll.add_child(coupons_vbox)
	
	# Add coupon form
	var add_form = VBoxContainer.new()
	var lbl_code = Label.new()
	lbl_code.text = Global.get_text("COUPON_CODE")
	if custom_font: lbl_code.add_theme_font_override("font", custom_font)
	add_form.add_child(lbl_code)
	
	var code_input = LineEdit.new()
	code_input.placeholder_text = "XXXXX"
	if custom_font: code_input.add_theme_font_override("font", custom_font)
	add_form.add_child(code_input)
	
	var lbl_gold = Label.new()
	lbl_gold.text = Global.get_text("GOLD_AMOUNT")
	if custom_font: lbl_gold.add_theme_font_override("font", custom_font)
	add_form.add_child(lbl_gold)
	
	var gold_input = LineEdit.new()
	gold_input.placeholder_text = "100 (or -100 to remove)"
	if custom_font: gold_input.add_theme_font_override("font", custom_font)
	add_form.add_child(gold_input)
	
	var lbl_max = Label.new()
	lbl_max.text = Global.get_text("MAX_USES") + " (-1 = " + Global.get_text("UNLIMITED") + ")"
	if custom_font: lbl_max.add_theme_font_override("font", custom_font)
	add_form.add_child(lbl_max)
	
	var max_input = LineEdit.new()
	max_input.placeholder_text = "-1"
	if custom_font: max_input.add_theme_font_override("font", custom_font)
	add_form.add_child(max_input)
	
	var btn_add = create_css_button(Global.get_text("ADD_COUPON"), Color("#41c741"), Color("#42b442"), Color("#2a6d2a"), 2, int(14 * ui_scale))
	btn_add.pressed.connect(func():
		if not is_instance_valid(code_input) or not is_instance_valid(gold_input) or not is_instance_valid(max_input):
			return
		var code = code_input.text.strip_edges().to_lower()
		# Negatif değerleri de kabul et
		var gold_text = gold_input.text.strip_edges()
		var gold = 0
		if gold_text.is_valid_int():
			gold = int(gold_text)
		elif gold_text.begins_with("-") and gold_text.substr(1).is_valid_int():
			gold = int(gold_text)
		var max_uses = int(max_input.text) if max_input.text.is_valid_int() else -1
		if code != "" and gold != 0:  # 0'dan farklı olmalı
			AdminManager.add_coupon(code, gold, max_uses)
			code_input.text = ""
			gold_input.text = ""
			max_input.text = "-1"
			# Panel'i refresh et (admin paneli açıksa)
			await get_tree().create_timer(0.5).timeout
			if admin_panel_popup and admin_panel_popup.visible:
				show_admin_panel()
	)
	add_form.add_child(btn_add)
	coupons_vbox.add_child(add_form)
	coupons_vbox.add_child(HSeparator.new())
	
	# List coupons - Header
	var coupon_header = HBoxContainer.new()
	var h_code = Label.new()
	h_code.text = "CODE"
	h_code.custom_minimum_size.x = 120 * ui_scale
	h_code.add_theme_color_override("font_color", Color.GRAY)
	h_code.add_theme_font_size_override("font_size", int(12 * ui_scale))
	if custom_font: h_code.add_theme_font_override("font", custom_font)
	coupon_header.add_child(h_code)
	
	var h_gold = Label.new()
	h_gold.text = "GOLD"
	h_gold.custom_minimum_size.x = 100 * ui_scale
	h_gold.add_theme_color_override("font_color", Color.GRAY)
	h_gold.add_theme_font_size_override("font_size", int(12 * ui_scale))
	if custom_font: h_gold.add_theme_font_override("font", custom_font)
	coupon_header.add_child(h_gold)
	
	var h_uses = Label.new()
	h_uses.text = "USES"
	h_uses.custom_minimum_size.x = 80 * ui_scale
	h_uses.add_theme_color_override("font_color", Color.GRAY)
	h_uses.add_theme_font_size_override("font_size", int(12 * ui_scale))
	if custom_font: h_uses.add_theme_font_override("font", custom_font)
	coupon_header.add_child(h_uses)
	
	coupons_vbox.add_child(coupon_header)
	coupons_vbox.add_child(HSeparator.new())
	
	# List coupons
	if AdminManager and AdminManager.admin_data.has("coupons") and AdminManager.admin_data["coupons"].size() > 0:
		var coupons_data = AdminManager.admin_data["coupons"]
		for code in coupons_data:
			var coupon = coupons_data[code]
			# Her kupon için bir panel oluştur
			var coupon_panel = PanelContainer.new()
			var panel_style = StyleBoxFlat.new()
			panel_style.bg_color = Color("#2a2a3a")
			panel_style.set_corner_radius_all(4)
			panel_style.border_color = Color("#444455")
			panel_style.border_width_left = 2
			coupon_panel.add_theme_stylebox_override("panel", panel_style)
			coupon_panel.custom_minimum_size.y = 60 * ui_scale
			
			var coupon_margin = MarginContainer.new()
			coupon_margin.add_theme_constant_override("margin_top", 8)
			coupon_margin.add_theme_constant_override("margin_bottom", 8)
			coupon_margin.add_theme_constant_override("margin_left", 10)
			coupon_margin.add_theme_constant_override("margin_right", 10)
			coupon_panel.add_child(coupon_margin)
			
			var coupon_hbox = HBoxContainer.new()
			coupon_hbox.add_theme_constant_override("separation", 10)
			coupon_margin.add_child(coupon_hbox)
			
			var lbl_c = Label.new()
			lbl_c.text = "Code: " + code.to_upper()
			lbl_c.custom_minimum_size.x = 150 * ui_scale
			lbl_c.add_theme_font_size_override("font_size", int(12 * ui_scale))
			if custom_font: lbl_c.add_theme_font_override("font", custom_font)
			coupon_hbox.add_child(lbl_c)
			
			var lbl_g = Label.new()
			var gold_val = coupon["gold"]
			if gold_val < 0:
				lbl_g.add_theme_color_override("font_color", Color("#ff4444"))
			else:
				lbl_g.add_theme_color_override("font_color", Color("#ffd700"))
			lbl_g.text = "Gold: " + str(gold_val)
			lbl_g.custom_minimum_size.x = 120 * ui_scale
			lbl_g.add_theme_font_size_override("font_size", int(12 * ui_scale))
			if custom_font: lbl_g.add_theme_font_override("font", custom_font)
			coupon_hbox.add_child(lbl_g)
			
			var lbl_u = Label.new()
			var uses_text = "Uses: " + str(coupon["used_count"])
			if coupon["max_uses"] > 0:
				uses_text += "/" + str(coupon["max_uses"])
			else:
				uses_text += "/∞"
			lbl_u.text = uses_text
			lbl_u.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			lbl_u.add_theme_font_size_override("font_size", int(12 * ui_scale))
			if custom_font: lbl_u.add_theme_font_override("font", custom_font)
			coupon_hbox.add_child(lbl_u)
			
			var btn_del = create_css_button(Global.get_text("DELETE"), Color("#e53935"), Color("#c62828"), Color("#b71c1c"), 2, int(12 * ui_scale))
			btn_del.custom_minimum_size = Vector2(80, 35) * ui_scale
			var current_code = code  # Closure için
			btn_del.pressed.connect(func():
				AdminManager.remove_coupon(current_code)
				# Panel'i refresh et (admin paneli açıksa)
				await get_tree().create_timer(0.5).timeout
				if admin_panel_popup and admin_panel_popup.visible:
					show_admin_panel()
			)
			coupon_hbox.add_child(btn_del)
			
			coupons_vbox.add_child(coupon_panel)
	else:
		var lbl_no_coupons = Label.new()
		lbl_no_coupons.text = "No coupons yet"
		lbl_no_coupons.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl_no_coupons.add_theme_font_size_override("font_size", int(14 * ui_scale))
		if custom_font: lbl_no_coupons.add_theme_font_override("font", custom_font)
		coupons_vbox.add_child(lbl_no_coupons)
	
	content_area.add_child(coupons_scroll)
	
	# Tab switching
	var tab_contents = {"users": users_scroll, "coupons": coupons_scroll}
	tab_users.pressed.connect(func(): 
		for k in tab_contents:
			tab_contents[k].visible = (k == "users")
		tab_users.col_bg = Color("#41c741")
		tab_coupons.col_bg = Color("#3e5ba9")
		tab_users.queue_redraw()
		tab_coupons.queue_redraw()
	)
	tab_coupons.pressed.connect(func(): 
		for k in tab_contents:
			tab_contents[k].visible = (k == "coupons")
		tab_users.col_bg = Color("#3e5ba9")
		tab_coupons.col_bg = Color("#41c741")
		tab_users.queue_redraw()
		tab_coupons.queue_redraw()
	)
	
	show_popup(admin_panel_popup)

func show_code_success_popup(gold_amount: int):
	var success_popup = Control.new()
	success_popup.set_anchors_preset(Control.PRESET_FULL_RECT)
	success_popup.z_index = 35
	add_child(success_popup)
	
	var overlay_bg = ColorRect.new()
	overlay_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay_bg.color = Color(0, 0, 0, 0.7)
	success_popup.add_child(overlay_bg)
	
	var panel_w = min(450 * ui_scale, screen_size.x * 0.85)
	var panel_h = min(200 * ui_scale, screen_size.y * 0.4)
	var panel = create_popup_panel(Vector2(panel_w, panel_h))
	panel.position = (screen_size - Vector2(panel_w, panel_h)) / 2.0
	success_popup.add_child(panel)
	
	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	panel.add_child(margin)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 15)
	margin.add_child(vbox)
	
	var title = Label.new()

	# CODE_SUCCESS string'i %d formatında, bu yüzden gold_amount'u direkt kullanıyoruz
	title.text = Global.get_text("CODE_SUCCESS") % gold_amount
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.add_theme_font_size_override("font_size", int(20 * ui_scale))
	if custom_font: title.add_theme_font_override("font", custom_font)
	title.add_theme_color_override("font_color", Color("#41c741") if gold_amount > 0 else Color("#ff4444"))
	vbox.add_child(title)
	
	var btn_ok = create_css_button(Global.get_text("OK"), Color("#3e5ba9"), Color("#4e6bb9"), Color("#2e4b99"), 2, int(16 * ui_scale))
	btn_ok.custom_minimum_size.y = 45 * ui_scale
	btn_ok.pressed.connect(func():
		success_popup.queue_free()
	)
	vbox.add_child(btn_ok)

func _refresh_leaderboard_after_delay():
	# Kısa bir gecikme ekle ki popup tamamen yüklenmiş olsun
	await get_tree().create_timer(0.1).timeout
	if is_instance_valid(leaderboard_popup) and leaderboard_popup.visible:
		setup_leaderboard_popup()
		show_popup(leaderboard_popup)

func _on_admin_data_loaded():
	# Admin verileri yüklendiğinde leaderboard'u güncelle
	# NOT: Burada admin verisini güncelleme yapmıyoruz çünkü döngü oluşturuyor
	# Kullanıcı ismi kontrolü sadece oyun başlangıcında yapılıyor (main.gd'de)
	
	# Leaderboard popup açıksa yeniden oluştur (ama güvenli bir şekilde)
	if leaderboard_popup and is_instance_valid(leaderboard_popup) and leaderboard_popup.visible:
		# Kısa bir gecikme ekle ki popup tamamen yüklenmiş olsun (async olarak)
		_refresh_leaderboard_after_delay()

func _on_admin_save_success(status_label: Label, btn_save: Control):
	status_label.text = "Saved successfully!"
	status_label.add_theme_color_override("font_color", Color("#41c741"))
	status_label.visible = true
	btn_save.disabled = false
	# 2 saniye sonra gizle
	await get_tree().create_timer(2.0).timeout
	if is_instance_valid(status_label):
		status_label.visible = false

func _on_admin_save_error(error_message: String, status_label: Label, btn_save: Control):
	status_label.text = "Error: " + error_message + " [Click to Retry]"
	status_label.add_theme_color_override("font_color", Color("#ff4444"))
	status_label.visible = true
	btn_save.disabled = false
	# Retry için mouse click kontrolü
	status_label.mouse_filter = Control.MOUSE_FILTER_STOP
	status_label.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# Retry için save butonuna tıkla
			if btn_save.has_method("emit_signal"):
				btn_save.pressed.emit()
	)

# Ayar simgesi butonu (Pixel Art Gear Icon)
class SettingsGearButton extends Button:
	func _ready():
		focus_mode = Control.FOCUS_NONE
		flat = true
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	func _draw():
		var s = size
		var c = s / 2.0
		var px = 1.5  # Pixel boyutu (küçültüldü)
		
		# Arka plan
		var bg_color = Color("#4a4a6a")
		var border_color = Color("#3a3a5a")
		
		# Panel çiz
		draw_rect(Rect2(0, 0, s.x, s.y), border_color)
		draw_rect(Rect2(2, 2, s.x - 4, s.y - 6), bg_color)
		
		# Gear icon çiz (dişli çark) - küçük versiyon
		var gear_col = Color.WHITE
		
		# Merkez daire
		draw_rect(Rect2(c.x - 3*px, c.y - 3*px, 6*px, 6*px), gear_col)
		
		# Dişler (4 yönde - sadeleştirildi)
		# Üst
		draw_rect(Rect2(c.x - 1.5*px, c.y - 5*px, 3*px, 2*px), gear_col)
		# Alt
		draw_rect(Rect2(c.x - 1.5*px, c.y + 3*px, 3*px, 2*px), gear_col)
		# Sol
		draw_rect(Rect2(c.x - 5*px, c.y - 1.5*px, 2*px, 3*px), gear_col)
		# Sağ
		draw_rect(Rect2(c.x + 3*px, c.y - 1.5*px, 2*px, 3*px), gear_col)
		
		# Merkez delik
		draw_rect(Rect2(c.x - 1*px, c.y - 1*px, 2*px, 2*px), border_color)
