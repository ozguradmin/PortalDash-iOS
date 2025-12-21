extends Node2D

# ==============================================================================
# MICRO ROGUE: "TOMB RUNNER" - GAMEPLAY SCRIPT
# (Orijinal Görsel Stil + Yeni Özellikler)
# ==============================================================================

const TILE_SIZE = 32

# --- 1. GENEL RENK PALETİ ---
const C_EXIT = Color("#63c74d")
const C_BG = Color("#000000") # Tam Siyah Boşluk
const C_FOG = Color("#1a1a2e") # Sis Rengi (Koyu Lacivert)
const C_WALL_BASE = Color("#5d275d")
const C_WALL_TOP = Color("#b13e53")
const C_WALL_SHADOW = Color("#391f39")
const C_FLOOR_1 = Color("#181425")
const C_FLOOR_2 = Color("#262b44")
const C_OVERLAY = Color(0, 0, 0, 0.85)

# --- 2. KARAKTER ---
const C_HERO_MAIN = Color(0.0, 0.7, 1.0)
const C_HERO_DARK = Color(0.0, 0.4, 0.7)
const C_MASK_BG = Color(0.1, 0.1, 0.3)
const C_EYES = Color(1, 1, 1)
const C_OUTLINE = Color(0, 0, 0)
const C_HP_BAR_BG = Color(0.1, 0.1, 0.1, 0.8)
const C_HP_BAR_FILL = Color(0.2, 0.9, 0.4)

# --- 3. ALTIN & DÜŞMAN & TUZAK ---
const C_GOLD_OUTLINE = Color(0.8, 0.4, 0.0)
const C_GOLD_MAIN = Color(1.0, 0.8, 0.0)
const C_GOLD_SHINE = Color(1.0, 1.0, 0.8)
const C_ENEMY_MAIN = Color(0.9, 0.1, 0.3)
const C_ENEMY_DARK = Color(0.6, 0.0, 0.2)
const C_ENEMY_SPIKE = Color(0.2, 0.0, 0.1)
const C_EYE_SCLERA = Color(1, 1, 1)
const C_EYE_PUPIL = Color(0.1, 0.0, 0.0)
# Yeni Renkler
const C_ENEMY_SLEEPY = Color("#8a6f30")
const C_ENEMY_TURRET = Color("#9d4edd")  # Mor renk (normal kırmızı düşmanlardan farklı)
const C_TRAP_ACTIVE = Color("#b30000")
const C_TRAP_INACTIVE = Color("#333333")

# BUFFS
const C_BUFF_MAGNET = Color("#ff00ff")
const C_BUFF_SHOCKWAVE = Color("#ff8800")
const C_BUFF_SHIELD = Color("#00ffff")
const C_BUFF_FREEZE = Color("#0088ff")

# --- 4. UI VE PORTAL ---
const C_UI_PANEL_BG = Color(0.08, 0.08, 0.15, 0.95)
const C_UI_BORDER = Color(0.3, 0.3, 0.5)
const C_BTN_NORMAL = Color(0.2, 0.2, 0.3)
const C_BTN_TEXT = Color(0.9, 0.9, 1.0)
const C_PORTAL_CORE = Color(0.1, 0.0, 0.2)
const C_PORTAL_RING = Color(0.4, 0.0, 0.8)
const C_PORTAL_LIGHT= Color(0.8, 0.4, 1.0)

const FONT_PATH = "res://PressStart2P.ttf"
# LevelData ve MAX_CAMPAIGN_LEVEL kaldırıldı

# CoinIcon sınıfı
class CoinIcon extends Control:
	const C_GOLD_OUTLINE = Color(0.8, 0.4, 0.0)
	const C_GOLD_MAIN = Color(1.0, 0.8, 0.0)
	const C_GOLD_SHINE = Color(1.0, 1.0, 0.8)
	
	var is_static = false

	func _init():
		custom_minimum_size = Vector2(24, 24)
 
	func _process(_delta):
		queue_redraw()
 
	func _draw():
		var time = Time.get_ticks_msec() / 1000.0
		var s = size.x
		var center = size / 2
 
		var spin_width_factor = 1.0
		if not is_static:
			spin_width_factor = abs(cos(time * 3.0))
 
		var max_w = s * 0.6
		var h = s * 0.7
		var current_w = max(2.0, max_w * spin_width_factor)
 
		var coin_pos = center - Vector2(current_w/2, h/2)
 
		draw_rect(Rect2(coin_pos, Vector2(current_w, h)), C_GOLD_OUTLINE)
		if current_w > 4:
			draw_rect(Rect2(coin_pos.x + 2, coin_pos.y + 2, current_w - 4, h - 4), C_GOLD_MAIN)
			if current_w > 8:
				draw_rect(Rect2(coin_pos.x + 4, coin_pos.y + 4, 3, 6), C_GOLD_SHINE)

# --- DEĞİŞKENLER ---
var grid = {}
var visibility_map = {}
var visited_map = {}
var floor_details = {}
var enemies = [] # {pos, type, state}
var golds = []
var traps = []   # {pos, active}
var buffs = [] # {pos, type}
var floating_texts = []
var particles = []
var fog_particles = [] # Sis Parçacıkları
var trap_toggle_index := -1

var level_complete_center : Control
var level_complete_panel : PanelContainer
var level_complete_btn_next : Button
var level_complete_btn_menu : Button
var level_complete_lbl : Label
var pending_next_level : int = 1
var last_cleared_level : int = 1
var level_complete_has_next : bool = true

var map_width = 15
var map_height = 15
var vision_range = 9

var current_level = 1
var score: float = 0.0
var displayed_score: float = 0.0
var moves_in_level = 0
var game_active = false
var screen_shake = 0.0
var coins_collected_this_run = 0

var player = {"pos": Vector2i(0, 0), "hp": 3, "max_hp": 3}
var exit_pos = Vector2i.ZERO
var vis_player_pos = Vector2.ZERO
var vis_player_scale = Vector2(1,1)

# GHOST TRAIL VARS
var ghosts = []
var ghost_timer = 0.0
var time_elapsed = 0.0
var ui_scale = 1.0

# YENİ: Combo & Kontrol
var combo_multiplier = 1.0
var combo_streak = 0
var combo_timer = 0.0 # Saniye cinsinden
var combo_max_time = 5.0
var magnet_timer = 0.0
var magnet_max_time = 15.0

# Power-Ups
var active_buffs = {
	"magnet_turns": 0,
	"has_shield": false,
	"freeze_timer": 0
}

var drag_start_pos = Vector2.ZERO
var is_dragging = false
const MIN_DRAG = 40

var player_facing = 1.0

# --- HAREKET KONTROL DEĞİŞKENLERİ ---
var last_move_time = 0.0
var move_interval = 0.15 # Basılı tutarken hareket hızı (saniye)
var is_touch_active = false
var touch_current_pos = Vector2.ZERO
var initial_drag_processed = false # İlk swipe hareketi yapıldı mı?

# --- NODE REFERANSLARI ---
var camera : Camera2D
var ui_layer : CanvasLayer
var top_bar : Control
var lbl_stats : Label
var btn_pause : Button
var pause_center : CenterContainer
var pause_panel : PanelContainer
var gameover_center : CenterContainer
var gameover_panel : PanelContainer
var lbl_final_score : Label
var lbl_coins : Label
var lbl_lore : Label # YENİ
var lbl_combo : Label # YENİ
var lbl_tutorial : Label # YENİ (Persistent Tutorial Text)
var combo_bar : ProgressBar # YENİ
var magnet_bar : ProgressBar
var custom_font : Font = null

# TUTORIAL STATE
var is_tutorial_active = true
var tutorial_step = 1

func _ready():
	randomize()
	if ResourceLoader.exists(FONT_PATH):
		custom_font = load(FONT_PATH)
	else:
		print("UYARI: 'PressStart2P.ttf' bulunamadı! Varsayılan font kullanılacak.")
	
	# ASYA DİLLERİ İÇİN FONT FALLBACK
	if Global.language in ["ja", "zh", "ko", "hi"]:
		if ResourceLoader.exists("res://unicode.ttf"):
			custom_font = load("res://unicode.ttf")
		else:
			print("UYARI: Asya dilleri için 'unicode.ttf' bulunamadı!")
	
	setup_camera()
	setup_ui()
	start_game_initial()

	# Versiyon kontrolü oyun içindeyken sonuçlanırsa ana menüye dön
	if VersionManager and not VersionManager.version_checked.is_connected(_on_version_checked_game):
		VersionManager.version_checked.connect(_on_version_checked_game)

func _on_version_checked_game(is_blocking):
	if is_blocking:
		# Oyuncu oyundayken bile engelle: ana menüye dön
		get_tree().change_scene_to_file("res://mainmenu.tscn")

func setup_camera():
	camera = Camera2D.new()
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 12.0
	add_child(camera)

func create_styled_panel():
	var panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = C_UI_PANEL_BG
	var bw = int(4 * ui_scale)
	style.border_width_left = bw
	style.border_width_top = bw
	style.border_width_right = bw
	style.border_width_bottom = bw
	style.border_color = C_UI_BORDER
	style.set_corner_radius_all(0)
	style.shadow_color = Color(0,0,0,0.5)
	style.shadow_size = int(10 * ui_scale)
	panel.add_theme_stylebox_override("panel", style)
	return panel

