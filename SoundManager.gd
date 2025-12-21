extends Node

# ==============================================================================
# SOUND MANAGER - Ses ve Müzik Yönetimi
# ==============================================================================

# Müzik oynatıcıları
var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

# Müzik listeleri
var menu_music_tracks: Array[AudioStream] = []
var game_music_tracks: Array[AudioStream] = []
var gameover_music: AudioStream

# Ses efektleri
var sfx_cache: Dictionary = {}

# Ses seviyeleri (0.0 - 1.0)
const DEFAULT_MUSIC_VOLUME: float = 0.4
const DEFAULT_SFX_VOLUME: float = 0.5

# Ayarlar
var music_volume: float = DEFAULT_MUSIC_VOLUME
var sfx_volume: float = DEFAULT_SFX_VOLUME
var music_enabled: bool = true
var sfx_enabled: bool = true
var step_enabled: bool = true
var current_music_type: String = ""  # "menu", "game", "gameover"

# Müzik geçişi için
var fade_tween: Tween

func _ready():
	# Müzik oynatıcısı
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Master"
	music_player.finished.connect(_on_music_finished)
	add_child(music_player)
	
	# SFX oynatıcısı (birden fazla ses için pool kullanacağız)
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "Master"
	add_child(sfx_player)
	
	# Sesleri yükle
	_load_audio_files()
	
	# Global'dan ses ayarlarını al
	_load_settings()

func _load_settings():
	if Global:
		music_enabled = Global.music_enabled
		sfx_enabled = Global.sfx_enabled
		step_enabled = Global.step_enabled
		music_volume = Global.music_volume if music_enabled else 0.0
		sfx_volume = Global.sfx_volume if sfx_enabled else 0.0

func _load_audio_files():
	# Menu müzikleri
	for i in range(1, 10):
		var path = "res://audio/menu_music" + str(i) + ".ogg"
		if ResourceLoader.exists(path):
			menu_music_tracks.append(load(path))
	
	# Game müzikleri
	for i in range(1, 10):
		var path = "res://audio/game_music" + str(i) + ".ogg"
		if ResourceLoader.exists(path):
			game_music_tracks.append(load(path))
	
	# Game over müziği
	if ResourceLoader.exists("res://audio/gameover_music.ogg"):
		gameover_music = load("res://audio/gameover_music.ogg")
	
	# Ses efektleri
	var sfx_files = ["click", "coin", "death", "hurt", "laser", "portal", "powerup", "push", "step"]
	for sfx_name in sfx_files:
		var path = "res://audio/" + sfx_name + ".wav"
		if ResourceLoader.exists(path):
			sfx_cache[sfx_name] = load(path)
	
	print("SoundManager: ", menu_music_tracks.size(), " menu müziği, ", game_music_tracks.size(), " game müziği, ", sfx_cache.size(), " ses efekti yüklendi")

# === MÜZİK FONKSİYONLARI ===

func play_menu_music():
	if not music_enabled:
		return
	if current_music_type == "menu" and music_player.playing:
		return
	current_music_type = "menu"
	_play_random_track(menu_music_tracks)

func play_game_music():
	if not music_enabled:
		return
	if current_music_type == "game" and music_player.playing:
		return
	current_music_type = "game"
	_play_random_track(game_music_tracks)

func play_gameover_music():
	if not music_enabled:
		return
	current_music_type = "gameover"
	if gameover_music:
		_fade_to_track(gameover_music, false)  # Loop değil

func stop_music():
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()
	music_player.stop()
	current_music_type = ""

func _play_random_track(track_list: Array[AudioStream]):
	if track_list.size() == 0:
		return
	var track = track_list.pick_random()
	_fade_to_track(track, true)