func setup_ui():
	ui_layer = CanvasLayer.new()
	add_child(ui_layer)
	
	ui_scale = clamp(get_viewport_rect().size.x / 500.0, 0.6, 1.4)
	
	# 1. ÜST BAR
	top_bar = Control.new()
	top_bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_bar.custom_minimum_size = Vector2(0, 140 * ui_scale)
	ui_layer.add_child(top_bar)
	
	# 1.1 SKOR
	lbl_stats = Label.new()
	lbl_stats.position = Vector2(40, 30) * ui_scale
	lbl_stats.text = "0"
	lbl_stats.add_theme_font_size_override("font_size", int(32 * ui_scale))
	
	# FONT FIX: Skor sayacı her zaman Pixel Art
	if ResourceLoader.exists(FONT_PATH):
		var pixel_font = load(FONT_PATH)
		lbl_stats.add_theme_font_override("font", pixel_font)
		
	lbl_stats.add_theme_color_override("font_color", Color.WHITE)
	lbl_stats.add_theme_color_override("font_outline_color", Color.BLACK)
	lbl_stats.add_theme_constant_override("outline_size", int(8 * ui_scale))
	lbl_stats.name = "lbl_stats" # Reference için isim
	top_bar.add_child(lbl_stats)

	# 1.2 COIN
	var coin_hud_group = Control.new()
	coin_hud_group.position = Vector2(40, 70) * ui_scale
	coin_hud_group.name = "coin_hud_group" # Reference için isim
	top_bar.add_child(coin_hud_group)
	
	# YENİ: Combo Yazısı (Coin'in Altında)
	lbl_combo = Label.new()
	lbl_combo.position = Vector2(40, 100) * ui_scale
	lbl_combo.text = ""
	lbl_combo.add_theme_font_size_override("font_size", int(16 * ui_scale))
	if custom_font: lbl_combo.add_theme_font_override("font", custom_font)
	lbl_combo.add_theme_color_override("font_color", Color.YELLOW)
	top_bar.add_child(lbl_combo)
	
	# TUTORIAL LABEL (Top Center - Persistent with Background)
	var tut_panel = PanelContainer.new()
	tut_panel.set_anchors_preset(Control.PRESET_TOP_WIDE)
	tut_panel.position = Vector2(0, 110 * ui_scale)
	tut_panel.custom_minimum_size = Vector2(0, 70 * ui_scale)
	
	var style_tut = StyleBoxFlat.new()
	style_tut.bg_color = Color(0, 0, 0, 0.7)
	style_tut.border_width_bottom = 2
	style_tut.border_color = Color("#4caf50")
	tut_panel.add_theme_stylebox_override("panel", style_tut)
	top_bar.add_child(tut_panel)

	lbl_tutorial = Label.new()
	lbl_tutorial.text = ""
	lbl_tutorial.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_tutorial.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl_tutorial.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lbl_tutorial.custom_minimum_size = Vector2(300 * ui_scale, 0) # Width constraint for wrapping
	
	lbl_tutorial.add_theme_font_size_override("font_size", int(18 * ui_scale))
	if custom_font: lbl_tutorial.add_theme_font_override("font", custom_font)
	lbl_tutorial.add_theme_color_override("font_color", Color.WHITE)
	lbl_tutorial.add_theme_constant_override("line_spacing", 4)
	
	var margin_tut = MarginContainer.new()
	margin_tut.add_theme_constant_override("margin_left", 20)
	margin_tut.add_theme_constant_override("margin_right", 20)
	margin_tut.add_theme_constant_override("margin_top", 10)
	margin_tut.add_theme_constant_override("margin_bottom", 10)
	margin_tut.add_child(lbl_tutorial)
	tut_panel.add_child(margin_tut)
	
	# Reference for visibility toggling
	lbl_tutorial.set_meta("panel_ref", tut_panel)
	tut_panel.visible = false

	# Combo Bar

	# Combo Bar
	combo_bar = ProgressBar.new()
	combo_bar.show_percentage = false
	combo_bar.position = Vector2(40, 120) * ui_scale
	combo_bar.custom_minimum_size = Vector2(100, 8) * ui_scale
	combo_bar.size = Vector2(100, 8) * ui_scale
	var style_bg = StyleBoxFlat.new(); style_bg.bg_color = Color(0.2,0.2,0.2)
	var style_fg = StyleBoxFlat.new(); style_fg.bg_color = Color.YELLOW
	combo_bar.add_theme_stylebox_override("background", style_bg)
	combo_bar.add_theme_stylebox_override("fill", style_fg)
	combo_bar.visible = false
	top_bar.add_child(combo_bar)

	magnet_bar = ProgressBar.new()
	magnet_bar.show_percentage = false
	magnet_bar.position = Vector2(40, 115) * ui_scale
	magnet_bar.custom_minimum_size = Vector2(100, 6) * ui_scale
	magnet_bar.size = Vector2(100, 6) * ui_scale
	var style_bg_m = StyleBoxFlat.new(); style_bg_m.bg_color = Color(0.2,0.2,0.2)
	var style_fg_m = StyleBoxFlat.new(); style_fg_m.bg_color = Color.RED
	magnet_bar.add_theme_stylebox_override("background", style_bg_m)
	magnet_bar.add_theme_stylebox_override("fill", style_fg_m)
	magnet_bar.visible = false
	top_bar.add_child(magnet_bar)
	
	var hud_coin_icon = CoinIcon.new()
	hud_coin_icon.custom_minimum_size = Vector2(24, 24) * ui_scale
	hud_coin_icon.is_static = true
	hud_coin_icon.position.y = -5 * ui_scale
	coin_hud_group.add_child(hud_coin_icon)
	
	lbl_coins = Label.new()
	lbl_coins.position = Vector2(30, -2) * ui_scale
	lbl_coins.text = "0"
	lbl_coins.add_theme_font_size_override("font_size", int(24 * ui_scale))
	
	# FONT FIX: Coin sayacı her zaman Pixel Art
	if ResourceLoader.exists(FONT_PATH):
		var pixel_font = load(FONT_PATH)
		lbl_coins.add_theme_font_override("font", pixel_font)
		
	lbl_coins.add_theme_color_override("font_color", Color("#ffd54f"))
	lbl_coins.add_theme_color_override("font_outline_color", Color.BLACK)
	lbl_coins.add_theme_constant_override("outline_size", int(6 * ui_scale))
	coin_hud_group.add_child(lbl_coins)
	
	# 1.3 PAUSE
	btn_pause = create_icon_button("pause")
	btn_pause.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
	btn_pause.position = Vector2(-90, -35) * ui_scale
	btn_pause.custom_minimum_size = Vector2(70, 70) * ui_scale
	btn_pause.pressed.connect(toggle_pause)
	top_bar.add_child(btn_pause)
	
	# 2. PAUSE MENU
	pause_center = CenterContainer.new()
	pause_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	pause_center.visible = false
	ui_layer.add_child(pause_center)
	
	pause_panel = create_styled_panel()
	pause_center.add_child(pause_panel)
	
	var p_margin = MarginContainer.new()
	p_margin.add_theme_constant_override("margin_top", int(30 * ui_scale))
	p_margin.add_theme_constant_override("margin_bottom", int(30 * ui_scale))
	p_margin.add_theme_constant_override("margin_left", int(50 * ui_scale))
	p_margin.add_theme_constant_override("margin_right", int(50 * ui_scale))
	pause_panel.add_child(p_margin)
	
	var vbox_p = VBoxContainer.new()
	vbox_p.add_theme_constant_override("separation", int(20 * ui_scale))
	p_margin.add_child(vbox_p)
	
	var title_p = Label.new()
	title_p.text = Global.get_text("PAUSED")
	title_p.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_p.add_theme_font_size_override("font_size", int(32 * ui_scale))
	if custom_font: title_p.add_theme_font_override("font", custom_font)
	title_p.add_theme_color_override("font_color", Color.WHITE)
	vbox_p.add_child(title_p)
	
	var btn_res = create_rich_button(Global.get_text("RESUME"), int(28 * ui_scale), C_BTN_NORMAL)
	btn_res.pressed.connect(toggle_pause)
	vbox_p.add_child(btn_res)
	
	var btn_rst = create_rich_button(Global.get_text("RESTART"), int(28 * ui_scale), C_BTN_NORMAL)
	btn_rst.pressed.connect(start_game_initial)
	vbox_p.add_child(btn_rst)
	
	var btn_main = create_rich_button(Global.get_text("EXIT_MENU"), int(28 * ui_scale), C_ENEMY_DARK)
	btn_main.pressed.connect(quit_to_menu)
	vbox_p.add_child(btn_main)
	
	# Ses ayarları bölümü
	var sound_sep = HSeparator.new()
	vbox_p.add_child(sound_sep)
	
	var sound_hbox = HBoxContainer.new()
	sound_hbox.add_theme_constant_override("separation", int(15 * ui_scale))
	sound_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox_p.add_child(sound_hbox)
	
	# Müzik toggle butonu (Pixel Art Icon)
	var btn_music_p = SoundIconButton.new()
	btn_music_p.icon_type = "music"
	btn_music_p.is_enabled = Global.music_enabled
	btn_music_p.custom_minimum_size = Vector2(40, 40) * ui_scale
	btn_music_p.pressed.connect(func():
		if SoundManager:
			SoundManager.set_music_enabled(not SoundManager.is_music_enabled())
			btn_music_p.is_enabled = SoundManager.is_music_enabled()
			btn_music_p.queue_redraw()
	)
	sound_hbox.add_child(btn_music_p)
	
	# Ses efektleri toggle butonu (Pixel Art Icon)
	var btn_sfx_p = SoundIconButton.new()
	btn_sfx_p.icon_type = "sfx"
	btn_sfx_p.is_enabled = Global.sfx_enabled
	btn_sfx_p.custom_minimum_size = Vector2(40, 40) * ui_scale
	btn_sfx_p.pressed.connect(func():
		if SoundManager:
			SoundManager.set_sfx_enabled(not SoundManager.is_sfx_enabled())
			btn_sfx_p.is_enabled = SoundManager.is_sfx_enabled()
			btn_sfx_p.queue_redraw()
	)
	sound_hbox.add_child(btn_sfx_p)
	
	# 3. GAME OVER
	gameover_center = CenterContainer.new()
	gameover_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	gameover_center.visible = false
	ui_layer.add_child(gameover_center)
	
	gameover_panel = create_styled_panel()
	var go_style = StyleBoxFlat.new()
	go_style.bg_color = Color(0.07, 0.05, 0.12, 0.95)
	go_style.border_width_left = 4
	go_style.border_width_right = 4
	go_style.border_width_top = 4
	go_style.border_width_bottom = 10
	go_style.border_color = Color("#ff6f61")
	go_style.shadow_color = Color(0,0,0,0.55)
	go_style.shadow_size = int(14 * ui_scale)
	gameover_panel.add_theme_stylebox_override("panel", go_style)
	gameover_center.add_child(gameover_panel)
	
	var go_margin = MarginContainer.new()
	var m_val = int(28 * ui_scale)
	go_margin.add_theme_constant_override("margin_top", m_val)
	go_margin.add_theme_constant_override("margin_bottom", m_val)
	go_margin.add_theme_constant_override("margin_left", int(22 * ui_scale))
	go_margin.add_theme_constant_override("margin_right", int(22 * ui_scale))
	gameover_panel.add_child(go_margin)
	
	var vbox_go = VBoxContainer.new()
	vbox_go.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox_go.add_theme_constant_override("separation", int(22 * ui_scale))
	go_margin.add_child(vbox_go)
	
	var title_go = Label.new()
	title_go.text = Global.get_text("GAMEOVER")
	title_go.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_go.add_theme_font_size_override("font_size", int(38 * ui_scale))
	if custom_font: title_go.add_theme_font_override("font", custom_font)
	title_go.add_theme_color_override("font_color", C_ENEMY_MAIN)
	title_go.add_theme_color_override("font_outline_color", Color.BLACK)
	title_go.add_theme_constant_override("outline_size", int(6 * ui_scale))
	vbox_go.add_child(title_go)
	
	lbl_final_score = Label.new()
	lbl_final_score.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_final_score.text = Global.get_text("SCORE") + ": 0"
	lbl_final_score.add_theme_font_size_override("font_size", int(30 * ui_scale))
	if custom_font: lbl_final_score.add_theme_font_override("font", custom_font)
	lbl_final_score.add_theme_color_override("font_color", Color.WHITE)
	vbox_go.add_child(lbl_final_score)
	
	var c_panel = PanelContainer.new()
	var c_style = StyleBoxFlat.new()
	c_style.bg_color = Color(0.12, 0.08, 0.16, 0.65)
	c_style.set_corner_radius_all(6)
	c_style.border_color = Color("#ff6f61")
	c_style.border_width_bottom = int(3 * ui_scale)
	c_panel.add_theme_stylebox_override("panel", c_style)
	vbox_go.add_child(c_panel)
	
	var c_margin = MarginContainer.new()
	c_margin.add_theme_constant_override("margin_top", int(14 * ui_scale))
	c_margin.add_theme_constant_override("margin_bottom", int(14 * ui_scale))
	c_panel.add_child(c_margin)
	
	var h_coin_box = HBoxContainer.new()
	h_coin_box.alignment = BoxContainer.ALIGNMENT_CENTER
	h_coin_box.add_theme_constant_override("separation", int(14 * ui_scale))
	h_coin_box.name = "h_coin_box"
	c_margin.add_child(h_coin_box)
	
	var ic1 = CoinIcon.new()
	ic1.custom_minimum_size = Vector2(28, 28) * ui_scale
	ic1.is_static = true
	h_coin_box.add_child(ic1)
	
	var l2 = Label.new()
	l2.name = "lbl_collected"
	l2.text = "+0"
	l2.add_theme_font_size_override("font_size", int(26 * ui_scale))
	if custom_font: l2.add_theme_font_override("font", custom_font)
	l2.add_theme_color_override("font_color", Color("#ffd54f"))
	l2.add_theme_color_override("font_shadow_color", Color.BLACK)
	l2.add_theme_constant_override("shadow_offset_y", 1)
	l2.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	h_coin_box.add_child(l2)
	
	var btn_box = HBoxContainer.new()
	btn_box.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_box.add_theme_constant_override("separation", int(18 * ui_scale))
	vbox_go.add_child(btn_box)
	
	var btn_try = create_rich_button(Global.get_text("TRY_AGAIN"), int(24 * ui_scale), C_BTN_NORMAL)
	btn_try.custom_minimum_size = Vector2(184, 66) * ui_scale
	btn_try.pressed.connect(restart_handler)
	btn_box.add_child(btn_try)
	
	var btn_menu_go = create_rich_button(Global.get_text("MAIN_MENU"), int(22 * ui_scale), C_ENEMY_DARK)
	btn_menu_go.custom_minimum_size = Vector2(184, 66) * ui_scale
	btn_menu_go.pressed.connect(quit_to_menu)
	btn_box.add_child(btn_menu_go)
	
	# YENİ: Lore / Tip (butonların altında)
	lbl_lore = Label.new()
	lbl_lore.text = "..."
	lbl_lore.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_lore.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lbl_lore.custom_minimum_size = Vector2(260, 0) * ui_scale
	lbl_lore.add_theme_constant_override("line_spacing", int(2 * ui_scale))
	lbl_lore.add_theme_font_size_override("font_size", int(11 * ui_scale))
	lbl_lore.add_theme_color_override("font_color", Color("#aaaaaa"))
	if custom_font: lbl_lore.add_theme_font_override("font", custom_font)
	vbox_go.add_child(lbl_lore)