func _fade_to_track(track: AudioStream, _loop: bool = true):
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()
	
	var target_volume_db = linear_to_db(music_volume)
	
	# Eğer müzik çalıyorsa, önce fade out
	if music_player.playing:
		fade_tween = create_tween()
		fade_tween.tween_property(music_player, "volume_db", -40.0, 0.5)
		fade_tween.tween_callback(func():
			music_player.stream = track
			music_player.volume_db = -40.0
			music_player.play()
			var fade_in = create_tween()
			fade_in.tween_property(music_player, "volume_db", target_volume_db, 0.5)
		)
	else:
		music_player.stream = track
		music_player.volume_db = target_volume_db
		music_player.play()

func _on_music_finished():
	# Müzik bittiğinde aynı türden başka bir parça çal
	match current_music_type:
		"menu":
			_play_random_track(menu_music_tracks)
		"game":
			_play_random_track(game_music_tracks)
		"gameover":
			pass  # Gameover müziği tekrarlanmaz

# === SES EFEKTLERİ ===

func play_sfx(sfx_name: String):
	if not sfx_enabled or sfx_volume <= 0:
		return
	if not sfx_cache.has(sfx_name):
		return
	
	# Yeni bir AudioStreamPlayer oluştur (üst üste sesler için)
	var player = AudioStreamPlayer.new()
	player.stream = sfx_cache[sfx_name]
	player.volume_db = linear_to_db(sfx_volume)
	player.bus = "Master"
	add_child(player)
	player.play()
	
	# Bitince kendini sil
	player.finished.connect(func(): player.queue_free())

# Kısa yol fonksiyonları
func play_click():
	play_sfx("click")

func play_coin():
	play_sfx("coin")

func play_hurt():
	play_sfx("hurt")

func play_death():
	play_sfx("death")

func play_portal():
	play_sfx("portal")

func play_powerup():
	play_sfx("powerup")

func play_push():
	play_sfx("push")

func play_laser():
	play_sfx("laser")

func play_step():
	# Adım sesi ayrı kontrol
	if not step_enabled:
		return
	play_sfx("step")

# === SES AYARLARI ===

func set_music_enabled(enabled: bool):
	music_enabled = enabled
	Global.music_enabled = enabled
	
	if enabled:
		music_volume = Global.music_volume
	else:
		music_volume = 0.0
	
	if music_player:
		if enabled:
			music_player.volume_db = linear_to_db(music_volume)
			# Müzik açıldıysa ve çalmıyorsa, müzik çal
			if not music_player.playing:
				# current_music_type boşsa, sahneyi tahmin et
				if current_music_type == "":
					# Ana menüdeyiz varsayalım
					current_music_type = "menu"
				match current_music_type:
					"menu":
						_play_random_track(menu_music_tracks)
					"game":
						_play_random_track(game_music_tracks)
		else:
			music_player.volume_db = -80.0
	
	Global.save_game()

func set_sfx_enabled(enabled: bool):
	sfx_enabled = enabled
	Global.sfx_enabled = enabled
	
	if enabled:
		sfx_volume = Global.sfx_volume
	else:
		sfx_volume = 0.0
	
	Global.save_game()

func set_step_enabled(enabled: bool):
	step_enabled = enabled
	Global.step_enabled = enabled
	Global.save_game()

func set_music_volume(vol: float):
	music_volume = clamp(vol, 0.0, 1.0)
	Global.music_volume = music_volume
	
	if music_player and music_enabled:
		music_player.volume_db = linear_to_db(music_volume)
	
	Global.save_game()

func set_sfx_volume(vol: float):
	sfx_volume = clamp(vol, 0.0, 1.0)
	Global.sfx_volume = sfx_volume
	Global.save_game()

func get_music_volume() -> float:
	return Global.music_volume

func get_sfx_volume() -> float:
	return Global.sfx_volume

func is_music_enabled() -> bool:
	return music_enabled

func is_sfx_enabled() -> bool:
	return sfx_enabled

func is_step_enabled() -> bool:
	return step_enabled

# Eski fonksiyon - geriye dönük uyumluluk
func set_sound_enabled(enabled: bool):
	set_music_enabled(enabled)
	set_sfx_enabled(enabled)