func restart_handler():
	if is_tutorial_active:
		# Tutorial'da öldüyse aynı tutorial'ı tekrar başlat
		# Canı yenile (User request)
		player["hp"] = player["max_hp"] if player.has("max_hp") else Global.talent_max_hp
		
		start_level()
		# UI'ları gizle
		gameover_center.visible = false
		top_bar.visible = true
	else:
		start_game_initial()

	# 4. LEVEL COMPLETE POPUP
	level_complete_center = Control.new()
	level_complete_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	level_complete_center.visible = false
	ui_layer.add_child(level_complete_center)
	
	var lc_overlay = ColorRect.new()
	lc_overlay.color = Color(0,0,0,0.45)
	lc_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	level_complete_center.add_child(lc_overlay)
	
	var lc_holder = CenterContainer.new()
	lc_holder.set_anchors_preset(Control.PRESET_FULL_RECT)
	level_complete_center.add_child(lc_holder)
	
	level_complete_panel = create_styled_panel()
	var lc_style = StyleBoxFlat.new()
	lc_style.bg_color = Color(0.08, 0.1, 0.18, 0.92)
	lc_style.border_width_left = 4
	lc_style.border_width_right = 4
	lc_style.border_width_top = 4
	lc_style.border_width_bottom = 8
	lc_style.border_color = Color("#63c74d")
	lc_style.shadow_color = Color(0,0,0,0.55)
	lc_style.shadow_size = int(12 * ui_scale)
	level_complete_panel.add_theme_stylebox_override("panel", lc_style)
	lc_holder.add_child(level_complete_panel)
	
	var lc_margin = MarginContainer.new()
	lc_margin.add_theme_constant_override("margin_top", int(24 * ui_scale))
	lc_margin.add_theme_constant_override("margin_bottom", int(24 * ui_scale))
	lc_margin.add_theme_constant_override("margin_left", int(28 * ui_scale))
	lc_margin.add_theme_constant_override("margin_right", int(28 * ui_scale))
	level_complete_panel.add_child(lc_margin)
	
	var lc_vbox = VBoxContainer.new()
	lc_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	lc_vbox.add_theme_constant_override("separation", int(18 * ui_scale))
	lc_margin.add_child(lc_vbox)
	
	level_complete_lbl = Label.new()
	level_complete_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_complete_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	level_complete_lbl.custom_minimum_size = Vector2(280, 0) * ui_scale
	level_complete_lbl.add_theme_font_size_override("font_size", int(24 * ui_scale))
	if custom_font: level_complete_lbl.add_theme_font_override("font", custom_font)
	level_complete_lbl.add_theme_color_override("font_color", Color.WHITE)
	level_complete_lbl.add_theme_color_override("font_outline_color", Color.BLACK)
	level_complete_lbl.add_theme_constant_override("outline_size", int(6 * ui_scale))
	lc_vbox.add_child(level_complete_lbl)
	
	var lc_btn_hbox = HBoxContainer.new()
	lc_btn_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	lc_btn_hbox.add_theme_constant_override("separation", int(14 * ui_scale))
	lc_vbox.add_child(lc_btn_hbox)
	
	level_complete_btn_next = create_rich_button("Sonraki Bölüm", int(22 * ui_scale), Color("#2e7d32"))
	level_complete_btn_next.custom_minimum_size = Vector2(190, 64) * ui_scale
	level_complete_btn_next.pressed.connect(_on_level_complete_next)
	lc_btn_hbox.add_child(level_complete_btn_next)
	
	level_complete_btn_menu = create_rich_button("Ana Menü", int(22 * ui_scale), Color("#3b3b4f"))
	level_complete_btn_menu.custom_minimum_size = Vector2(190, 64) * ui_scale
	level_complete_btn_menu.pressed.connect(_on_level_complete_menu)
	lc_btn_hbox.add_child(level_complete_btn_menu)

func update_hud_coins():
	if lbl_coins:
		lbl_coins.text = str(coins_collected_this_run)

func create_icon_button(type):
	var btn = PixelIconButton.new()
	btn.icon_type = type
	var s = Vector2(70, 70) * ui_scale
	btn.custom_minimum_size = s
	btn.size = s
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	return btn

func create_rich_button(text, font_size, base_color):
	var btn = Button.new()
	btn.text = text
	
	# Dinamik Font Boyutu Ayarı (Taşma Koruması)
	btn.clip_text = true
	btn.text_overrun_behavior = TextServer.OVERRUN_NO_TRIMMING
	btn.custom_minimum_size = Vector2(184, 66) * ui_scale
	var effective_fs = font_size
	var font_ref = custom_font if custom_font else btn.get_theme_font("font")
	if font_ref:
		var padding = 20.0 * ui_scale
		var max_w = max(0.0, btn.custom_minimum_size.x - padding)
		while effective_fs > 10:
			var sz = font_ref.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, effective_fs)
			if sz.x <= max_w:
				break
			effective_fs -= 1
	
	btn.add_theme_font_size_override("font_size", effective_fs)
	if custom_font: btn.add_theme_font_override("font", custom_font)
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn.focus_mode = Control.FOCUS_NONE
	
	var style = StyleBoxFlat.new()
	style.bg_color = base_color
	style.set_corner_radius_all(0)
	var bw = int(2 * ui_scale)
	style.border_width_bottom = int(6 * ui_scale)
	style.border_width_left = bw
	style.border_width_right = bw
	style.border_width_top = bw
	style.border_color = base_color.darkened(0.4)
	
	var style_h = style.duplicate()
	style_h.bg_color = base_color.lightened(0.15)
	style_h.border_color = Color.WHITE
	
	var style_p = style.duplicate()
	style_p.bg_color = base_color.darkened(0.2)
	style_p.border_width_bottom = int(2 * ui_scale)
	style_p.border_width_top = int(6 * ui_scale)
	
	btn.add_theme_color_override("font_color", C_BTN_TEXT)
	btn.add_theme_color_override("font_hover_color", Color.WHITE)
	btn.add_theme_color_override("font_pressed_color", Color.GRAY)
	
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_stylebox_override("hover", style_h)
	btn.add_theme_stylebox_override("pressed", style_p)
	
	return btn

func show_level_complete_popup(cleared_level: int, has_next: bool, next_level: int):
	last_cleared_level = cleared_level
	pending_next_level = next_level
	level_complete_has_next = has_next
	
	if has_next:
		level_complete_lbl.text = "Bölüm %d tamamlandı!" % cleared_level
		level_complete_btn_next.text = "Sonraki Bölüm"
	else:
		# Oyun Bitti / Tüm Bölümler Tamamlandı
		level_complete_lbl.text = "TÜM BÖLÜMLER TAMAMLANDI!"
		level_complete_btn_next.text = Global.get_text("EXIT_MENU")
		
	level_complete_center.visible = true
	game_active = false

func apply_next_level_heal(target_level: int):
	if player["hp"] >= player["max_hp"]:
		return
	if target_level <= 5:
		player["hp"] += 1
	elif target_level % 2 == 0:
		player["hp"] += 1
	if player["hp"] > player["max_hp"]:
		player["hp"] = player["max_hp"]
	spawn_text(player["pos"], Global.get_text("PLUS_HP"), Color.GREEN)

func _on_level_complete_next():
	level_complete_center.visible = false
	if level_complete_has_next:
		apply_next_level_heal(pending_next_level)
		
		# TUTORIAL LOGIC
		if is_tutorial_active:
			tutorial_step += 1
			if tutorial_step > 3:
				is_tutorial_active = false
				current_level = 1
				# Tutorial bitti mesajı
				spawn_text(player["pos"], "TUTORIAL COMPLETE!", Color.GREEN)
		else:
			current_level = pending_next_level
			
		start_level()
	else:
		quit_to_menu()

func _on_level_complete_menu():
	level_complete_center.visible = false
	quit_to_menu()

# --- OYUN MANTIĞI ---

func quit_to_menu():
	get_tree().change_scene_to_file("res://mainmenu.tscn")

func start_game_initial():
	# Oyun müziğini başlat
	if SoundManager: SoundManager.play_game_music()
	
	score = 0.0
	displayed_score = 0.0
	coins_collected_this_run = 0
	update_hud_coins()
	current_level = 1  # Her zaman 1'den başla (Sonsuz Mod)
	
	# Yetenekler
	player["hp"] = Global.talent_max_hp
	player["max_hp"] = Global.talent_max_hp
	
	# NOT: Admin verisi kontrolü kaldırıldı
	# Admin skoru sadece admin panelinden kasıtlı değiştirildiğinde uygulanır
	# Her oyun başlangıcında kontrol etmek kullanıcının kendi rekorunu siliyordu
	
	# Combo Reset
	combo_multiplier = 1.0
	combo_streak = 0
	combo_timer = 0.0
	lbl_combo.text = ""
	active_buffs = {"magnet_turns": 0, "has_shield": false, "freeze_timer": 0}
	magnet_timer = 0.0
	
	pause_center.visible = false
	gameover_center.visible = false
	if level_complete_center:
		level_complete_center.visible = false
	top_bar.visible = true
	
	vis_player_pos = Vector2(0,0)
	particles.clear()
	ghosts.clear()
	
	particles.clear()
	ghosts.clear()
	
	# INITIALIZE TUTORIAL STATE
	is_tutorial_active = false
	current_level = 1
	tutorial_step = 1
	
	if Global.force_tutorial_start:
		is_tutorial_active = true
		Global.force_tutorial_start = false # Reset flag
	elif not Global.tutorial_shown:
		is_tutorial_active = true
	
	start_level()

func start_level():
	game_active = true
	player_facing = 1.0
	moves_in_level = 0
	
	# TUTORIAL LEVEL YUKLEME
	if is_tutorial_active:
		load_tutorial_level(tutorial_step)
		
		# Görüş mapini güncelle
		update_visibility()
		# Tutorial'da her yer açık olsun
		for pos in grid:
			visited_map[pos] = true
			visibility_map[pos] = true
		
		vis_player_pos = Vector2(player["pos"]) * TILE_SIZE
		camera.position = vis_player_pos
		camera.reset_smoothing()
		
		# UI GİZLEME (Coin, Score, Combo)
		if top_bar.has_node("lbl_stats"): top_bar.get_node("lbl_stats").visible = false
		if top_bar.has_node("coin_hud_group"): top_bar.get_node("coin_hud_group").visible = false
		if lbl_combo: lbl_combo.visible = false
		
		game_active = true
		return
	
	# NORMAL GAME UI GÖSTERME
	if top_bar.has_node("lbl_stats"): top_bar.get_node("lbl_stats").visible = true
	if top_bar.has_node("coin_hud_group"): top_bar.get_node("coin_hud_group").visible = true
	if lbl_combo: lbl_combo.visible = true

	# Sadece sonsuz mod mantığı (prosedürel)
	# load_campaign_level kaldırıldı
	# Kademeli harita boyutu artışı
	if current_level == 1:
		map_width = 12
		map_height = 12
	elif current_level == 2:
		map_width = 14
		map_height = 14
	elif current_level == 3:
		map_width = 16
		map_height = 16
	elif current_level == 4:
		map_width = 18
		map_height = 18
	elif current_level == 5:
		map_width = 20
		map_height = 20
	elif current_level == 6:
		map_width = 22
		map_height = 22
	elif current_level == 7:
		map_width = 24
		map_height = 24
	elif current_level == 8:
		map_width = 26
		map_height = 26
	elif current_level == 9:
		map_width = 28
		map_height = 28
	elif current_level == 10:
		map_width = 30
		map_height = 30
	else:
		# Level 11+ için normal sistem devam ediyor
		map_width = min(35, 14 + (current_level * 2))
		map_height = min(35, 14 + (current_level * 2))
	
	# Görüş Menzili Progression (15. bölümden başlıyor, 9 ile başlıyor)
	if current_level < 15:
		vision_range = 9  # İlk 15 bölümde görüş kontrolü yok, ama değer 9
	else:
		# Level 15'ten itibaren kademeli azalma (15. bölümde 9, sonra azalıyor)
		var adjusted_level = current_level - 15  # 15. bölümü 0 olarak say
		vision_range = max(4, 9 - int(adjusted_level / 5.0))
	
	var valid_map = false
	while not valid_map:
		generate_dungeon()
		if check_path_exists(player["pos"], exit_pos):
			valid_map = true
	
	spawn_entities()
	apply_trap_rules_for_level(current_level)
	
	update_visibility()
	
	# İlk 15 bölüm: Tüm haritayı açık yap
	if current_level < 15:
		for pos in grid:
			visited_map[pos] = true
			visibility_map[pos] = true
		# Duvarları da ekle (komşu zemin varsa)
		for pos in grid:
			for dir_vec in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
				var wall_pos = pos + dir_vec
				if not grid.has(wall_pos):
					visited_map[wall_pos] = true
					visibility_map[wall_pos] = true
	
	vis_player_pos = Vector2(player["pos"]) * TILE_SIZE
	camera.position = vis_player_pos
	camera.reset_smoothing()

func load_tutorial_level(step: int):
	grid.clear()
	visibility_map.clear()
	visited_map.clear()
	golds.clear()
	enemies.clear()
	traps.clear()
	buffs.clear()
	floor_details.clear()
	
	var hint_text = ""
	
	if step == 1:
		# --- TUTORIAL 1: MOVEMENT ---
		map_width = 5
		map_height = 8
		
		# Zemini oluştur
		for x in range(1, 4):
			for y in range(1, 7):
				grid[Vector2i(x,y)] = 1
		
		player["pos"] = Vector2i(2, 6)
		exit_pos = Vector2i(2, 1)
		
		hint_text = Global.get_text("TUTORIAL_MOVE")
		
	elif step == 2:
		# --- TUTORIAL 2: RED ENEMY (Redesigned) ---
		map_width = 9
		map_height = 11
		
		# Geniş bir oda oluştur (7x9 kullanılabilir alan)
		for x in range(1, 8):
			for y in range(1, 10):
				grid[Vector2i(x,y)] = 1
		
		# Ortada manevra için iki sütun (Duvar)
		grid.erase(Vector2i(2, 5))
		grid.erase(Vector2i(6, 5))
		
		# Oyuncu aşağıda
		player["pos"] = Vector2i(4, 8)
		# Çıkış yukarıda
		exit_pos = Vector2i(4, 2)
		
		# Kırmızı Düşman (Chaser) - Tam ortada, oyuncuyu bekliyor
		# Konumun duvarda OLMADIĞINDAN eminiz (4,5 silinmedi)
		enemies.append({"pos": Vector2i(4, 5), "type": "chaser", "state": 0})
		
		hint_text = Global.get_text("TUTORIAL_RED_ENEMY")
		
	elif step == 3:
		# --- TUTORIAL 3: SLEEPY ENEMY (Big Map) ---
		map_width = 12
		map_height = 12
		
		# Büyük harita
		for x in range(2, 10):
			for y in range(2, 10):
				grid[Vector2i(x,y)] = 1
		
		# Engeller (Labirent hissi)
		grid.erase(Vector2i(5,5))
		grid.erase(Vector2i(6,5))
		grid.erase(Vector2i(5,6))
		
		player["pos"] = Vector2i(4, 8)
		exit_pos = Vector2i(7, 3) # Uzak bir yer
		
		# Uyuyan düşman (Tek bir düşman)
		enemies.append({"pos": Vector2i(6, 6), "type": "sleepy", "state": 0})
		
		hint_text = Global.get_text("TUTORIAL_FIND") # "Portal bul"
	
	# Persistent Label Update
	if lbl_tutorial:
		lbl_tutorial.text = hint_text
		if lbl_tutorial.has_meta("panel_ref"):
			lbl_tutorial.get_meta("panel_ref").visible = true



func toggle_pause():
	if gameover_center.visible: return
	
	if game_active:
		game_active = false
		pause_center.visible = true
	else:
		game_active = true
		pause_center.visible = false
	
	queue_redraw()

func _unhandled_input(event):
	if not game_active: return
	
	# KLAVYE (Tek basım - ui_accept gibi özel durumlar için)
	# Hareket artık process_continuous_movement içinde işleniyor ama
	# 'ui_accept' (bekleme) hala tek basım olabilir.
	if event.is_action_pressed("ui_accept"):
		end_turn()
		return
	
	# MOBİL DOKUNMATİK TAKİBİ
	if event is InputEventScreenTouch:
		if event.pressed:
			is_dragging = true # Eski kod uyumluluğu için (gerekirse)
			is_touch_active = true
			drag_start_pos = event.position
			touch_current_pos = event.position
			initial_drag_processed = false
		else:
			is_dragging = false
			is_touch_active = false
	
	if event is InputEventScreenDrag and is_touch_active:
		touch_current_pos = event.position
		
		# İlk hareketin anında algılanması (beklemeden)
		# Kullanıcı swipe yapar yapmaz ilk adımı atması için:
		if not initial_drag_processed:
			var diff = touch_current_pos - drag_start_pos
			if diff.length() > MIN_DRAG:
				# Yönü hesapla
				var dir = Vector2i.ZERO
				if abs(diff.x) > abs(diff.y):
					dir.x = 1 if diff.x > 0 else -1
				else:
					dir.y = 1 if diff.y > 0 else -1
				
				# Hareketi yap
				if dir != Vector2i.ZERO:
					player_turn(dir)
					last_move_time = move_interval + 0.1 # İlk hareketten sonraki bekleme biraz daha uzun olsun
					initial_drag_processed = true

func player_turn(dir):
	var target = player["pos"] + dir
	
	if dir.x != 0:
		player_facing = float(dir.x)
		vis_player_scale = Vector2(1.3, 0.7)
	if dir.y != 0: vis_player_scale = Vector2(0.7, 1.3)
	
	if not grid.has(target):
		screen_shake = 3.0
		vis_player_scale = Vector2(1.2, 1.2)
		return
	
	if target == exit_pos:
		level_complete()
		return
	
	if golds.has(target):
		collect_gold(target)
		player["pos"] = target
		moves_in_level += 1
		Global.total_steps += 1
		Global.add_daily_steps(1)
		if SoundManager: SoundManager.play_step()
		end_turn()
		return

	# BUFF TOPLAMA
	var buff_idx = get_buff_at(target)
	if buff_idx != -1:
		collect_buff(buffs[buff_idx])
		buffs.remove_at(buff_idx)
		player["pos"] = target
		moves_in_level += 1
		Global.total_steps += 1
		Global.add_daily_steps(1)
		if SoundManager: SoundManager.play_step()
		end_turn()
		return

	# DÜŞMANA ÇARPMA (İTME MEKANİZMASI)
	var enemy = get_enemy_at(target)
	if enemy:
		var push_target = target + dir  # Düşmanın itileceği pozisyon
		
		# Eğer arkasında duvar yoksa ve geçerli bir zemin varsa, düşmanı it ve o konuma geç
		if grid.has(push_target) and not get_enemy_at(push_target):
			enemy["pos"] = push_target
			enemy["pushed_this_turn"] = true  # Bu turda itildi flag'i
			if SoundManager: SoundManager.play_push()
			take_damage(1)
			screen_shake = 10.0
			spawn_text(target, Global.get_text("PUSHED"), Color.YELLOW)
			# Oyuncu da o konuma geç
			player["pos"] = target
			moves_in_level += 1
			Global.total_steps += 1
			Global.add_daily_steps(1)
			end_turn()
			return
		else:
			# Arkasında duvar varsa veya başka bir düşman varsa, sadece hasar al
			take_damage(1)
			screen_shake = 10.0
		return
	
	# Normal hareket - adım sesi
	if SoundManager: SoundManager.play_step()
	player["pos"] = target
	moves_in_level += 1
	Global.total_steps += 1
	Global.add_daily_steps(1)
	end_turn()

func end_turn():
	update_traps_after_turn()

	# Buff Süreleri
	# Turn based magnet removed in favor of real-time

	if active_buffs["freeze_timer"] > 0:
		active_buffs["freeze_timer"] -= 1
	
	update_visibility()
	process_enemies()
	queue_redraw()

func process_enemies():
	if active_buffs["freeze_timer"] > 0:
		return # Enemies frozen

	for e in enemies:
		# Bu turda itilen düşmanların flag'ini temizle ve bu turda hasar vermesin
		if e.get("pushed_this_turn", false):
			e["pushed_this_turn"] = false
			continue  # Bu turda hareket etmesin ve hasar vermesin
		
		# TARET
		if e.get("type") == "turret":
			process_turret(e)
			continue
		
		# UYKUCU
		if e.get("type") == "sleepy":
			if Vector2(e["pos"]).distance_to(Vector2(player["pos"])) > 3:
				continue # Uyanmaz
		
		# STANDART TAKİP
		var dist = Vector2(e["pos"]).distance_to(Vector2(player["pos"]))
		if dist > 10: continue
 
		if dist <= 1.1:
			take_damage(1)
		else:
			var move = Vector2i.ZERO
			var diff = player["pos"] - e["pos"]
			if abs(diff.x) > abs(diff.y):
				move.x = sign(diff.x)
				if is_blocked(e["pos"] + move): move = Vector2i(0, sign(diff.y))
			else:
				move.y = sign(diff.y)
				if is_blocked(e["pos"] + move): move = Vector2i(sign(diff.x), 0)
 
			var next_pos = e["pos"] + move
			# ALTINA BASABİLSİN, TUZAĞA BASABİLSİN
			if not is_blocked(next_pos) and next_pos != exit_pos:
				e["pos"] = next_pos

func process_turret(e):
	# Önce görüş kontrolü yap
	if not has_line_of_sight(e["pos"], player["pos"]):
		e["state"] = 0  # Görüş yoksa state'i sıfırla
		return  # Görüş yoksa hiçbir şey yapma
	
	# State sistemi: 0 -> 1 -> 2 -> 3 -> 4 (ateş) -> 0
	# Bu şekilde oyuncuya kaçma şansı veriyoruz
	e["state"] = (e.get("state", 0) + 1) % 5
	
	if e["state"] == 1: # İlk uyarı
		spawn_text(e["pos"], Global.get_text("AIM"), Color.ORANGE)
	elif e["state"] == 2: # İkinci uyarı
		spawn_text(e["pos"], Global.get_text("AIM"), Color.ORANGE)
	elif e["state"] == 3: # Son uyarı
		spawn_text(e["pos"], Global.get_text("AIM"), Color.RED)
	elif e["state"] == 4: # Ateş
		spawn_text(e["pos"], Global.get_text("FIRE"), Color.RED)
		# Laser sesi
		if SoundManager: SoundManager.play_laser()
		# %90 şansla ateş et (biraz şans verelim)
		if randf() < 0.9:
			take_damage(1)
			screen_shake = 10.0
		e["state"] = 0  # Ateş ettikten sonra sıfırla

func has_line_of_sight(p1, p2):
	var diff = p2 - p1
	var distance = Vector2(diff).length()
	
	# Görüş mesafesi sınırı: maksimum 5 tile
	if distance > 5.0:
		return false
	
	var steps = max(abs(diff.x), abs(diff.y))
	var dir = Vector2(diff) / steps
	var check = Vector2(p1)
	for i in range(steps):
		check += dir
		var ip = Vector2i(round(check.x), round(check.y))
		if not grid.has(ip): return false
		if ip == p2: return true
	return true

func is_blocked(pos):
	if not grid.has(pos): return true
	if pos == player["pos"]: return true
	if get_enemy_at(pos): return true
	return false

func apply_trap_rules_for_level(_level_idx: int):
	if traps.is_empty():
		return
	
	trap_toggle_index = -1
	for t in traps:
		t["active"] = false

func update_traps_after_turn():
	if traps.is_empty():
		return
	
	for t in traps:
		t["active"] = not t.get("active", false)
	
	for t in traps:
		if t["active"] and t["pos"] == player["pos"]:
			take_damage(1)

# load_campaign_level removed

# --- HARİTA OLUŞTURMA (ESKİ MANTIK) ---
func generate_dungeon():
	grid.clear()
	visibility_map.clear()
	visited_map.clear()
	golds.clear()
	floor_details.clear()
	
	var start_pos = Vector2i(0, 0)
	player["pos"] = start_pos
	grid[start_pos] = 1
	
	var floor_count = 1
	var target_floors = int(map_width * map_height * 0.5)
	var walkers = [start_pos]
	
	while floor_count < target_floors:
		var new_walkers = []
		for walker in walkers:
			var dir = Vector2i.ZERO
			if randf() < 0.5: dir.x = [1, -1].pick_random()
			else: dir.y = [1, -1].pick_random()
 
			var next = walker + dir
			if abs(next.x) < map_width/2 and abs(next.y) < map_height/2:
				if not grid.has(next):
					grid[next] = 1
					if randf() < 0.3: floor_details[next] = randi() % 3
					floor_count += 1
 
				if randf() < 0.2:
					for rx in range(-1, 2):
						for ry in range(-1, 2):
							var room_pos = next + Vector2i(rx, ry)
							if not grid.has(room_pos) and abs(room_pos.x) < map_width/2 and abs(room_pos.y) < map_height/2:
								grid[room_pos] = 1
								floor_count += 1
				new_walkers.append(next)
				if randf() < 0.05: new_walkers.append(walker)
		walkers = new_walkers
		if walkers.is_empty(): walkers.append(start_pos)
	
	var obstacle_candidates = []
	for pos in grid.keys():
		if pos == start_pos: continue
		var neighbors = 0
		for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			if grid.has(pos + dir): neighbors += 1
		if neighbors == 4: obstacle_candidates.append(pos)
	
	obstacle_candidates.shuffle()
	var obstacle_count = int(obstacle_candidates.size() * 0.15)
	for i in range(obstacle_count):
		grid.erase(obstacle_candidates[i])
	
	var max_dist = 0.0
	for pos in grid.keys():
		var d = Vector2(pos).distance_to(Vector2(start_pos))
		if d > max_dist:
			max_dist = d
			exit_pos = pos

func spawn_entities():
	enemies.clear()
	traps.clear()
	buffs.clear()
	var available = grid.keys()
	available.sort_custom(func(a, b): return a.distance_to(player["pos"]) < b.distance_to(player["pos"]))
	
	var enemy_candidates = available.slice(int(available.size() * 0.4))
	enemy_candidates.shuffle()
	
	# İlk bölümlerde kademeli düşman sayısı
	var enemy_count = 0
	if current_level == 1:
		enemy_count = 0  # Level 1'de düşman yok
	elif current_level >= 2 and current_level <= 4:
		enemy_count = 1  # Level 2-4: 1 düşman
	elif current_level >= 5 and current_level <= 7:
		enemy_count = 2  # Level 5-7: 2 düşman
	elif current_level >= 8 and current_level <= 10:
		enemy_count = 3  # Level 8-10: 3 düşman
	else:
		enemy_count = max(1, int(current_level / 1.5))  # Sonrasında normal sistem
	
	var turret_count = 0  # Bir bölümde en fazla 1 nişancı
	
	for i in range(enemy_count):
		if enemy_candidates.is_empty(): break
		var pos = enemy_candidates.pop_back()
		if pos != exit_pos: 
			# Portalın yanına nişancı spawn etme
			var type = "chaser"
			
			# Nişancı: Level 10+ ve bir bölümde en fazla 1 tane, portalın yanına değil
			var is_near_portal = (pos.distance_to(exit_pos) <= 2)  # Portalın 2 tile yakınında mı?
			if current_level >= 10 and turret_count == 0 and randf() < 0.2 and not is_near_portal:
				type = "turret"
				turret_count += 1
			elif current_level >= 5 and randf() < 0.4:  # Sleepy Level 5'ten başlıyor
				type = "sleepy"
			
			enemies.append({"pos": pos, "type": type, "state": 0})

	# Buffs (Level 2'den başlıyor, Level 5'ten itibaren %35 şans)
	if current_level >= 2:
		var buff_chance = 0.0
		if current_level < 5:
			# Level 2-4: Çok düşük şans (%5-8)
			buff_chance = 0.05 + ((current_level - 2) * 0.01) + (Global.talent_luck * 0.03)
		else:
			# Level 5+: %35 şans
			buff_chance = 0.35 + (Global.talent_luck * 0.03) + (current_level * 0.007)
		
		if randf() < buff_chance:
			if not enemy_candidates.is_empty():
				var pos = enemy_candidates.pop_back()
				if pos != exit_pos:
					var b_type = ["magnet", "shockwave", "shield", "freeze", "heart"].pick_random()
					buffs.append({"pos": pos, "type": b_type})

	# Tuzaklar (Level 10'dan başlıyor, daha geç)
	if current_level >= 10:
		var trap_count = 3 + int((current_level - 10) / 3.0)  # Level 10'dan itibaren sayım
		for i in range(trap_count):
			if enemy_candidates.is_empty(): break
			var pos = enemy_candidates.pop_back()
			if pos != exit_pos and get_enemy_at(pos) == null:
				traps.append({"pos": pos, "active": false})

	# Harita boyutuna göre altın sayısı (küçük haritalarda daha az)
	var map_size = map_width * map_height
	var gold_count = 0
	if map_size <= 144:  # Level 1 (12x12)
		gold_count = 1 + randi() % 2  # 1-2 altın
	elif map_size <= 196:  # Level 2 (14x14)
		gold_count = 2 + randi() % 2  # 2-3 altın
	elif map_size <= 256:  # Level 3 (16x16)
		gold_count = 2 + randi() % 2  # 2-3 altın
	elif map_size <= 324:  # Level 4 (18x18)
		gold_count = 2 + randi() % 3  # 2-4 altın
	elif map_size <= 400:  # Level 5 (20x20)
		gold_count = 3 + randi() % 2  # 3-4 altın
	else:
		gold_count = 3 + randi() % 4  # 3-6 altın (normal)
	
	for i in range(gold_count):
		if enemy_candidates.is_empty(): break
		var pos = enemy_candidates.pop_back()
		var safe = (pos != exit_pos and get_enemy_at(pos) == null)
		for t in traps:
			if t["pos"] == pos: safe = false
		if safe:
			golds.append(pos)

func add_score(amount):
	score += float(amount)

func collect_gold(pos):
	if golds.has(pos):
		golds.erase(pos)
	
	# Coin sesi
	if SoundManager: SoundManager.play_coin()
	
	# Combo Logic
	combo_streak += 1
	
	# Timer Logic
	combo_max_time = 5.0
	if combo_streak >= 5:
		combo_max_time = 3.0
	combo_timer = combo_max_time
	
	# Multiplier Logic
	# Starts at 2x after 2nd gold. 1st gold is 1x.
	var mult = 1
	if combo_streak >= 2:
		mult = combo_streak
	
	combo_multiplier = float(mult)
	
	var gold_score = 250.0 * combo_multiplier * Global.talent_score_value
	add_score(gold_score)
	
	var coins_gain = 1 * mult
	coins_collected_this_run += coins_gain
	Global.add_coins(coins_gain) 
	update_hud_coins()
	
	spawn_text(pos, "+%d" % int(gold_score), Color.WHITE)
	screen_shake = 5.0
	spawn_particle(Vector2(pos)*TILE_SIZE + Vector2(16,16), C_GOLD_MAIN, 10)

func level_complete():
	# Portal geçiş sesi
	if SoundManager: SoundManager.play_portal()
	
	# TUTORIAL PROGRESSION
	if is_tutorial_active:
		tutorial_step += 1
		if tutorial_step > 3:
			is_tutorial_active = false
			current_level = 1
			# Tutorial bitişinde skor sıfırlama
			score = 0.0
			displayed_score = 0.0
			lbl_stats.text = "0"
			
			if lbl_tutorial and lbl_tutorial.has_meta("panel_ref"):
				lbl_tutorial.get_meta("panel_ref").visible = false
			
			# SAVE TUTORIAL COMPLETION
			if not Global.tutorial_shown:
				Global.tutorial_shown = true
				Global.save_game()
				
			spawn_text(player["pos"], "TUTORIAL COMPLETE!", Color.GREEN)
		
		start_level()
		return

	# NORMAL GAME PROGRESSION
	var total_gain = 500 + (current_level * 100)
	add_score(total_gain)
	
	current_level += 1
	# İlk 5 bölümde her bölümde HP yenileme, sonrasında her 2 bölümde bir
	if current_level <= 5:
		if player["hp"] < player["max_hp"]:
			player["hp"] += 1
			spawn_text(player["pos"], Global.get_text("PLUS_HP"), Color.GREEN)
	elif current_level % 2 == 0 and player["hp"] < player["max_hp"]:
		player["hp"] += 1
		spawn_text(player["pos"], Global.get_text("PLUS_HP"), Color.GREEN)
	
	spawn_text(player["pos"], Global.get_text("STAGE_CLEAR"), Color.WHITE)
	start_level()

func take_damage(amount):
	if active_buffs["has_shield"]:
		active_buffs["has_shield"] = false
		spawn_text(player["pos"], Global.get_text("BLOCKED"), Color.CYAN)
		spawn_particle(vis_player_pos + Vector2(16,16), Color.CYAN, 10)
		return

	# Hasar sesi
	if SoundManager: SoundManager.play_hurt()
	
	player["hp"] -= amount
	screen_shake = 15.0
	spawn_particle(vis_player_pos + Vector2(16,16), Color.RED, 20)
	if player["hp"] <= 0:
		game_over()

func game_over():
	# Ölüm sesi ve müziği
	if SoundManager:
		SoundManager.play_death()
		SoundManager.play_gameover_music()
	
	game_active = false
	top_bar.visible = false
	gameover_center.visible = true
	displayed_score = score
	lbl_final_score.text = Global.get_text("SCORE") + ": " + str(int(score))
	
	# Lore
	var tips = ["LORE_TIP_1", "LORE_TIP_2", "LORE_TIP_3", "LORE_TIP_4", "LORE_TIP_5", "LORE_TIP_6", "LORE_TIP_7", "LORE_TIP_8"]
	if lbl_lore: lbl_lore.text = Global.get_text(tips.pick_random())
	
	Global.add_coins(coins_collected_this_run)
	Global.update_high_score(int(score))
	Global.total_deaths += 1
	Global.total_games_played += 1
	Global.total_time_played += time_elapsed
	Global.save_game()
	
	var l_col = gameover_panel.find_child("lbl_collected", true, false)
	var l_tot = gameover_panel.find_child("lbl_total", true, false)
	if l_col: l_col.text = str(coins_collected_this_run) + " "
	if l_tot: l_tot.text = str(Global.coins)
	
	queue_redraw()

func _process(delta):
	time_elapsed += delta

	# Magnet Logic
	if magnet_timer > 0:
		magnet_timer -= delta
		magnet_bar.visible = true
		magnet_bar.max_value = magnet_max_time
		magnet_bar.value = magnet_timer
		# Position Magnet Bar
		if combo_bar.visible:
			magnet_bar.position.y = combo_bar.position.y + 15 * ui_scale
		else:
			magnet_bar.position.y = combo_bar.position.y
		
		# Attract Gold
		var p_pos = Vector2(player["pos"])
		for i in range(golds.size() - 1, -1, -1):
			var g_pos = Vector2(golds[i])
			if p_pos.distance_to(g_pos) <= 4.0:
				collect_gold(golds[i])
	else:
		magnet_bar.visible = false
	
	# Combo Timer
	if combo_timer > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			combo_streak = 0
			combo_multiplier = 1.0
			lbl_combo.text = ""
			combo_bar.visible = false
			spawn_text(player["pos"], Global.get_text("COMBO_LOST"), Color.GRAY)
	
	# UI Update
	if combo_streak >= 2:
		lbl_combo.text = "x%d" % int(combo_multiplier)
		lbl_combo.add_theme_color_override("font_color", Color.YELLOW if combo_multiplier < 5 else Color.ORANGE)
		
		combo_bar.visible = true
		combo_bar.max_value = combo_max_time
		combo_bar.value = combo_timer
	else:
		lbl_combo.text = ""
		combo_bar.visible = false
	
	if displayed_score < score:
		displayed_score = lerp(float(displayed_score), float(score), 10.0 * delta)
		if abs(score - displayed_score) < 1.0: displayed_score = score
	
	lbl_stats.text = "%s" % str(int(displayed_score))

	var target_px = Vector2(player["pos"]) * TILE_SIZE
	vis_player_pos = vis_player_pos.lerp(target_px, delta * 15.0)
	vis_player_scale = vis_player_scale.lerp(Vector2(1, 1), delta * 10.0)
	
	camera.position = vis_player_pos + Vector2(16, 16)
	
	var vp_size = get_viewport_rect().size
	var zoom_target = 1.0
	if vp_size.y > vp_size.x:
		zoom_target = vp_size.x / (11.0 * TILE_SIZE)
	else:
		zoom_target = vp_size.y / (16.0 * TILE_SIZE)
	
	camera.zoom = camera.zoom.lerp(Vector2(zoom_target, zoom_target), 5 * delta)
	
	if screen_shake > 0:
		screen_shake = lerp(screen_shake, 0.0, 15 * delta)
		camera.offset = Vector2(randf_range(-1,1), randf_range(-1,1)) * screen_shake
	
	update_particles_process(delta)
	update_ghosts(delta)
	update_floating_texts(delta)
	
	# Fog Particles Logic (Sadece 15. bölüm ve sonrası)
	if current_level >= 15 and randf() < 0.2: # Arada bir yeni sis parçacığı üret
		fog_particles.append({
			"pos": Vector2(randf(), randf()), # Normalized position within a tile
			"tile": Vector2i.ZERO, # Hangi tile'da olduğu çizimde belirlenecek
			"life": randf_range(2.0, 4.0),
			"size": randf_range(2.0, 5.0),
			"vel": Vector2(randf_range(-5, 5), randf_range(-5, 5))
		})
	
	for i in range(fog_particles.size() - 1, -1, -1):
		var p = fog_particles[i]
		p["life"] -= delta
		p["pos"] += p["vel"] * delta * 0.05
		if p["life"] <= 0:
			fog_particles.remove_at(i)
	
	process_continuous_movement(delta)
	queue_redraw()

func process_continuous_movement(delta):
	if not game_active: return
	if pause_center.visible or gameover_center.visible: return
	
	# Hareket zamanlayıcısı
	if last_move_time > 0:
		last_move_time -= delta
		if last_move_time > 0: return

	var dir = Vector2i.ZERO
	
	# 1. KLAVYE (Basılı Tutma)
	if Input.is_action_pressed("ui_up"): dir.y = -1
	elif Input.is_action_pressed("ui_down"): dir.y = 1
	elif Input.is_action_pressed("ui_left"): dir.x = -1
	elif Input.is_action_pressed("ui_right"): dir.x = 1
	
	# 2. MOBİL (Sürükle ve Tut)
	if is_touch_active:
		var diff = touch_current_pos - drag_start_pos
		# Eğer parmak yeterince sürüklendiyse
		if diff.length() > MIN_DRAG:
			if abs(diff.x) > abs(diff.y):
				dir.x = 1 if diff.x > 0 else -1
			else:
				dir.y = 1 if diff.y > 0 else -1
	
	# Hareket varsa uygula ve zamanlayıcıyı sıfırla
	if dir != Vector2i.ZERO:
		player_turn(dir)
		last_move_time = move_interval

func _draw():
	# ZEMİN ÇİZİMİ (ORİJİNAL)
	# Sadece ziyaret edilen yerleri çiz
	
	# Arka Planı her zaman çiz (Kamera etrafına)
	draw_rect(Rect2(camera.position - get_viewport_rect().size, get_viewport_rect().size * 2), C_BG)
	
	for pos in visited_map:
		if grid.has(pos):
			var px = Vector2(pos) * TILE_SIZE
			var rect = Rect2(px, Vector2(TILE_SIZE, TILE_SIZE))
			
			# İlk 15 bölüm: Tüm ziyaret edilmiş yerler görünür
			if current_level < 15:
				draw_rect(rect, C_FLOOR_1)
				if floor_details.has(pos):
					var det = floor_details[pos]
					if det == 0:
						draw_rect(Rect2(px + Vector2(8,8), Vector2(4,4)), C_FLOOR_2)
					elif det == 1:
						draw_rect(Rect2(px + Vector2(20,10), Vector2(3,3)), C_FLOOR_2)
						draw_rect(Rect2(px + Vector2(24,12), Vector2(2,2)), C_FLOOR_2)
					elif det == 2:
						draw_rect(Rect2(px + Vector2(2,2), Vector2(6,6)), C_FLOOR_2)
			else:
				# 10. bölüm ve sonrası: Görüş alanı kontrolü + Sis
				if visibility_map.has(pos):
					draw_rect(rect, C_FLOOR_1)
					if floor_details.has(pos):
						var det = floor_details[pos]
						if det == 0:
							draw_rect(Rect2(px + Vector2(8,8), Vector2(4,4)), C_FLOOR_2)
						elif det == 1:
							draw_rect(Rect2(px + Vector2(20,10), Vector2(3,3)), C_FLOOR_2)
							draw_rect(Rect2(px + Vector2(24,12), Vector2(2,2)), C_FLOOR_2)
						elif det == 2:
							draw_rect(Rect2(px + Vector2(2,2), Vector2(6,6)), C_FLOOR_2)
				else:
					# Ziyaret edilmiş ama şu an görüş dışı (Sis)
					draw_rect(rect, C_FOG)

	# DUVAR ÇİZİMİ
	if current_level < 15:
		# İlk 15 bölüm: Tüm ziyaret edilmiş duvarlar görünür
		for pos in visited_map:
			if not grid.has(pos):
				var has_neighbor_floor = false
				if grid.has(pos + Vector2i.UP): has_neighbor_floor = true
				elif grid.has(pos + Vector2i.DOWN): has_neighbor_floor = true
				elif grid.has(pos + Vector2i.LEFT): has_neighbor_floor = true
				elif grid.has(pos + Vector2i.RIGHT): has_neighbor_floor = true
				
				if has_neighbor_floor:
					var px = Vector2(pos) * TILE_SIZE
					draw_rect(Rect2(px.x, px.y + TILE_SIZE - 6, TILE_SIZE, 6), C_WALL_SHADOW)
					var wall_rect = Rect2(px.x, px.y + 4, TILE_SIZE, TILE_SIZE - 10)
					draw_rect(wall_rect, C_WALL_BASE)
					draw_rect(Rect2(px.x, px.y + 4, TILE_SIZE, 6), C_WALL_TOP)
					draw_rect(Rect2(px.x + 8, px.y + 16, 6, 4), C_WALL_SHADOW)
					draw_rect(Rect2(px.x + 20, px.y + 24, 6, 4), C_WALL_SHADOW)
	else:
		# 10. bölüm ve sonrası: Görüş alanı kontrolü + Sis
		# 1. Görünen Duvarlar (Normal Renk)
		for pos in visibility_map:
			if not grid.has(pos):
				var has_neighbor_floor = false
				if grid.has(pos + Vector2i.UP): has_neighbor_floor = true
				elif grid.has(pos + Vector2i.DOWN): has_neighbor_floor = true
				elif grid.has(pos + Vector2i.LEFT): has_neighbor_floor = true
				elif grid.has(pos + Vector2i.RIGHT): has_neighbor_floor = true
				
				if has_neighbor_floor:
					var px = Vector2(pos) * TILE_SIZE
					draw_rect(Rect2(px.x, px.y + TILE_SIZE - 6, TILE_SIZE, 6), C_WALL_SHADOW)
					var wall_rect = Rect2(px.x, px.y + 4, TILE_SIZE, TILE_SIZE - 10)
					draw_rect(wall_rect, C_WALL_BASE)
					draw_rect(Rect2(px.x, px.y + 4, TILE_SIZE, 6), C_WALL_TOP)
					draw_rect(Rect2(px.x + 8, px.y + 16, 6, 4), C_WALL_SHADOW)
					draw_rect(Rect2(px.x + 20, px.y + 24, 6, 4), C_WALL_SHADOW)

		# 2. Ziyaret Edilmiş Ama Karanlık Duvarlar (Sisli)
		for pos in visited_map:
			if not grid.has(pos) and not visibility_map.has(pos):
				var has_neighbor_floor = false
				if grid.has(pos + Vector2i.UP): has_neighbor_floor = true
				elif grid.has(pos + Vector2i.DOWN): has_neighbor_floor = true
				elif grid.has(pos + Vector2i.LEFT): has_neighbor_floor = true
				elif grid.has(pos + Vector2i.RIGHT): has_neighbor_floor = true
				
				if has_neighbor_floor:
					var px = Vector2(pos) * TILE_SIZE
					draw_rect(Rect2(px.x, px.y + 4, TILE_SIZE, TILE_SIZE - 10), C_WALL_BASE.darkened(0.7))
					draw_rect(Rect2(px.x, px.y + 4, TILE_SIZE, 6), C_WALL_TOP.darkened(0.7))
					draw_rect(Rect2(px, Vector2(TILE_SIZE, TILE_SIZE)), Color(C_FOG.r, C_FOG.g, C_FOG.b, 0.6))

		# 3. Animasyonlu Sis Parçacıkları (Fog Areas)
		for pos in visited_map:
			if not visibility_map.has(pos):
				var is_floor = grid.has(pos)
				var is_valid_wall = false
				if not is_floor:
					if grid.has(pos + Vector2i.UP) or grid.has(pos + Vector2i.DOWN) or grid.has(pos + Vector2i.LEFT) or grid.has(pos + Vector2i.RIGHT):
						is_valid_wall = true
				
				if is_floor or is_valid_wall:
					var px = Vector2(pos) * TILE_SIZE
					var time_offset = (pos.x * 10 + pos.y * 23 + time_elapsed * 2.0)
					var particle_alpha = (sin(time_offset) + 1.0) * 0.15
					if particle_alpha > 0.05:
						var p_size = 4 + sin(time_offset * 3.0) * 2
						var p_off = Vector2(sin(time_offset)*8, cos(time_offset)*8)
						draw_rect(Rect2(px + Vector2(12,12) + p_off, Vector2(p_size, p_size)), Color(0.6, 0.7, 0.8, particle_alpha))

	# TUZAKLAR
	for t in traps:
		if current_level < 15 or visibility_map.has(t["pos"]):
			var col = C_TRAP_INACTIVE
			if t["active"]: col = C_TRAP_ACTIVE
			var r = Rect2(Vector2(t["pos"])*TILE_SIZE + Vector2(4,4), Vector2(24,24))
			draw_rect(r, col)

	# BUFFS
	for b in buffs:
		if current_level < 15 or visibility_map.has(b["pos"]):
			var center = (Vector2(b["pos"]) * TILE_SIZE) + Vector2(16, 16)
			var pulse = 1.0 + sin(time_elapsed * 5.0) * 0.1
			var sz = 9.0 * pulse
			
			var t = b["type"]
			# Common shadow halo
			draw_circle(center, sz * 1.1, Color(0,0,0,0.25))

			if t == "magnet":
				var px = sz / 14.0
				var c = center
				var red_base = Color("#d32f2f")
				var red_light = Color("#ef5350")
				var metal = Color("#cfd8dc")
				var out = Color("#3e2723")
				var energy = Color("#ffeb3b")
				draw_rect(Rect2(c.x-12*px, c.y-12*px, 8*px, 20*px), out)
				draw_rect(Rect2(c.x+4*px, c.y-12*px, 8*px, 20*px), out)
				draw_rect(Rect2(c.x-8*px, c.y+6*px, 16*px, 6*px), out)
				draw_rect(Rect2(c.x-10*px, c.y-10*px, 4*px, 16*px), red_base)
				draw_rect(Rect2(c.x+6*px, c.y-10*px, 4*px, 16*px), red_base)
				draw_rect(Rect2(c.x-6*px, c.y+6*px, 12*px, 2*px), red_base)
				draw_rect(Rect2(c.x-6*px, c.y+2*px, 12*px, 4*px), red_base)
				draw_rect(Rect2(c.x-9*px, c.y-8*px, 2*px, 12*px), red_light)
				draw_rect(Rect2(c.x-12*px, c.y-12*px, 8*px, 4*px), out)
				draw_rect(Rect2(c.x+4*px, c.y-12*px, 8*px, 4*px), out)
				draw_rect(Rect2(c.x-10*px, c.y-10*px, 4*px, 2*px), metal)
				draw_rect(Rect2(c.x+6*px, c.y-10*px, 4*px, 2*px), metal)
				draw_rect(Rect2(c.x-2*px, c.y-10*px, 4*px, 2*px), energy)
				draw_rect(Rect2(c.x-4*px, c.y-8*px, 2*px, 2*px), energy)
				draw_rect(Rect2(c.x+2*px, c.y-8*px, 2*px, 2*px), energy)
			elif t == "shield":
				var px = sz / 14.0
				var c = center
				var s_out = Color("#0d47a1")
				var s_border = Color("#90a4ae")
				var s_light = Color("#cfd8dc")
				var s_core = Color("#2196f3")
				var s_shine = Color("#64b5f6")
				draw_rect(Rect2(c.x-12*px, c.y-12*px, 24*px, 16*px), s_out)
				draw_rect(Rect2(c.x-10*px, c.y+4*px, 20*px, 4*px), s_out)
				draw_rect(Rect2(c.x-8*px, c.y+8*px, 16*px, 4*px), s_out)
				draw_rect(Rect2(c.x-4*px, c.y+12*px, 8*px, 4*px), s_out)
				draw_rect(Rect2(c.x-10*px, c.y-10*px, 20*px, 14*px), s_border)
				draw_rect(Rect2(c.x-8*px, c.y+4*px, 16*px, 4*px), s_border)
				draw_rect(Rect2(c.x-6*px, c.y+8*px, 12*px, 4*px), s_border)
				draw_rect(Rect2(c.x-2*px, c.y+12*px, 4*px, 2*px), s_border)
				draw_rect(Rect2(c.x-6*px, c.y-6*px, 12*px, 12*px), s_core)
				draw_rect(Rect2(c.x-4*px, c.y+6*px, 8*px, 4*px), s_core)
				draw_rect(Rect2(c.x-2*px, c.y-4*px, 4*px, 8*px), s_shine)
				draw_rect(Rect2(c.x-4*px, c.y-2*px, 8*px, 4*px), s_shine)
				draw_rect(Rect2(c.x-8*px, c.y-8*px, 2*px, 6*px), s_light)
			elif t == "freeze":
				var px = sz / 14.0
				var c = center
				var ice_dark = Color("#006064")
				var ice_main = Color("#00bcd4")
				var ice_light = Color("#84ffff")
				var ice_white = Color("#e0f7fa")
				draw_rect(Rect2(c.x-2*px, c.y-14*px, 4*px, 28*px), ice_dark)
				draw_rect(Rect2(c.x-14*px, c.y-2*px, 28*px, 4*px), ice_dark)
				for i in range(4, 12, 2):
					draw_rect(Rect2(c.x-i*px, c.y-i*px, 4*px, 4*px), ice_dark)
					draw_rect(Rect2(c.x+i*px-4*px, c.y-i*px, 4*px, 4*px), ice_dark)
					draw_rect(Rect2(c.x-i*px, c.y+i*px-4*px, 4*px, 4*px), ice_dark)
					draw_rect(Rect2(c.x+i*px-4*px, c.y+i*px-4*px, 4*px, 4*px), ice_dark)
				draw_rect(Rect2(c.x-1*px, c.y-12*px, 2*px, 24*px), ice_light)
				draw_rect(Rect2(c.x-12*px, c.y-1*px, 24*px, 2*px), ice_light)
				draw_rect(Rect2(c.x-3*px, c.y-3*px, 6*px, 6*px), ice_main)
				draw_rect(Rect2(c.x-1*px, c.y-1*px, 2*px, 2*px), ice_white)
			elif t == "shockwave":
				var px = sz / 14.0
				var c = center
				var sw_core = Color("#fff176")
				var sw_mid = Color("#ffb74d")
				var sw_out = Color("#e65100")
				var blast = Color("#ffffff")
				var r_out = 14*px
				draw_rect(Rect2(c.x-r_out, c.y-12*px, 4*px, 24*px), sw_out)
				draw_rect(Rect2(c.x+r_out-4*px, c.y-12*px, 4*px, 24*px), sw_out)
				draw_rect(Rect2(c.x-12*px, c.y-r_out, 24*px, 4*px), sw_out)
				draw_rect(Rect2(c.x-12*px, c.y+r_out-4*px, 24*px, 4*px), sw_out)
				var r_mid = 8*px
				draw_rect(Rect2(c.x-r_mid, c.y-r_mid, r_mid*2, r_mid*2), sw_mid)
				draw_rect(Rect2(c.x-r_mid+2*px, c.y-r_mid+2*px, r_mid*2-4*px, r_mid*2-4*px), Color(0,0,0,0))
				var r_core = 4*px
				draw_rect(Rect2(c.x-r_core, c.y-r_core, r_core*2, r_core*2), sw_core)
				draw_rect(Rect2(c.x-2*px, c.y-2*px, 4*px, 4*px), blast)
				draw_rect(Rect2(c.x-12*px, c.y-12*px, 2*px, 2*px), sw_mid)
				draw_rect(Rect2(c.x+10*px, c.y-12*px, 2*px, 2*px), sw_mid)
				draw_rect(Rect2(c.x-12*px, c.y+10*px, 2*px, 2*px), sw_mid)
				draw_rect(Rect2(c.x+10*px, c.y+10*px, 2*px, 2*px), sw_mid)
			elif t == "heart":
				var px = sz / 14.0
				var c = center
				var h_out = Color("#880e4f")
				var h_base = Color("#d50000")
				var h_light = Color("#ff5252")
				var h_shine = Color("#ffcdd2")
				draw_rect(Rect2(c.x-13*px, c.y-10*px, 12*px, 10*px), h_out)
				draw_rect(Rect2(c.x+1*px, c.y-10*px, 12*px, 10*px), h_out)
				draw_rect(Rect2(c.x-13*px, c.y, 26*px, 8*px), h_out)
				draw_rect(Rect2(c.x-9*px, c.y+8*px, 18*px, 4*px), h_out)
				draw_rect(Rect2(c.x-5*px, c.y+12*px, 10*px, 3*px), h_out)
				draw_rect(Rect2(c.x-11*px, c.y-8*px, 10*px, 10*px), h_base)
				draw_rect(Rect2(c.x+1*px, c.y-8*px, 10*px, 10*px), h_base)
				draw_rect(Rect2(c.x-11*px, c.y+2*px, 22*px, 6*px), h_base)
				draw_rect(Rect2(c.x-7*px, c.y+8*px, 14*px, 4*px), h_base)
				draw_rect(Rect2(c.x-3*px, c.y+12*px, 6*px, 2*px), h_base)
				draw_rect(Rect2(c.x-9*px, c.y-6*px, 4*px, 4*px), h_shine)
				draw_rect(Rect2(c.x-5*px, c.y-6*px, 2*px, 2*px), h_shine)
				draw_rect(Rect2(c.x-9*px, c.y-2*px, 2*px, 2*px), h_shine)
				draw_rect(Rect2(c.x+2*px, c.y+6*px, 4*px, 2*px), h_light)

	for g_pos in golds:
		if current_level < 15 or visibility_map.has(g_pos):
			var center = (Vector2(g_pos) * TILE_SIZE) + Vector2(16, 16)
			var bounce = sin(time_elapsed * 4.0) * 4.0
			var spin_width_factor = abs(cos(time_elapsed * 3.0))
			var max_w = 14.0
			var current_w = max(2.0, max_w * spin_width_factor)
			var h = 16.0
			draw_ellipse(center + Vector2(0, 12 - bounce), Vector2(current_w * 0.8, 4), Color(0,0,0,0.3))
			var coin_pos = center + Vector2(-current_w/2, -h/2 - bounce)
			draw_rect(Rect2(coin_pos, Vector2(current_w, h)), C_GOLD_OUTLINE)
			if current_w > 4:
				draw_rect(Rect2(coin_pos.x + 2, coin_pos.y + 2, current_w - 4, h - 4), C_GOLD_MAIN)
				if current_w > 8:
					draw_rect(Rect2(coin_pos.x + 4, coin_pos.y + 4, 2, 4), C_GOLD_SHINE)

	if current_level < 15 or visibility_map.has(exit_pos):
		var center = (Vector2(exit_pos) * TILE_SIZE) + Vector2(16, 16)
		var rotation_base = time_elapsed * 2.0
		for i in range(3):
			var size = 28.0 - (i * 6.0)
			# var angle = rotation_base + (i * 0.5) # Unused
			var color = C_PORTAL_RING
			if i == 2: color = C_PORTAL_LIGHT
			var pulse = 1.0 + sin(time_elapsed * 5.0 + i) * 0.1
			var r_size = Vector2(size, size) * pulse
			var r_pos = center - r_size/2
			draw_rect(Rect2(r_pos, r_size), color, false, 2.0)
		var core_size = 10.0 + sin(time_elapsed * 8.0) * 2.0
		draw_rect(Rect2(center - Vector2(core_size/2, core_size/2), Vector2(core_size, core_size)), C_PORTAL_CORE)
		for k in range(4):
			var dist = 14.0 - ((int(Time.get_ticks_msec() / 100.0) + k * 2) % 14)
			var ang = k * (PI/2) + rotation_base
			var p_pos = center + Vector2(cos(ang), sin(ang)) * dist
			draw_rect(Rect2(p_pos, Vector2(2,2)), Color.WHITE)

	for e in enemies:
		if current_level < 15 or visibility_map.has(e["pos"]):
			var center = (Vector2(e["pos"]) * TILE_SIZE) + Vector2(16, 16)
			var pulse = 1.0 + sin(time_elapsed * 10.0) * 0.05
			var size = 20.0 * pulse
			var half = size / 2
			draw_ellipse(center + Vector2(0, 16), Vector2(14, 6), Color(0,0,0,0.4))
			
			# RENK DEĞİŞİMİ
			var cur_main = C_ENEMY_MAIN
			if e.get("type") == "sleepy": cur_main = C_ENEMY_SLEEPY
			if e.get("type") == "turret": cur_main = C_ENEMY_TURRET
			if active_buffs["freeze_timer"] > 0: cur_main = C_BUFF_FREEZE
			
			for j in range(4):
				var angle = (time_elapsed * -4.0) + (j * (PI / 2.0))
				var dist = 18.0
				var spike_v = Vector2(cos(angle), sin(angle)) * dist
				draw_rect(Rect2(center + spike_v - Vector2(3,3), Vector2(6,6)), C_ENEMY_SPIKE)
			var body_pos = center - Vector2(half, half)
			draw_rect(Rect2(body_pos.x, body_pos.y + 2, size, size), C_ENEMY_DARK)
			draw_rect(Rect2(body_pos, Vector2(size, size - 2)), cur_main)
			var eye_size = 10
			var eye_pos = Vector2(center.x - eye_size/2.0, center.y - eye_size/2.0 - 2)
			draw_rect(Rect2(eye_pos, Vector2(eye_size, eye_size)), C_EYE_SCLERA)
			var player_center = vis_player_pos + Vector2(16,16)
			var dir_p = (player_center - center).normalized()
			var pupil_offset = dir_p * 3.0
			var pupil_size = 4
			var pupil_pos = center + pupil_offset - Vector2(pupil_size/2, pupil_size/2 + 2)
			draw_rect(Rect2(pupil_pos, Vector2(pupil_size, pupil_size)), C_EYE_PUPIL)
			draw_rect(Rect2(eye_pos.x, eye_pos.y - 2, eye_size, 4), C_ENEMY_DARK)
			
			# TARET LAZERİ (Sadece görüş varsa ve nişan alıyorsa çiz)
			if e.get("type") == "turret" and e.get("state") >= 1 and e.get("state") <= 3:
				if has_line_of_sight(e["pos"], player["pos"]):
					# State'e göre çizgi rengi değişir (tehlike arttıkça kırmızılaşır)
					var line_color = Color(1, 0.5, 0, 0.4)  # Turuncu
					if e.get("state") == 3:
						line_color = Color(1, 0, 0, 0.6)  # Kırmızı
					draw_line(center, vis_player_pos + Vector2(16,16), line_color, 2.0)

	for g in ghosts:
		var g_center = g["pos"] + Vector2(16, 16)
		if SkinManager:
			# Flip ghost
			var g_facing = g.get("facing", 1.0)
			draw_set_transform(g_center, 0.0, Vector2(g_facing, 1.0))
			# Draw at 0,0 relative to transform
			SkinManager.draw_skin_preview(self, Vector2.ZERO, g["scale"], g["skin"], time_elapsed, false, g["life"] * 0.4)
			# Reset
			draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 1.0))

	var pc = vis_player_pos + Vector2(16, 16)
	
	if SkinManager:
		# Flip player
		draw_set_transform(pc, 0.0, Vector2(player_facing, 1.0))
		SkinManager.draw_skin_preview(self, Vector2.ZERO, vis_player_scale, Global.current_skin, time_elapsed)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 1.0))
	else:
		draw_rect(Rect2(pc - Vector2(12, 12), Vector2(24, 24)), Color.MAGENTA)
	
	if active_buffs["has_shield"]:
		# Pixel-art kalkan halkası (parçalı, parlama efektli)
		var scale_f = vis_player_scale.x
		var px = 1.4 * scale_f
		var rad = 18.0 * scale_f
		var segs = 18
		var t = time_elapsed * 2.0
		var col_out = Color("#0d47a1")
		var col_mid = Color("#64b5f6")
		var col_glow = Color("#a5d8ff")
		for i in range(segs):
			var ang = t + i * (TAU / segs)
			var pos = pc + Vector2(cos(ang), sin(ang)) * rad
			# dış blok
			var p1x = pos.x - 2*px
			var p1y = pos.y - 2*px
			draw_rect(Rect2(Vector2(p1x, p1y), Vector2(4*px, 4*px)), col_out)
			# iç parlak
			var p2x = pos.x - 1.2*px
			var p2y = pos.y - 1.2*px
			draw_rect(Rect2(Vector2(p2x, p2y), Vector2(2.4*px, 2.4*px)), col_mid)
			# hafif glow noktası
			if i % 4 == 0:
				var p3x = pos.x - 0.8*px
				var p3y = pos.y - 0.8*px
				draw_rect(Rect2(Vector2(p3x, p3y), Vector2(1.6*px, 1.6*px)), col_glow)
	
	var hp_colors = {"bg": C_HP_BAR_BG, "fill": C_HP_BAR_FILL}
	if SkinManager:
		var s_data = SkinManager.get_skin_data(Global.current_skin)
		var cols = s_data.get("colors", {})
		hp_colors["bg"] = cols.get("hp_bg", C_HP_BAR_BG)
		hp_colors["fill"] = cols.get("hp_fill", C_HP_BAR_FILL)
	
	var s = vis_player_scale
	var bounce_p = sin(time_elapsed / 0.2) * 2.0
	var bar_w = 32.0
	var bar_h = 6.0
	var bar_pos = pc + (Vector2(-bar_w/2, -14 - 16 + bounce_p) * s)
	
	var max_hp = player["max_hp"]
	var current_hp = player["hp"]
	
	# Segment hesaplama: Toplam uzunluk sabit, segment sayısı can sayısına göre
	var segment_count = max_hp
	var segment_spacing = 1.0  # Segmentler arası çizgi kalınlığı
	var total_spacing = (segment_count - 1) * segment_spacing  # Toplam çizgi genişliği
	var segment_width = (bar_w - 2 - total_spacing) / segment_count  # Her segment genişliği
	
	# Arka plan çiz
	draw_rect(Rect2(bar_pos, Vector2(bar_w, bar_h)), hp_colors["bg"])
	
	# Her segment için
	for i in range(segment_count):
		var segment_x = bar_pos.x + 1 + (i * (segment_width + segment_spacing))
		var segment_w = segment_width
		
		if i < current_hp:
			# Dolu segment - Yeşil pixel art
			draw_rect(Rect2(segment_x, bar_pos.y + 1, segment_w, bar_h - 2), hp_colors["fill"])
			# Üst highlight (açık yeşil)
			var highlight_color = Color(
				min(1.0, hp_colors["fill"].r + 0.3),
				min(1.0, hp_colors["fill"].g + 0.3),
				min(1.0, hp_colors["fill"].b + 0.3)
			)
			draw_rect(Rect2(segment_x, bar_pos.y + 1, segment_w, 2), highlight_color)
		else:
			# Boş segment - Koyu gri
			var empty_color = Color(
				max(0.0, hp_colors["bg"].r * 0.5),
				max(0.0, hp_colors["bg"].g * 0.5),
				max(0.0, hp_colors["bg"].b * 0.5),
				hp_colors["bg"].a
			)
			draw_rect(Rect2(segment_x, bar_pos.y + 1, segment_w, bar_h - 2), empty_color)
		
		# Segmentler arası çizgi (son segment hariç)
		if i < segment_count - 1:
			var line_x = segment_x + segment_w
			draw_rect(Rect2(line_x, bar_pos.y, segment_spacing, bar_h), hp_colors["bg"])

	for p in particles:
		draw_rect(Rect2(p["pos"], Vector2(p["size"], p["size"])), p["color"])
 
	var font = SystemFont.new()
	if custom_font: font = custom_font
	for ft in floating_texts:
		draw_string(font, ft["pos"], ft["text"], HORIZONTAL_ALIGNMENT_CENTER, -1, 24, ft["color"])

	if not game_active and (pause_center.visible or gameover_center.visible):
		var overlay_rect = Rect2(camera.position - get_viewport_rect().size, get_viewport_rect().size * 2)
		draw_rect(overlay_rect, C_OVERLAY)

func draw_ellipse(center, size, color):
	draw_set_transform(center, 0, Vector2(1.0, size.y/size.x))
	draw_circle(Vector2.ZERO, size.x, color)
	draw_set_transform(Vector2.ZERO, 0, Vector2(1,1))

func update_visibility():
	# İlk 15 bölüm: Tüm haritayı açık tut
	if current_level < 15:
		visibility_map.clear()
		for pos in grid:
			visibility_map[pos] = true
			visited_map[pos] = true
		# Duvarları da ekle (komşu zemin varsa)
		for pos in grid:
			for dir_vec in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
				var wall_pos = pos + dir_vec
				if not grid.has(wall_pos):
					visibility_map[wall_pos] = true
					visited_map[wall_pos] = true
		return
	
	visibility_map.clear()
	for x in range(-vision_range, vision_range + 1):
		for y in range(-vision_range, vision_range + 1):
			var p = player["pos"] + Vector2i(x, y)
			if p.distance_to(player["pos"]) <= vision_range:
				visibility_map[p] = true
				visited_map[p] = true

func check_path_exists(start, end):
	var queue = [start]
	var visited = {start: true}
	while not queue.is_empty():
		var current = queue.pop_front()
		if current == end: return true
		for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			var next = current + dir
			if grid.has(next) and not visited.has(next):
				visited[next] = true
				queue.append(next)
	return false

func get_enemy_at(pos):
	for e in enemies:
		if e["pos"] == pos: return e
	return null

func get_buff_at(pos):
	for i in range(buffs.size()):
		if buffs[i]["pos"] == pos: return i
	return -1

func collect_buff(b):
	# Powerup sesi
	if SoundManager: SoundManager.play_powerup()
	
	var t = b["type"]
	# Buff ismini çevir
	var buff_text_key = "BUFF_" + t.to_upper()
	var buff_text = Global.get_text(buff_text_key)
	spawn_text(player["pos"], buff_text, Color.WHITE)
	if t == "magnet":
		magnet_timer = magnet_max_time
		active_buffs["magnet_turns"] = 0 # Disable turn based magnet
	elif t == "shield":
		active_buffs["has_shield"] = true
	elif t == "freeze":
		# Freeze enemies for 3 tam adım; 4. adımda çözülüp hareket etsin
		active_buffs["freeze_timer"] = 4
	elif t == "shockwave":
		# Push or Crush nearby enemies
		var to_remove = []
		for e in enemies:
			var dist = Vector2(e["pos"]).distance_to(Vector2(player["pos"]))
			if dist <= 3.0:
				var dir = (Vector2(e["pos"]) - Vector2(player["pos"])).normalized()
				var push = Vector2i(round(dir.x * 2), round(dir.y * 2))
				var target = e["pos"] + push
				if is_blocked(target):
					# Crushed against wall or other enemy
					to_remove.append(e)
					spawn_text(e["pos"], Global.get_text("CRUSHED"), Color.RED)
					spawn_particle(Vector2(e["pos"])*TILE_SIZE + Vector2(16,16), Color.RED, 15)
					Global.total_enemies_killed += 1
				else:
					e["pos"] = target
		
		for e in to_remove:
			enemies.erase(e)
	elif t == "heart":
		# Heal or raise max HP by 1 (permanent for the run)
		if player["hp"] < player["max_hp"]:
			player["hp"] += 1
			spawn_text(player["pos"], Global.get_text("PLUS_HP"), Color("#6cff6c"))
		else:
			player["max_hp"] += 1
			player["hp"] = player["max_hp"]
			spawn_text(player["pos"], Global.get_text("MAX_HP"), Color("#6cff6c"))
		spawn_particle(Vector2(player["pos"])*TILE_SIZE + Vector2(16,16), Color("#ff4d6d"), 18)

func spawn_text(pos, text, color):
	floating_texts.append({"pos": (Vector2(pos)*TILE_SIZE)+Vector2(16,0), "text": text, "color": color, "vel": Vector2(0, -60), "life": 0.8})

func update_floating_texts(dt):
	for i in range(floating_texts.size()-1, -1, -1):
		var ft = floating_texts[i]
		ft["pos"] += ft["vel"] * dt
		ft["life"] -= dt
		ft["color"].a = ft["life"]
		if ft["life"] <= 0: floating_texts.remove_at(i)

func spawn_particle(pos, color, count):
	for i in range(count):
		particles.append({
			"pos": pos,
			"vel": Vector2(randf_range(-80, 80), randf_range(-80, 80)),
			"color": color,
			"life": randf_range(0.3, 0.6),
			"size": randf_range(2, 5)
		})

func update_particles_process(dt):
	for i in range(particles.size()-1, -1, -1):
		var p = particles[i]
		p["pos"] += p["vel"] * dt
		p["life"] -= dt
		p["size"] -= dt * 3
		if p["life"] <= 0: particles.remove_at(i)

func update_ghosts(dt):
	for i in range(ghosts.size()-1, -1, -1):
		var g = ghosts[i]
		g["life"] -= dt * 4.0 
		if g["life"] <= 0:
			ghosts.remove_at(i)
 
	var target_px = Vector2(player["pos"]) * TILE_SIZE
	if vis_player_pos.distance_to(target_px) > 4.0:
		ghost_timer -= dt
		if ghost_timer <= 0:
			ghost_timer = 0.03 
			ghosts.append({
				"pos": vis_player_pos,
				"scale": vis_player_scale,
				"skin": Global.current_skin,
				"facing": player_facing,
				"life": 0.8
			})

class PixelIconButton extends Button:
	var icon_type = ""
	
	func _ready():
		focus_mode = Control.FOCUS_NONE
		var style = StyleBoxFlat.new()
		style.bg_color = Color("#33334d")
		style.set_corner_radius_all(0)
		style.anti_aliasing = false
 
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
		var col = Color.WHITE
 
		if is_pressed(): 
			c.y += 4 
 
		if icon_type == "pause": 
			draw_pause_icon(c, col)

	func draw_pause_icon(c, col):
		var w = 8
		var h = 24
		var gap = 8
		draw_rect(Rect2(c.x - gap/2 - w, c.y - h/2, w, h), col)
		draw_rect(Rect2(c.x + gap/2, c.y - h/2, w, h), col)

# Ses Icon Butonu (Pixel Art)
class SoundIconButton extends Button:
	var icon_type = "music"  # "music" veya "sfx"
	var is_enabled = true
	
	func _ready():
		focus_mode = Control.FOCUS_NONE
		flat = true
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	func _draw():
		var s = size
		var c = s / 2.0
		var px = 1.5  # Pixel boyutu (küçültüldü)
		
		# Arka plan
		var bg_color = Color("#3e5ba9") if is_enabled else Color("#c74e35")
		var border_color = Color("#2e4b99") if is_enabled else Color("#8f3c2d")
		
		# Panel çiz
		draw_rect(Rect2(0, 0, s.x, s.y), border_color)
		draw_rect(Rect2(2, 2, s.x - 4, s.y - 4), bg_color)
		
		# Icon rengi
		var icon_col = Color.WHITE if is_enabled else Color(1, 1, 1, 0.5)
		
		if icon_type == "music":
			_draw_music_icon(c, px, icon_col)
		else:
			_draw_sfx_icon(c, px, icon_col)
		
		# Kapalıysa üstüne çarpı çiz
		if not is_enabled:
			_draw_disabled_x(c, px)
	
	func _draw_music_icon(c: Vector2, px: float, col: Color):
		# Nota simgesi (♪) - küçük versiyon
		# Nota sapı
		draw_rect(Rect2(c.x + 2*px, c.y - 5*px, 2*px, 8*px), col)
		# Nota başı
		draw_rect(Rect2(c.x - 2*px, c.y + 1*px, 4*px, 3*px), col)
		# Bayrak
		draw_rect(Rect2(c.x + 4*px, c.y - 5*px, 3*px, 2*px), col)
	
	func _draw_sfx_icon(c: Vector2, px: float, col: Color):
		# Hoparlör simgesi - küçük versiyon
		# Hoparlör gövdesi
		draw_rect(Rect2(c.x - 5*px, c.y - 2*px, 3*px, 4*px), col)
		# Hoparlör hunisi
		draw_rect(Rect2(c.x - 2*px, c.y - 3*px, 2*px, 6*px), col)
		# Ses dalgaları
		draw_rect(Rect2(c.x + 1*px, c.y - 1*px, 2*px, 2*px), col)
		draw_rect(Rect2(c.x + 4*px, c.y - 2*px, 2*px, 4*px), col)
	
	func _draw_disabled_x(c: Vector2, px: float):
		var x_col = Color("#ff0000")
		# Çapraz çizgiler - küçük versiyon
		for i in range(-4, 5):
			draw_rect(Rect2(c.x + i*px - px*0.5, c.y + i*px - px*0.5, 2*px, 2*px), x_col)
			draw_rect(Rect2(c.x - i*px - px*0.5, c.y + i*px - px*0.5, 2*px, 2*px), x_col)
