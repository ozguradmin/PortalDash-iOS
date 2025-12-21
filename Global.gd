extends Node

# ==============================================================================
# PORTAL DASH: GLOBAL (SINGLETON)
# Save/Load, Ayarlar, Para Birimi ve İstatistikler
# ==============================================================================

signal high_score_updated(new_score: int)

const SAVE_PATH = "user://savegame.save"

# --- OYUNCU VERİLERİ (KAYDEDİLİR) ---
var coins: int = 0
var high_score: int = 0
var owned_skins: Dictionary = { "default": true }
var current_skin: String = "default"
var player_name: String = "Player"
var custom_device_id: String = ""
var pending_score_submit: bool = false # İnternet yokken gönderilemeyen skor var mı?

# Campaign variables removed

# DAILY REWARDS
var daily_streak: int = 0
var last_claim_day_epoch: int = 0

# --- İSTATİSTİKLER (YENİ) ---
var total_steps: int = 0
var total_enemies_killed: int = 0
var total_deaths: int = 0
var total_coins_collected: int = 0
var total_games_played: int = 0
var total_time_played: float = 0.0

# --- GÜNLÜK İSTATİSTİKLER ---
var daily_stats_day_epoch: int = 0
var daily_stats: Dictionary = {"coins": 0, "steps": 0}

# --- GÖREVLER / MISSIONS ---
var missions: Dictionary = {}

# --- YETENEKLER / TALENTS (YENİ - Pasif Bonuslar) ---
var talent_max_hp: int = 3
var talent_score_value: float = 1.0 # Was talent_gold_value
var talent_luck: float = 0.0 

# --- SİSTEM ---
var tutorial_shown: bool = false

const SUPPORTED_LANGUAGES = ["en", "tr", "es", "pt", "fr", "de", "hi", "ja", "zh", "ko", "ar"]

# --- AYARLAR ---
var language: String = "en"
var sound_enabled: bool = true  # Eski - geriye dönük uyumluluk
var music_enabled: bool = true
var sfx_enabled: bool = true
var step_enabled: bool = true  # Adım sesi açma/kapama
var music_volume: float = 0.4  # 0.0 - 1.0
var sfx_volume: float = 0.5    # 0.0 - 1.0
var force_tutorial_start: bool = false # Geçici değişken (Kayıt edilmez)

# --- GEÇİCİ VERİLER ---
var leaderboard_data = [] # Sunucudan çekilecek

func _ready():
	load_game()
	check_daily_stats_reset()
	# LeaderboardManager kendi _ready'sinde otomatik fetch yapıyor

func save_game():
	var data = {
		"coins": coins,
		"high_score": high_score,
		"owned_skins": owned_skins,
		"current_skin": current_skin,
		"player_name": player_name,
		"daily_streak": daily_streak,
		"last_claim_day_epoch": last_claim_day_epoch,
		"language": language,
		"sound_enabled": sound_enabled,
		"music_enabled": music_enabled,
		"sfx_enabled": sfx_enabled,
		"step_enabled": step_enabled,
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"custom_device_id": custom_device_id,
		# İstatistikler
		"total_steps": total_steps,
		"total_enemies_killed": total_enemies_killed,
		"total_deaths": total_deaths,
		"total_coins_collected": total_coins_collected,
		"total_games_played": total_games_played,
		"total_time_played": total_time_played,
		"daily_stats_day_epoch": daily_stats_day_epoch,
		"daily_stats": daily_stats,
		"missions": missions,
		# Yetenekler
		"talent_max_hp": talent_max_hp,
		"talent_score_value": talent_score_value,
		"talent_luck": talent_luck,
		"tutorial_shown": tutorial_shown
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func get_device_language() -> String:
	var locale = OS.get_locale_language()
	if SUPPORTED_LANGUAGES.has(locale):
		return locale
	return "en"

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		# İlk açılış: Cihaz diline göre ayarla
		language = get_device_language()
		player_name = "Player" + str(randi() % 9000 + 1000)
		save_game()
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json = JSON.new()
		if json.parse(file.get_as_text()) == OK:
			var data = json.get_data()
			
			coins = data.get("coins", 0)
			high_score = data.get("high_score", 0)
			owned_skins = data.get("owned_skins", {"default": true})
			# Ücretsiz skin her zaman sahip olunmalı
			if not owned_skins.has("default"):
				owned_skins["default"] = true
			current_skin = data.get("current_skin", "default")
			# Eğer seçili skin sahip olunmuyorsa, varsayılana dön
			if not owned_skins.has(current_skin):
				current_skin = "default"
			player_name = data.get("player_name", "Player")
			daily_streak = data.get("daily_streak", 0)
			last_claim_day_epoch = data.get("last_claim_day_epoch", 0)
			# Kaydedilmiş dil varsa onu kullan (kullanıcı tercihi)
			language = data.get("language", get_device_language())
			sound_enabled = data.get("sound_enabled", true)
			music_enabled = data.get("music_enabled", true)
			sfx_enabled = data.get("sfx_enabled", true)
			step_enabled = data.get("step_enabled", true)
			music_volume = data.get("music_volume", 0.4)
			sfx_volume = data.get("sfx_volume", 0.5)
			custom_device_id = data.get("custom_device_id", "")
			
			# İstatistikleri Yükle
			total_steps = data.get("total_steps", 0)
			total_enemies_killed = data.get("total_enemies_killed", 0)
			total_deaths = data.get("total_deaths", 0)
			total_coins_collected = data.get("total_coins_collected", 0)
			total_games_played = data.get("total_games_played", 0)
			total_time_played = data.get("total_time_played", 0.0)
			daily_stats_day_epoch = data.get("daily_stats_day_epoch", 0)
			daily_stats = data.get("daily_stats", {"coins": 0, "steps": 0})
			missions = data.get("missions", {})
			
			# Yetenekleri Yükle
			talent_max_hp = data.get("talent_max_hp", 3)
			# Geriye dönük uyumluluk: eski isim 'talent_gold_value' idi
			talent_score_value = data.get("talent_score_value", data.get("talent_gold_value", 1.0))
			talent_luck = data.get("talent_luck", 0.0)
			tutorial_shown = data.get("tutorial_shown", false)

func check_daily_status():
	var current_day = int(Time.get_unix_time_from_system() / 86400)
	var status = {"can_claim": false, "reward_day": 1}
	
	if last_claim_day_epoch == 0:
		status["can_claim"] = true
		return status
 
	if current_day == last_claim_day_epoch:
		status["can_claim"] = false
		status["reward_day"] = daily_streak
		return status
 
	if current_day == last_claim_day_epoch + 1:
		status["can_claim"] = true
		var next_day = daily_streak + 1
		if next_day > 7: next_day = 1
		status["reward_day"] = next_day
		return status
 
	# Gün atlandıysa sıfırla
	status["can_claim"] = true
	status["reward_day"] = 1
	return status
	
func claim_daily_reward():
	var st = check_daily_status()
	if st["can_claim"]:
		last_claim_day_epoch = int(Time.get_unix_time_from_system() / 86400)
		daily_streak = st["reward_day"]
		var rewards = {1: 100, 2: 200, 3: 350, 4: 500, 5: 750, 6: 1000, 7: 2000}
		var amt = rewards.get(daily_streak, 100)
		coins += amt
		save_game()
		return amt
	return 0

func add_coins(amount: int):
	coins += amount
	if amount > 0:
		total_coins_collected += amount
		# Günlük İstatistik Güncelleme
		check_daily_stats_reset()
		daily_stats["coins"] += amount
	save_game()

func add_daily_steps(amount: int):
	check_daily_stats_reset()
	daily_stats["steps"] += amount
	# Save isteğe bağlı, performans için her adımda kaydetmeyebiliriz ama garanti olsun
	# save_game() 

func check_daily_stats_reset():
	var current_day = int(Time.get_unix_time_from_system() / 86400)
	if daily_stats_day_epoch != current_day:
		daily_stats_day_epoch = current_day
		daily_stats["coins"] = 0
		daily_stats["steps"] = 0
		# Görevlerin 'claimed' durumunu sıfırla (Daily olanlar)
		for k in missions:
			if missions[k].get("is_daily", false):
				missions[k]["claimed_day"] = -1
		save_game()

func update_high_score(new_score: int):
	var should_submit = false
	
	# Basit mantık: Yeni skor yüksekse güncelle ve gönder
	if new_score > high_score:
		high_score = new_score
		save_game()
		should_submit = true
	elif new_score > 0 and not _is_on_leaderboard():
		# Skor kırılmasa bile, eğer listeye girmeye değerse gönder
		if LeaderboardManager and LeaderboardManager.is_score_worthy(new_score):
			should_submit = true
	
	if should_submit and LeaderboardManager:
		LeaderboardManager.submit_score(high_score)

	# Score güncellendiğinde signal gönder
	emit_signal("high_score_updated", high_score)
	
	return new_score > 0

func _is_on_leaderboard() -> bool:
	# Kullanıcının leaderboard'da olup olmadığını kontrol et
	if leaderboard_data is Array:
		var device_id = OS.get_unique_id()
		for entry in leaderboard_data:
			if entry is Dictionary:
				if entry.get("device_id", "") == device_id:
					return true
				if entry.get("name", "") == player_name and entry.get("score", 0) == high_score:
					return true
	return false

func unlock_skin(skin_id: String, cost: int) -> bool:
	if coins >= cost:
		coins -= cost
		owned_skins[skin_id] = true
		current_skin = skin_id
		save_game()
		return true
	return false

func select_skin(skin_id: String):
	if owned_skins.has(skin_id) and owned_skins[skin_id]:
		current_skin = skin_id
		save_game()

# --- DİL SİSTEMİ ---
const TEXTS = {
	"START": {"en": "START", "tr": "BASLA", "es": "INICIO", "pt": "INICIO", "fr": "JOUIER", "de": "START", "hi": "शुरू", "ja": "スタート", "zh": "开始", "ko": "시작", "ar": "ابدأ"},
	"PLAY": {"en": "PLAY", "tr": "OYNA", "es": "JUGAR", "pt": "JOGAR", "fr": "JOUER", "de": "SPIELEN", "hi": "खेलें", "ja": "プレイ", "zh": "玩", "ko": "플레이", "ar": "لعب"},
	"SHOP": {"en": "SHOP", "tr": "MAGAZA", "es": "TIENDA", "pt": "LOJA", "fr": "BOUTIQUE", "de": "SHOP", "hi": "दुकान", "ja": "ショップ", "zh": "商店", "ko": "상점", "ar": "المتجر"},
	"SETTINGS": {"en": "SETTINGS", "tr": "AYARLAR", "es": "AJUSTES", "pt": "AJUSTES", "fr": "PARAMÈTRES", "de": "EINSTELLUNGEN", "hi": "सेटिंग्स", "ja": "設定", "zh": "设置", "ko": "설정", "ar": "إعدادات"},
	"HIGHSCORE": {"en": "HIGH SCORE", "tr": "EN YUKSEK SKOR", "es": "RÉCORD", "pt": "RECORDE", "fr": "MEILLEUR SCORE", "de": "REKORD", "hi": "उच्च स्कोर", "ja": "ハイスコア", "zh": "最高分", "ko": "최고기록", "ar": "أعلى نقاط"},
	"LEADERBOARD": {"en": "LEADERBOARD", "tr": "SIRALAMA", "es": "CLASIFICACIÓN", "pt": "RANKING", "fr": "CLASSEMENT", "de": "RANGLISTE", "hi": "लीडरबोर्ड", "ja": "ランキング", "zh": "排行榜", "ko": "순위", "ar": "لوحة الصدارة"},
	"COINS": {"en": "COINS", "tr": "ALTIN", "es": "MONEDAS", "pt": "MOEDAS", "fr": "PIÈCES", "de": "MÜNZEN", "hi": "सिक्के", "ja": "コイン", "zh": "金币", "ko": "코인", "ar": "عملات"},
	"PAUSED": {"en": "PAUSED", "tr": "DURAKLATILDI", "es": "PAUSA", "pt": "PAUSA", "fr": "PAUSE", "de": "PAUSE", "hi": "रुका हुआ", "ja": "一時停止", "zh": "暂停", "ko": "일시정지", "ar": "مؤقت"},
	"DAILY_REWARD": {"en": "DAILY REWARD", "tr": "GUNLUK ODUL", "es": "PREMIO DIARIO", "pt": "PRÊMIO DIÁRIO", "fr": "RÉCOMPENSE", "de": "BELOHNUNG", "hi": "दैनिक इनाम", "ja": "デイリー", "zh": "日常奖励", "ko": "일일보상", "ar": "جائزة يومية"},
	"DAY": {"en": "DAY", "tr": "GUN", "es": "DÍA", "pt": "DIA", "fr": "JOUR", "de": "TAG", "hi": "दिन", "ja": "日", "zh": "天", "ko": "일", "ar": "يوم"},
	"CLAIM": {"en": "CLAIM", "tr": "AL", "es": "RECLAMAR", "pt": "RESGATAR", "fr": "RÉCLAMER", "de": "ABHOLEN", "hi": "दावा", "ja": "受け取る", "zh": "领取", "ko": "받기", "ar": "استلام"},
	"COME_BACK_TOMORROW": {"en": "COME BACK TOMORROW", "tr": "YARIN GEL", "es": "VUELVE MAÑANA", "pt": "VOLTE AMANHÃ", "fr": "REVIENS DEMAIN", "de": "MORGEN WIEDER", "hi": "कल आएं", "ja": "また明日", "zh": "明天再来", "ko": "내일 오세요", "ar": "عد غداً"},
	"RESUME": {"en": "RESUME", "tr": "DEVAM ET", "es": "CONTINUAR", "pt": "CONTINUAR", "fr": "REPRENDRE", "de": "WEITER", "hi": "जारी रखें", "ja": "再開", "zh": "继续", "ko": "계속", "ar": "استئناف"},
	"RESTART": {"en": "RESTART", "tr": "YENIDEN BASLAT", "es": "REINICIAR", "pt": "REINICIAR", "fr": "REDÉMARRER", "de": "NEUSTART", "hi": "फिर से शुरू", "ja": "リスタート", "zh": "重来", "ko": "다시시작", "ar": "إعادة"},
	"GAMEOVER": {"en": "GAME OVER", "tr": "OYUN BITTI", "es": "FIN DEL JUEGO", "pt": "FIM DE JOGO", "fr": "GAME OVER", "de": "SPIEL ENDE", "hi": "खेल खत्म", "ja": "ゲームオーバー", "zh": "游戏结束", "ko": "게임오버", "ar": "انتهت اللعبة"},
	"SCORE": {"en": "SCORE", "tr": "SKOR", "es": "PUNTOS", "pt": "PONTOS", "fr": "SCORE", "de": "PUNKTE", "hi": "स्कोर", "ja": "スコア", "zh": "分数", "ko": "점수", "ar": "نقاط"},
	"TRY_AGAIN": {"en": "TRY AGAIN", "tr": "TEKRAR DENE", "es": "RÉINTENTAR", "pt": "TENTAR NOVAMENTE", "fr": "RÉESSAYER", "de": "NOCHMAL", "hi": "पुनः प्रयास", "ja": "リトライ", "zh": "再试一次", "ko": "재시도", "ar": "حاول مرة أخرى"},
	"MAIN_MENU": {"en": "MAIN MENU", "tr": "ANA MENU", "es": "MENÚ PRINCIPAL", "pt": "MENU PRINCIPAL", "fr": "MENU PRINCIPAL", "de": "HAUPTMENÜ", "hi": "मुख्य मेनू", "ja": "メインメニュー", "zh": "主菜单", "ko": "메인메뉴", "ar": "القائمة الرئيسية"},
	"BUY": {"en": "BUY", "tr": "SATIN AL", "es": "COMPRAR", "pt": "COMPRAR", "fr": "ACHETER", "de": "KAUFEN", "hi": "खरीदें", "ja": "購入", "zh": "购买", "ko": "구매", "ar": "شراء"},
	"EQUIP": {"en": "EQUIP", "tr": "KULLAN", "es": "EQUIPAR", "pt": "EQUIPAR", "fr": "ÉQUIPER", "de": "AUSRÜSTEN", "hi": "उपयोग", "ja": "装備", "zh": "装备", "ko": "장착", "ar": "تجهيز"},
	"OWNED": {"en": "OWNED", "tr": "MEVCUT", "es": "EN PROPIEDAD", "pt": "ADQUIRIDO", "fr": "POSSÉDÉ", "de": "BESITZ", "hi": "स्वामित्व", "ja": "所持", "zh": "已拥有", "ko": "보유중", "ar": "مملوك"},
	"FREE": {"en": "FREE", "tr": "UCRETSIZ", "es": "GRATIS", "pt": "GRÁTIS", "fr": "GRATUIT", "de": "GRATIS", "hi": "मुफ्त", "ja": "無料", "zh": "免费", "ko": "무료", "ar": "مجاني"},
	"EXIT_MENU": {"en": "EXIT / MENU", "tr": "CIKIS / MENU", "es": "SALIR / MENÚ", "pt": "SAIR / MENU", "fr": "QUITTER / MENU", "de": "EXIT / MENÜ", "hi": "निकास / मेनू", "ja": "終了 / メニュー", "zh": "退出 / 菜单", "ko": "종료 / 메뉴", "ar": "خروج / القائمة"},
	"STAGE_CLEAR": {"en": "STAGE CLEAR!", "tr": "BOLUM BITTI!", "es": "¡NIVEL COMPLETADO!", "pt": "FASE CONCLUÍDA!", "fr": "NIVEAU TERMINÉ!", "de": "LEVEL GESCHAFFT!", "hi": "चरण स्पष्ट!", "ja": "ステージクリア！", "zh": "过关！", "ko": "스테이지 클리어!"},
	"SKINS": {"en": "SKINS", "tr": "KOSTUMLER", "es": "ASPECTOS", "pt": "SKINS", "fr": "SKINS", "de": "SKINS", "hi": "skinz", "ja": "スキン", "zh": "皮肤", "ko": "स्킨"},
	"SKILLS": {"en": "SKILLS", "tr": "YETENEKLER", "es": "HABILIDADES", "pt": "HABILIDADES", "fr": "COMPÉTENCES", "de": "SKILLS", "hi": "कौशल", "ja": "スキル", "zh": "技能", "ko": "스킬"},
	"RANK": {"en": "RANK", "tr": "SIRA", "es": "RANGO", "pt": "RANK", "fr": "RANG", "de": "RANG", "hi": "रैंक", "ja": "ランク", "zh": "排名", "ko": "랭크"},
	"STATS": {"en": "STATS", "tr": "ISTATISTIK", "es": "ESTADÍSTICAS", "pt": "ESTATÍSTICAS", "fr": "STATS", "de": "STATS", "hi": "आंकड़े", "ja": "ステータス", "zh": "统计", "ko": "통계"},
	"YOUR_NAME": {"en": "YOUR NAME", "tr": "ISMINIZ", "es": "TU NOMBRE", "pt": "SEU NOME", "fr": "VOTRE NOM", "de": "DEIN NAME", "hi": "आपका नाम", "ja": "あなたの名前", "zh": "你的名字", "ko": "당신의 이름"},
	"OK": {"en": "OK", "tr": "TAMAM", "es": "OK", "pt": "OK", "fr": "OK", "de": "OK", "hi": "ठीक", "ja": "OK", "zh": "确定", "ko": "확인"},
	"LORE_TIP_1": {"en": "Tip: Turrets fire every 3 turns.", "tr": "Ipucu: Kuleler 3 turda bir ates eder.", "es": "Consejo: Las torretas disparan cada 3 turnos.", "pt": "Dica: Torres atiram a cada 3 turnos.", "fr": "Astuce: Tourelles tirent tous les 3 tours.", "de": "Tipp: Türme feuern alle 3 Runden.", "hi": "टिप: बुर्ज हर 3 मोड़ पर फायर करते हैं।", "ja": "ヒント: タレットは3ターンごとに発射します。", "zh": "提示：炮塔每3回合开火一次。", "ko": "팁: 포탑은 3턴마다 발사합니다.", "ar": "تلميح: الأبراج تطلق النار كل 3 أدوار."},
	"LORE_TIP_2": {"en": "Tip: Spike traps only hurt you.", "tr": "Ipucu: Dikenler sadece sana zarar verir.", "es": "Consejo: Los pinchos solo te hieren a ti.", "pt": "Dica: Espinhos só ferem você.", "fr": "Astuce: Les pièges ne blessent que vous.", "de": "Tipp: Stacheln verletzen nur dich.", "hi": "टिप: स्पाइक जाल केवल आपको चोट पहुंचाते हैं।", "ja": "ヒント: スパイクはあなただけを傷つけます。", "zh": "提示：尖刺陷阱只会伤害你。", "ko": "팁: 가시는 당신에게만 피해를 줍니다.", "ar": "تلميح: الفخاخ تؤذيك أنت فقط."},
	"LORE_TIP_3": {"en": "Legend: The Crimson Knight never sleeps.", "tr": "Efsane: Kizil Sovalye asla uyumaz.", "es": "Leyenda: El Caballero Carmesí nunca duerme.", "pt": "Lenda: O Cavaleiro Carmesim nunca dorme.", "fr": "Légende: Le Chevalier Pourpre ne dort jamais.", "de": "Legende: Der Rote Ritter schläft nie.", "hi": "किंवदंती: क्रिमसन नाइट कभी नहीं सोता है।", "ja": "伝説: クリムゾンナイトは決して眠らない。", "zh": "传说：深红骑士从不睡觉。", "ko": "전설: 진홍의 기사는 절대 잠들지 않습니다.", "ar": "أسطورة: الفارس القرمزي لا ينام أبدًا."},
	"LORE_TIP_4": {"en": "Tip: Collect gold quickly for combo!", "tr": "Ipucu: Kombo icin hizli altin topla!", "es": "Consejo: ¡Recoge oro rápido para combos!", "pt": "Dica: Colete ouro rápido para combo!", "fr": "Astuce: Ramassez l'or vite pour le combo!", "de": "Tipp: Sammle Gold schnell für Kombos!", "hi": "टिप: कॉम्बो के लिए जल्दी सोना इकट्ठा करें!", "ja": "ヒント: コンボのために素早くゴールドを集めよう！", "zh": "提示：快速收集金币以获得连击！", "ko": "팁: 콤보를 위해 골드를 빨리 모으세요!", "ar": "تلميح: اجمع الذهب بسرعة للحصول على كومبو!"},
	"LORE_TIP_5": {"en": "Tip: Use freeze to skip enemy turns.", "tr": "Ipucu: Donma ile dusman turlarini atla.", "es": "Consejo: Usa congelar para saltar turnos.", "pt": "Dica: Use gelo para pular turnos inimigos.", "fr": "Astuce: Gelez pour passer les tours ennemis.", "de": "Tipp: Nutze Frost um Gegner zu stoppen.", "hi": "टिप: दुश्मन की बारी छोड़ने के लिए फ्रीज का उपयोग करें।", "ja": "ヒント: 凍結を使って敵のターンをスキップ。", "zh": "提示：使用冻结跳过敌人回合。", "ko": "팁: 얼음을 사용하여 적의 턴을 넘기세요.", "ar": "تلميح: استخدم التجميد لتخطي أدوار العدو."},
	"LORE_TIP_6": {"en": "Tip: Hearts can raise your max HP.", "tr": "Ipucu: Kalpler maksimum canini artirabilir.", "es": "Consejo: Los corazones pueden subir tu salud máx.", "pt": "Dica: Corações aumentam seu HP máx.", "fr": "Astuce: Les cœurs augmentent vos PV max.", "de": "Tipp: Herzen können Max HP erhöhen.", "hi": "टिप: दिल आपके अधिकतम स्वास्थ्य को बढ़ा सकते हैं।", "ja": "ヒント: ハートは最大HPを増やすことがあります。", "zh": "提示：红心可以增加最大生命值。", "ko": "팁: 하트는 최대 체력을 늘릴 수 있습니다.", "ar": "تلميح: القلوب يمكن أن تزيد من صحتك القصوى."},
	"LORE_TIP_7": {"en": "Tip: Shockwave crushes foes into walls.", "tr": "Ipucu: Sok dalgasi dusmanlari duvara carpar.", "es": "Consejo: Onda de choque aplasta enemigos.", "pt": "Dica: Onda de choque esmaga inimigos.", "fr": "Astuce: Onde de choc écrase les ennemis.", "de": "Tipp: Schockwelle drückt Gegner in Wände.", "hi": "टिप: शॉकवेव दुश्मनों को दीवारों में कुचल देती है।", "ja": "ヒント: 衝撃波は敵を壁に叩きつけます。", "zh": "提示：冲击波将敌人撞向墙壁。", "ko": "팁: 충격파는 적을 벽으로 밀쳐냅니다.", "ar": "تلميح: الموجة الصادمة تسحق الأعداء في الجدران."},
	"LORE_TIP_8": {"en": "Tip: Sleeping enemies wake at close range.", "tr": "Ipucu: Uykucular yakininda uyanir.", "es": "Consejo: Enemigos dormidos despiertan cerca.", "pt": "Dica: Inimigos dormindo acordam de perto.", "fr": "Astuce: Ennemis endormis se réveillent de près.", "de": "Tipp: Schlafende Gegner wachen nah auf.", "hi": "टिप: सोते हुए दुश्मन करीब आने पर जाग जाते हैं।", "ja": "ヒント: 眠っている敵は近づくと目覚めます。", "zh": "提示：熟睡的敌人在靠近时会醒来。", "ko": "팁: 잠자는 적은 가까이 가면 깨어납니다.", "ar": "تلميح: الأعداء النائمون يستيقظون عند الاقتراب."},
	"TOTAL_STEPS": {"en": "Total Steps", "tr": "Toplam Adim", "es": "Pasos Totales", "pt": "Passos Totais", "fr": "Pas Totaux", "de": "Schritte", "hi": "कुल कदम", "ja": "総ステップ", "zh": "总步数", "ko": "총 걸음", "ar": "الخطوات"},
	"ENEMIES_KILLED": {"en": "Enemies Defeated", "tr": "Oldurulen Dusman", "es": "Enemigos Derrotados", "pt": "Inimigos Derrotados", "fr": "Ennemis Vaincus", "de": "Besiegte Gegner", "hi": "पराजित दुश्मन", "ja": "倒した敵", "zh": "击败敌人", "ko": "처치한 적", "ar": "الأعداء المهزومون"},
	"TOTAL_DEATHS": {"en": "Total Deaths", "tr": "Toplam Olum", "es": "Muertes Totales", "pt": "Mortes Totais", "fr": "Morts Totales", "de": "Tode", "hi": "कुल मृत्यु", "ja": "総死亡数", "zh": "总死亡", "ko": "총 사망", "ar": "مجموع الوفيات"},
	"SOUND": {"en": "SOUND", "tr": "SES", "es": "SONIDO", "pt": "SOM", "fr": "SON", "de": "TON", "hi": "ध्वनि", "ja": "サウンド", "zh": "声音", "ko": "사운드", "ar": "الصوت"},
	"MUSIC": {"en": "MUSIC", "tr": "MUZIK", "es": "MÚSICA", "pt": "MÚSICA", "fr": "MUSIQUE", "de": "MUSIK", "hi": "संगीत", "ja": "音楽", "zh": "音乐", "ko": "음악", "ar": "الموسيقى"},
	"SFX": {"en": "SFX", "tr": "SES EFEKTI", "es": "SFX", "pt": "SFX", "fr": "SFX", "de": "SFX", "hi": "प्रभाव", "ja": "効果音", "zh": "音效", "ko": "효과음", "ar": "مؤثرات"},
	"STEP_SOUND": {"en": "STEP SOUND", "tr": "ADIM SESI", "es": "PASOS", "pt": "PASSOS", "fr": "PAS", "de": "SCHRITTE", "hi": "कदम ध्वनि", "ja": "足音", "zh": "脚步声", "ko": "발소리", "ar": "صوت الخطوات"},
	"VOLUME": {"en": "VOL", "tr": "SEV", "es": "VOL", "pt": "VOL", "fr": "VOL", "de": "LAUT", "hi": "VOL", "ja": "音量", "zh": "音量", "ko": "볼륨", "ar": "الحجم"},
	"LANGUAGE": {"en": "LANGUAGE", "tr": "DIL", "es": "IDIOMA", "pt": "IDIOMA", "fr": "LANGUE", "de": "SPRACHE", "hi": "भाषा", "ja": "言語", "zh": "语言", "ko": "언어", "ar": "اللغة"},
	"ON": {"en": "ON", "tr": "ACIK", "es": "ON", "pt": "ON", "fr": "ON", "de": "AN", "hi": "चालू", "ja": "ON", "zh": "开", "ko": "켜짐", "ar": "تشغيل"},
	"OFF": {"en": "OFF", "tr": "KAPALI", "es": "OFF", "pt": "OFF", "fr": "OFF", "de": "AUS", "hi": "बंद", "ja": "OFF", "zh": "关", "ko": "꺼짐", "ar": "إيقاف"}
	,
	"UPDATE_REQ": {"en": "UPDATE REQUIRED", "tr": "GUNCELLEME GEREKLI", "es": "ACTUALIZACIÓN", "pt": "ATUALIZAÇÃO", "fr": "MISE À JOUR", "de": "UPDATE", "hi": "अपडेट", "ja": "更新", "zh": "更新", "ko": "업데이트"},
	"UPDATE_MSG": {"en": "A new update is required to continue.", "tr": "Devam etmek icin yeni guncelleme gerekli.", "es": "Se requiere actualización.", "pt": "Atualização necessária.", "fr": "Mise à jour requise.", "de": "Update erforderlich.", "hi": "अपडेट आवश्यक है।", "ja": "更新が必要です。", "zh": "需更新。", "ko": "업데이트가 필요합니다."},
	"UPDATE_BTN": {"en": "UPDATE NOW", "tr": "HEMEN GUNCELLE", "es": "ACTUALIZAR", "pt": "ATUALIZAR", "fr": "METTRE À JOUR", "de": "UPDATE", "hi": "अभी अपडेट करें", "ja": "今すぐ更新", "zh": "立即更新", "ko": "지금 업데이트"},
	"MAINTENANCE_MSG": {"en": "Servers are under maintenance.", "tr": "Sunucular su an bakimda.", "es": "Mantenimiento.", "pt": "Manutenção.", "fr": "Maintenance.", "de": "Wartung.", "hi": "रखरखाव।", "ja": "メンテナンス中。", "zh": "维护中。", "ko": "점검 중."},
	
	"HOW_TO_PLAY": {"en": "HOW TO PLAY", "tr": "NASIL OYNANIR", "es": "CÓMO JUGAR", "pt": "COMO JOGAR", "fr": "TUTORIEL", "de": "ANLEITUNG", "hi": "कैसे खेलें", "ja": "遊び方", "zh": "怎么玩", "ko": "게임방법", "ar": "كيف ألعب"},
	"AIM": {"en": "AIM!", "tr": "NISAN!", "es": "¡APUNTA!", "pt": "MIRE!", "fr": "VISEZ!", "de": "ZIELEN!", "hi": "निशाना!", "ja": "狙え！", "zh": "瞄准！", "ko": "조준!", "ar": "هدف!"},
	"FIRE": {"en": "FIRE!", "tr": "ATES!", "es": "¡FUEGO!", "pt": "FOGO!", "fr": "FEU!", "de": "FEUER!", "hi": "फायर!", "ja": "撃て！", "zh": "开火！", "ko": "발사!", "ar": "نار!"},
	"CRUSHED": {"en": "CRUSHED!", "tr": "EZILDI!", "es": "¡APLASTADO!", "pt": "ESMAGADO!", "fr": "ÉCRASÉ!", "de": "ZERQUETSCHT!", "hi": "कुचला गया!", "ja": "圧殺！", "zh": "粉碎！", "ko": "압사!", "ar": "سحق!"},
	"MAX_HP": {"en": "+MAX HP", "tr": "+MAX CAN", "es": "+SALUD MÁX", "pt": "+HP MÁX", "fr": "+PV MAX", "de": "+MAX HP", "hi": "+अधिकतम स्वास्थ्य", "ja": "+最大HP", "zh": "+最大生命", "ko": "+최대체력", "ar": "+صحة قصوى"},
	"PLUS_HP": {"en": "+HP", "tr": "+CAN", "es": "+SALUD", "pt": "+HP", "fr": "+PV", "de": "+HP", "hi": "+स्वास्थ्य", "ja": "+HP", "zh": "+生命", "ko": "+체력", "ar": "+صحة"},
	"BLOCKED": {"en": "BLOCKED", "tr": "ENGELLENDI", "es": "BLOQUEADO", "pt": "BLOQUEADO", "fr": "BLOQUÉ", "de": "BLOCKIERT", "hi": "अवरुद्ध", "ja": "ブロック", "zh": "已格挡", "ko": "막힘", "ar": "محظور"},
	"PUSHED": {"en": "PUSHED!", "tr": "ITILDI!", "es": "¡EMPUJADO!", "pt": "EMPURRADO!", "fr": "POUSSÉ!", "de": "GESCHUBST!", "hi": "धकेल दिया!", "ja": "プッシュ！", "zh": "推开！", "ko": "밀쳐짐!", "ar": "دفع!"},
	"BUFF_MAGNET": {"en": "MAGNET!", "tr": "MIKNATIK!", "es": "¡IMÁN!", "pt": "ÍMÃ!", "fr": "AIMANT!", "de": "MAGNET!", "hi": "चुंबक!", "ja": "マグネット！", "zh": "磁铁！", "ko": "자석!", "ar": "مغناطيس!"},
	"BUFF_SHIELD": {"en": "SHIELD!", "tr": "KALKAN!", "es": "¡ESCUDO!", "pt": "ESCUDO!", "fr": "BOUCLIER!", "de": "SCHILD!", "hi": "ढाल!", "ja": "シールド！", "zh": "护盾！", "ko": "보호막!", "ar": "درع!"},
	"BUFF_FREEZE": {"en": "FREEZE!", "tr": "DONDUR!", "es": "¡HIELO!", "pt": "GELO!", "fr": "GEL!", "de": "FROST!", "hi": "फ्रीज!", "ja": "フリーズ！", "zh": "冻结！", "ko": "얼음!", "ar": "تجميد!"},
	"BUFF_SHOCKWAVE": {"en": "SHOCKWAVE!", "tr": "SOK DALGASI!", "es": "¡ONDA!", "pt": "ONDA!", "fr": "ONDE CHOC!", "de": "SCHOCK!", "hi": "शॉकवेव!", "ja": "ショックウェーブ！", "zh": "冲击波！", "ko": "충격파!", "ar": "موجة صدمة!"},
	"BUFF_HEART": {"en": "HEART!", "tr": "KALP!", "es": "¡CORAZÓN!", "pt": "CORAÇÃO!", "fr": "CŒUR!", "de": "HERZ!", "hi": "दिल!", "ja": "ハート！", "zh": "红心！", "ko": "하트!", "ar": "قلب!"},
	"GIFT_CODE": {"en": "GIFT CODE", "tr": "HEDIYE KODU", "es": "CÓDIGO", "pt": "CÓDIGO", "fr": "CODE CADEAU", "de": "GESCHENKCODE", "hi": "उपहार कोड", "ja": "ギフトコード", "zh": "礼包码", "ko": "쿠폰", "ar": "رمز هدية"},
	"ENTER_CODE": {"en": "ENTER CODE", "tr": "KOD GIR", "es": "INTRODUCIR", "pt": "DIGITAR", "fr": "ENTRER CODE", "de": "CODE EINGEBEN", "hi": "कोड दर्ज करें", "ja": "コード入力", "zh": "输入代码", "ko": "코드입력", "ar": "أدخل الرمز"},
	"CODE_NOT_FOUND": {"en": "Code not found!", "tr": "Boyle bir kod bulunmuyor!", "es": "¡Código no encontrado!", "pt": "Código não encontrado!", "fr": "Code introuvable!", "de": "Code nicht gefunden!", "hi": "कोड नहीं मिला!", "ja": "コードが見つかりません！", "zh": "代码不存在！", "ko": "코드를 찾을 수 없습니다!", "ar": "الرمز غير موجود!"},
	"CODE_EXPIRED": {"en": "Code expired!", "tr": "Kod suresi dolmus!", "es": "¡Expirado!", "pt": "Expirado!", "fr": "Expiré!", "de": "Abgelaufen!", "hi": "समाप्त!", "ja": "期限切れ！", "zh": "已过期！", "ko": "만료됨!", "ar": "انتهت صلاحية الرمز!"},
	"ALREADY_USED": {"en": "You already used this code!", "tr": "Bu kodu zaten kullandiniz!", "es": "¡Ya usado!", "pt": "Já usado!", "fr": "Déjà utilisé!", "de": "Schon benutzt!", "hi": "पहले ही उपयोग किया गया!", "ja": "使用済み！", "zh": "已使用！", "ko": "이미 사용됨!", "ar": "تم استخدامه بالفعل!"},
	"CODE_SUCCESS": {"en": "You received %d gold!", "tr": "%d altin kazandiniz!", "es": "¡%d oro recibido!", "pt": "Recebeu %d ouro!", "fr": "Reçu %d or!", "de": "%d Gold erhalten!", "hi": "%d सोना प्राप्त!", "ja": "%d ゴールド獲得！", "zh": "获得 %d 金币！", "ko": "%d 골드 획득!", "ar": "حصلت على %d ذهب!"},
	"ADMIN_PANEL": {"en": "ADMIN PANEL", "tr": "ADMIN PANELI", "es": "PANEL ADMIN", "pt": "PAINEL ADMIN", "fr": "ADMIN", "de": "ADMIN", "hi": "व्यवस्थापक", "ja": "管理パネル", "zh": "管理面板", "ko": "관리자", "ar": "لوحة الإدارة"},
	"USER_NAME": {"en": "NAME", "tr": "ISIM", "es": "NOMBRE", "pt": "NOME", "fr": "NOM", "de": "NAME", "hi": "नाम", "ja": "名前", "zh": "名字", "ko": "이름", "ar": "الاسم"},
	"USER_SCORE": {"en": "SCORE", "tr": "SKOR", "es": "PUNTOS", "pt": "PONTOS", "fr": "SCORE", "de": "PUNKTE", "hi": "स्कोर", "ja": "スコア", "zh": "分数", "ko": "점수", "ar": "النقاط"},
	"SAVE": {"en": "SAVE", "tr": "KAYDET", "es": "GUARDAR", "pt": "SALVAR", "fr": "SAUVER", "de": "SPEICHERN", "hi": "सहेजें", "ja": "保存", "zh": "保存", "ko": "저장", "ar": "حفظ"},
	"COUPON_CODE": {"en": "COUPON CODE", "tr": "KUPON KODU", "es": "CÓDIGO", "pt": "CÓDIGO", "fr": "CODE", "de": "CODE", "hi": "कूपन", "ja": "クーポン", "zh": "优惠券", "ko": "쿠폰", "ar": "رمز القسيمة"},
	"GOLD_AMOUNT": {"en": "GOLD AMOUNT", "tr": "ALTIN MIKTARI", "es": "CANTIDAD ORO", "pt": "QTD OURO", "fr": "QUANTITÉ OR", "de": "GOLD MENGE", "hi": "सोने की मात्रा", "ja": "ゴールド量", "zh": "金币数量", "ko": "골드량", "ar": "كمية الذهب"},
	"MAX_USES": {"en": "MAX USES", "tr": "MAKS KULLANIM", "es": "USOS MÁX", "pt": "USOS MÁX", "fr": "MAX USAGES", "de": "MAX NUTZUNG", "hi": "अधिकतम उपयोग", "ja": "最大使用", "zh": "最大使用", "ko": "최대사용", "ar": "أقصى استخدام"},
	"UNLIMITED": {"en": "UNLIMITED", "tr": "SINIRSIZ", "es": "ILIMITADO", "pt": "ILIMITADO", "fr": "ILLIMITÉ", "de": "UNBEGRENZT", "hi": "असीमित", "ja": "無制限", "zh": "无限", "ko": "무제한", "ar": "غير محدود"},
	"ADD_COUPON": {"en": "ADD COUPON", "tr": "KUPON EKLE", "es": "AÑADIR", "pt": "ADICIONAR", "fr": "AJOUTER", "de": "HINZUFÜGEN", "hi": "जोड़ें", "ja": "追加", "zh": "添加", "ko": "추가", "ar": "أضف"},
	"DELETE": {"en": "DELETE", "tr": "SIL", "es": "ELIMINAR", "pt": "EXCLUIR", "fr": "SUPPRIMER", "de": "LÖSCHEN", "hi": "हटाएं", "ja": "削除", "zh": "删除", "ko": "삭제", "ar": "حذف"},
	"SUBMIT": {"en": "SUBMIT", "tr": "GONDER", "es": "ENVIAR", "pt": "ENVIAR", "fr": "ENVOYER", "de": "SENDEN", "hi": "प्रस्तुत", "ja": "送信", "zh": "提交", "ko": "제출", "ar": "إرسال"},
	
	"TUTORIAL_TITLE": {"en": "TUTORIAL", "tr": "OGRETICI", "es": "TUTORIAL", "pt": "TUTORIAL", "fr": "TUTORIEL", "de": "TUTORIAL", "hi": "ट्यूटोरियल", "ja": "チュートリアル", "zh": "教程", "ko": "튜토리얼", "ar": "تعليمي"},
	"TUTORIAL_WELCOME_TITLE": {"en": "WELCOME", "tr": "HOS GELDIN", "es": "BIENVENIDO", "pt": "BEM-VINDO", "fr": "BIENVENUE", "de": "WILLKOMMEN", "hi": "स्वागत", "ja": "ようこそ", "zh": "欢迎", "ko": "환영합니다", "ar": "أهلاً بك"},
	"TUTORIAL_WELCOME_DESC": {"en": "Welcome to Portal Dash! Your goal is to reach the Portal and get a high score.", "tr": "Portal Dash'e Hos Geldin! Amacin Portala ulasmak ve yuksek skor yapmak.", "es": "¡Bienvenido a Portal Dash! Llega al portal.", "pt": "Bem-vindo ao Portal Dash! Chegue ao portal.", "fr": "Bienvenue! Atteignez le portail.", "de": "Willkommen! Erreiche das Portal.", "hi": "पोर्टल डैश में आपका स्वागत है!", "ja": "ポータルダッシュへようこそ！", "zh": "欢迎来到传送门冲刺！", "ko": "포털 대시에 오신 것을 환영합니다!", "ar": "أهلاً في بورتال داش! هدفك هو الوصول للبوابة."},
	"TUTORIAL_ENEMIES_TITLE": {"en": "ENEMIES", "tr": "DUSMANLAR", "es": "ENEMIGOS", "pt": "INIMIGOS", "fr": "ENNEMIS", "de": "GEGNER", "hi": "दुश्मन", "ja": "敵", "zh": "敌人", "ko": "적", "ar": "الأعداء"},
	"TUTORIAL_ENEMIES_DESC": {"en": "Avoid enemies! Red ones chase you, Sleepy ones (Brown) wake up if you get close!", "tr": "Dusmanlardan kacin! Kirmizilar seni kovalar, Uykucular (Kahve) yaklasinca uyanir!", "es": "¡Evita enemigos! Los rojos te persiguen.", "pt": "Evite inimigos! Vermelhos te perseguem.", "fr": "Évitez les ennemis! Les rouges vous chassent.", "de": "Meide Gegner! Rote jagen dich.", "hi": "दुश्मनों से बचें!", "ja": "敵を避けよう！赤は追いかけてきます。", "zh": "避开敌人！红色的会追你。", "ko": "적을 피하세요! 빨간색은 당신을 쫓아옵니다.", "ar": "تجنب الأعداء! الحمر يطاردونك."},
	"TUTORIAL_BUFFS_TITLE": {"en": "GOLD & BUFFS", "tr": "ALTIN & BUFF", "es": "ORO Y MEJORAS", "pt": "OURO E BUFFS", "fr": "OR ET BONUS", "de": "GOLD & BUFFS", "hi": "सोना और बफ़्स", "ja": "ゴールド＆バフ", "zh": "金币和增益", "ko": "골드 & 버프", "ar": "الذهب والمكافآت"},
	"TUTORIAL_BUFFS_DESC": {"en": "Collect GOLD for upgrades. Pick up BUFFS (Heart, Shield etc.) to survive.", "tr": "Gelistirmeler icin ALTIN topla. Hayatta kalmak icin BUFF'lari (Kalp, Kalkan vb.) al.", "es": "Recoge ORO. Usa MEJORAS para sobrevivir.", "pt": "Colete OURO. Use BUFFS para sobreviver.", "fr": "Collectez OR. Utilisez BONUS pour survivre.", "de": "Sammle GOLD. Nutze BUFFS zum Überleben.", "hi": "सोना इकट्ठा करो।", "ja": "ゴールドを集めよう。バフを使って生き残ろう。", "zh": "收集金币。使用增益生存。", "ko": "골드를 모으세요. 버프를 사용하여 생존하세요.", "ar": "اجمع الذهب. استخدم المكافآت للبقاء."},
	"TUTORIAL_CONTROLS_TITLE": {"en": "CONTROLS", "tr": "KONTROLLER", "es": "CONTROLES", "pt": "CONTROLES", "fr": "CONTRÔLES", "de": "STEUERUNG", "hi": "नियंत्रण", "ja": "操作", "zh": "控制", "ko": "조작", "ar": "التحكم"},
	"TUTORIAL_CONTROLS_DESC": {"en": "SWIPE in the direction you want to move.", "tr": "Hareket etmek icin parmagini gitmek istedigin yone dogru KAYDIR.", "es": "DESLIZA para moverte.", "pt": "DESLIZE para mover.", "fr": "GLISSEZ pour bouger.", "de": "WISCHEN zum Bewegen.", "hi": "स्वाइप करें।", "ja": "スワイプして移動。", "zh": "滑动移动。", "ko": "스와이프하여 이동.", "ar": "اسحب للتحرك."},
	"NEXT": {"en": "NEXT >", "tr": "ILERI >", "es": "SIGUIENTE >", "pt": "PRÓXIMO >", "fr": "SUIVANT >", "de": "WEITER >", "hi": "अगला >", "ja": "次へ >", "zh": "下一步 >", "ko": "다음 >", "ar": "التالي >"},
	"LETS_START": {"en": "PLAY!", "tr": "BASLA!", "es": "¡JUGAR!", "pt": "JOGAR!", "fr": "JOUER!", "de": "START!", "hi": "खेलें!", "ja": "プレイ！", "zh": "开始！", "ko": "시작!", "ar": "ابدأ!"},

	# --- MISSIONS ---
	# --- MISSIONS ---
	"M_COLLECT_COINS_DESC": {"en": "COLLECT COINS", "tr": "ALTIN TOPLA", "es": "RECOGER ORO", "pt": "COLETAR OURO", "fr": "COLLECTER OR", "de": "GOLD SAMMELN", "hi": "सिक्के एकत्र करें", "ja": "コイン収集", "zh": "收集金币", "ko": "코인 수집", "ar": "اجمع الذهب"},
	"M_RUNNER_DESC": {"en": "RUNNER", "tr": "KOSUCU", "es": "CORREDOR", "pt": "CORREDOR", "fr": "COUREUR", "de": "LÄUFER", "hi": "धावक", "ja": "ランナー", "zh": "跑者", "ko": "러너", "ar": "عداء"},
	"M_DAILY_GOLD_DESC": {"en": "DAILY GOLD", "tr": "GUNLUK ALTIN", "es": "ORO DIARIO", "pt": "OURO DIÁRIO", "fr": "OR QUOTIDIEN", "de": "TÄGLICHES GOLD", "hi": "दैनिक सोना", "ja": "デイリーゴールド", "zh": "每日金币", "ko": "일일 골드", "ar": "ذهب يومي"},
	"M_DAILY_WALKER_DESC": {"en": "DAILY WALKER", "tr": "GUNLUK YURUYUS", "es": "CAMINANTE", "pt": "CAMINHANTE", "fr": "MARCHEUR", "de": "WANDERER", "hi": "वॉकर", "ja": "ウォーカー", "zh": "步行者", "ko": "워커", "ar": "ماشي يومي"},

	# --- LEADERBOARD & STATS ---
	"LOADING": {"en": "LOADING...", "tr": "YUKLENIYOR...", "es": "CARGANDO...", "pt": "CARREGANDO...", "fr": "CHARGEMENT...", "de": "LADEN...", "hi": "लोड हो रहा है...", "ja": "読み込み中...", "zh": "加载中...", "ko": "로딩 중...", "ar": "جار التحميل..."},
	"RETRY": {"en": "RETRY", "tr": "TEKRAR", "es": "REINTENTAR", "pt": "TENTAR", "fr": "RÉESSAYER", "de": "NOCHMAL", "hi": "पुनः प्रयास", "ja": "リトライ", "zh": "重试", "ko": "재시도", "ar": "إعادة المحاولة"},
	"FAILED_TO_LOAD": {"en": "FAILED TO LOAD", "tr": "YUKLENEMEDI", "es": "ERROR CARGA", "pt": "ERRO AO CARREGAR", "fr": "ÉCHEC CHARGEMENT", "de": "LADEFEHLER", "hi": "विफल", "ja": "読み込み失敗", "zh": "加载失败", "ko": "로딩 실패", "ar": "فشل التحميل"},
	"NO_SCORES_YET": {"en": "NO SCORES YET", "tr": "HENUZ SKOR YOK", "es": "SIN PUNTOS", "pt": "SEM PONTOS", "fr": "AUCUN SCORE", "de": "KEINE PUNKTE", "hi": "कोई स्कोर नहीं", "ja": "スコアなし", "zh": "暂无分数", "ko": "기록 없음", "ar": "لا توجد نتائج"},
	"BEST": {"en": "BEST:", "tr": "EN IYI:", "es": "MEJOR:", "pt": "MELHOR:", "fr": "MEILLEUR:", "de": "BESTE:", "hi": "सर्वश्रेष्ठ:", "ja": "ベスト:", "zh": "最佳:", "ko": "최고:", "ar": "الأفضل:"},
	"SAVED": {"en": "SAVED!", "tr": "KAYDEDILDI!", "es": "¡GUARDADO!", "pt": "SALVO!", "fr": "SAUVEGARDÉ!", "de": "GESPEICHERT!", "hi": "सहेजा गया!", "ja": "保存しました！", "zh": "已保存！", "ko": "저장됨!", "ar": "تم الحفظ!"},
	"NAME": {"en": "NAME", "tr": "ISIM", "es": "NOMBRE", "pt": "NOME", "fr": "NOM", "de": "NAME", "hi": "नाम", "ja": "名前", "zh": "名字", "ko": "이름", "ar": "الاسم"},
	"TIME": {"en": "TIME", "tr": "SURE", "es": "TIEMPO", "pt": "TEMPO", "fr": "TEMPS", "de": "ZEIT", "hi": "समय", "ja": "時間", "zh": "时间", "ko": "시간", "ar": "الوقت"},
	"MIN": {"en": "min", "tr": "dk", "es": "min", "pt": "min", "fr": "min", "de": "Min", "hi": "मिन", "ja": "分", "zh": "分", "ko": "분", "ar": "دقيقة"},
	"COLLECTED_COINS": {"en": "Total Gold", "tr": "Toplam Altin", "es": "Oro Total", "pt": "Ouro Total", "fr": "Or Total", "de": "Gesamtgold", "hi": "कुल सोना", "ja": "総ゴールド", "zh": "总金币", "ko": "총 골드", "ar": "مجموع الذهب"},
	"SKINS_OWNED": {"en": "Skins Owned", "tr": "Kostumler", "es": "Aspectos", "pt": "Skins", "fr": "Skins", "de": "Skins", "hi": "Skins", "ja": "所持スキン", "zh": "拥有皮肤", "ko": "보유 스킨", "ar": "جلود مملوكة"},
	"TOTAL_GAMES": {"en": "Total Games", "tr": "Toplam Oyun", "es": "Partidas", "pt": "Partidas", "fr": "Parties", "de": "Spiele", "hi": "कुल खेल", "ja": "総ゲーム数", "zh": "总局数", "ko": "총 게임", "ar": "مجموع الألعاب"},
	
	"MAX_HEALTH": {"en": "Max Health", "tr": "Maks Can", "es": "Salud Máx", "pt": "Saúde Máx", "fr": "Santé Max", "de": "Max HP", "hi": "अधिकतम स्वास्थ्य", "ja": "最大体力", "zh": "最大生命", "ko": "최대 체력", "ar": "الصحة القصوى"},
	"SCORE_VALUE": {"en": "Score Value", "tr": "Skor Degeri", "es": "Valor Puntos", "pt": "Valor Pontos", "fr": "Valeur Score", "de": "Punktwert", "hi": "स्कोर मान", "ja": "スコア値", "zh": "分数价值", "ko": "점수 가치", "ar": "قيمة النقاط"},
	"LUCK": {"en": "Luck", "tr": "Sans", "es": "Suerte", "pt": "Sorte", "fr": "Chance", "de": "Glück", "hi": "भाग्य", "ja": "運", "zh": "幸运", "ko": "행운", "ar": "الحظ"},
	"MAXED": {"en": "MAXED", "tr": "MAKS", "es": "MÁX", "pt": "MÁX", "fr": "MAX", "de": "MAX", "hi": "पूर्ण", "ja": "最大", "zh": "已满", "ko": "최대", "ar": "أقصى"},
	"MISSIONS": {"en": "MISSIONS", "tr": "GOREVLER", "es": "MISIONES", "pt": "MISSÕES", "fr": "MISSIONS", "de": "MISSIONEN", "hi": "मिशन", "ja": "ミッション", "zh": "任务", "ko": "미션", "ar": "مهام"},
	"DONE": {"en": "DONE", "tr": "TAMAM", "es": "HECHO", "pt": "FEITO", "fr": "FAIT", "de": "FERTIG", "hi": "ho gaya", "ja": "完了", "zh": "完成", "ko": "완료", "ar": "تم"},
	"COMBO_LOST": {"en": "COMBO LOST", "tr": "KOMBO BITTI", "es": "COMBO PERDIDO", "pt": "COMBO PERDIDO", "fr": "COMBO PERDU", "de": "KOMBO VERLOREN", "hi": "कॉम्बो खो गया", "ja": "コンボ終了", "zh": "连击中断", "ko": "콤보 끊김", "ar": "خسارة الكومبو"},
	"LEVEL_SHORT": {"en": "LVL", "tr": "LVL", "es": "NIV", "pt": "NIV", "fr": "NIV", "de": "LVL", "hi": "LVL", "ja": "LV", "zh": "级", "ko": "LV", "ar": "مستوى"},
	"RARITY": {"en": "RARITY", "tr": "NADIRLIK", "es": "RAREZA", "pt": "RARIDADE", "fr": "RARETÉ", "de": "SELTENHEIT", "hi": "दुर्लभता", "ja": "レア度", "zh": "稀有度", "ko": "희귀도", "ar": "ندرة"},
	"NOT_ENOUGH": {"en": "NOT ENOUGH", "tr": "YETERSIZ", "es": "NO BASTA", "pt": "INSUFICIENTE", "fr": "PAS ASSEZ", "de": "NICHT GENUG", "hi": "काफी नहीं", "ja": "不足", "zh": "不足", "ko": "부족", "ar": "غير كاف"},
	"RARITY_COMMON": {"en": "COMMON", "tr": "SIRADAN", "es": "COMÚN", "pt": "COMUM", "fr": "COMMUN", "de": "GEWÖHNLICH", "hi": "सामान्य", "ja": "コモン", "zh": "普通", "ko": "일반", "ar": "شائع"},
	"RARITY_RARE": {"en": "RARE", "tr": "NADIR", "es": "RARO", "pt": "RARO", "fr": "RARE", "de": "SELTEN", "hi": "दुर्लभ", "ja": "レア", "zh": "稀有", "ko": "희귀", "ar": "نادر"},
	"RARITY_EPIC": {"en": "EPIC", "tr": "EPIK", "es": "ÉPICO", "pt": "ÉPICO", "fr": "ÉPIQUE", "de": "EPISCH", "hi": "महाकाव्य", "ja": "エピック", "zh": "史诗", "ko": "에픽", "ar": "ملحمي"},
	"RARITY_LEGENDARY": {"en": "LEGENDARY", "tr": "EFSANE", "es": "LEGENDARIO", "pt": "LENDÁRIO", "fr": "LÉGENDAIRE", "de": "LEGENDÄR", "hi": "पौराणिक", "ja": "レジェンド", "zh": "传说", "ko": "전설", "ar": "أسطوري"},
	"RARITY_MYTHIC": {"en": "MYTHIC", "tr": "MITIK", "es": "MÍTICO", "pt": "MÍTICO", "fr": "MYTHIQUE", "de": "MYTHISCH", "hi": "पौराणिक", "ja": "ミシック", "zh": "神话", "ko": "신화", "ar": "خرافي"},
	"RARITY_DEFAULT": {"en": "DEFAULT", "tr": "STANDART", "es": "DEFECTO", "pt": "PADRÃO", "fr": "DÉFAUT", "de": "STANDARD", "hi": "डिफ़ॉल्ट", "ja": "デフォルト", "zh": "默认", "ko": "기본", "ar": "افتراضي"},
	
	# YENİ METİNLER
	"MODE_ENDLESS": {"en": "ENDLESS RUN", "tr": "SONSUZ KOSU", "es": "CORRIDA INFINITA", "pt": "CORRIDA INFINITA", "fr": "COURSE INFINIE", "de": "ENDLOSLAUF", "hi": "अंतहीन दौड़", "ja": "エンドレスラン", "zh": "无尽奔跑", "ko": "무한 러닝", "ar": "جري لا نهائي"},
	"MODE_CAMPAIGN": {"en": "CAMPAIGN", "tr": "BOLUM", "es": "CAMPAÑA", "pt": "CAMPANHA", "fr": "CAMPAGNE", "de": "KAMPAGNE", "hi": "अभियान", "ja": "キャンペーン", "zh": "战役", "ko": "캠페인", "ar": "حملة"},
	"MODE_SELECT": {"en": "CHOOSE MODE", "tr": "MOD SEC", "es": "ELEGIR MODO", "pt": "ESCOLHER MODO", "fr": "CHOISIR MODE", "de": "MODUS WÄHLEN", "hi": "मोड चुनें", "ja": "モード選択", "zh": "选择模式", "ko": "모드 선택", "ar": "اختر الوضع"},
	"CAMPAIGN_SELECT": {"en": "SELECT LEVEL", "tr": "BOLUM SEC", "es": "SELECCIONAR NIVEL", "pt": "SELECIONAR NÍVEL", "fr": "CHOISIR NIVEAU", "de": "LEVEL WÄHLEN", "hi": "स्तर चुनें", "ja": "レベル選択", "zh": "选择关卡", "ko": "레벨 선택", "ar": "اختر المستوى"},
	"LEVELS": {"en": "LEVELS", "tr": "BOLUMLER", "es": "NIVELES", "pt": "NÍVEIS", "fr": "NIVEAUX", "de": "LEVELS", "hi": "स्तर", "ja": "レベル", "zh": "关卡", "ko": "레벨", "ar": "المستويات"},
	"BACK": {"en": "BACK", "tr": "GERI", "es": "ATRÁS", "pt": "VOLTAR", "fr": "RETOUR", "de": "ZURÜCK", "hi": "वापस", "ja": "戻る", "zh": "返回", "ko": "뒤로", "ar": "رجوع"},
	"LOCKED": {"en": "LOCKED", "tr": "KILITLI", "es": "BLOQUEADO", "pt": "BLOQUEADO", "fr": "VERROUILLÉ", "de": "GESPERRT", "hi": "बंद है", "ja": "ロック中", "zh": "已锁定", "ko": "잠김", "ar": "مقفل"},
	"LEVEL_HINT_1": {"en": "Drag and hold to move to the Exit.", "tr": "Cikisa gitmek icin surukle ve tut.", "es": "Arrastra para moverte.", "pt": "Arraste para mover.", "fr": "Glissez pour bouger.", "de": "Ziehen zum Bewegen.", "hi": "खींचें और पकड़ें।", "ja": "ドラッグして移動。", "zh": "拖动以移动。", "ko": "드래그하여 이동.", "ar": "اسحب واثبت للتحرك"},
	"LEVEL_HINT_2": {"en": "Collect Gold to increase score.", "tr": "Skoru artirmak icin Altin topla.", "es": "Recoge oro para puntos.", "pt": "Colete ouro para pontos.", "fr": "Collectez l'or pour le score.", "de": "Sammle Gold für Punkte.", "hi": "सोना इकट्ठा करें।", "ja": "ゴールドを集めてスコアアップ。", "zh": "收集金币增加分数。", "ko": "골드를 모아 점수를 올리세요.", "ar": "اجمع الذهب لزيادة النقاط"},
	"LEVEL_HINT_3": {"en": "You can only move in 4 directions.", "tr": "Sadece 4 ana yone gidebilirsin.", "es": "Solo 4 direcciones.", "pt": "Apenas 4 direções.", "fr": "Seulement 4 directions.", "de": "Nur 4 Richtungen.", "hi": "केवल 4 दिशाएं।", "ja": "4方向にのみ移動可能。", "zh": "只能向4个方向移动。", "ko": "4방향으로만 이동 가능합니다.", "ar": "يمكنك التحرك في 4 اتجاهات فقط"},
	"LEVEL_HINT_4": {"en": "Navigate around the walls.", "tr": "Duvarlarin etrafindan dolas.", "es": "Navega por las paredes.", "pt": "Navegue pelas paredes.", "fr": "Naviguez autour des murs.", "de": "Geh um Wände herum.", "hi": "दीवारों के चारों ओर नेविगेट करें।", "ja": "壁を回避して進もう。", "zh": "绕过墙壁。", "ko": "벽을 피해 이동하세요.", "ar": "تحرك حول الجدران"},
	"LEVEL_HINT_5": {"en": "Enemies move after you move.", "tr": "Dusmanlar sen hareket edince oynar.", "es": "Enemigos se mueven tras ti.", "pt": "Inimigos movem depois de você.", "fr": "Ennemis bougent après vous.", "de": "Gegner bewegen sich nach dir.", "hi": "दुश्मन आपके बाद चलते हैं।", "ja": "敵はあなたが動いた後に動く。", "zh": "敌人在你移动后移动。", "ko": "적은 당신이 움직인 후에 움직입니다.", "ar": "الأعداء يتحركون بعدك"},
	"LEVEL_HINT_6": {"en": "Use walls to block enemies.", "tr": "Dusmanlari engellemek icin duvari kullan.", "es": "Usa muros para bloquear.", "pt": "Use paredes para bloquear.", "fr": "Utilisez les murs pour bloquer.", "de": "Nutze Wände zum Blocken.", "hi": "दुश्मनों को रोकने के लिए दीवारों का उपयोग करें।", "ja": "壁を使って敵を防ごう。", "zh": "利用墙壁阻挡敌人。", "ko": "벽을 이용해 적을 막으세요.", "ar": "استخدم الجدران لصد الأعداء"},
	"LEVEL_HINT_7": {"en": "Traps toggle every turn.", "tr": "Tuzaklar her tur acilip kapanir.", "es": "Trampas cambian cada turno.", "pt": "Armadilhas mudam a cada turno.", "fr": "Pièges changent chaque tour.", "de": "Fallen wechseln jede Runde.", "hi": "जाल हर मोड़ पर टॉगल करते हैं।", "ja": "罠は毎ターン切り替わります。", "zh": "陷阱每回合切换。", "ko": "함정은 매 턴 바뀝니다.", "ar": "الفخاخ تتبدل كل دور"},
	"LEVEL_HINT_8": {"en": "Sleepy enemies wake up close.", "tr": "Uykucular yaklasinca uyanir.", "es": "Dormidos despiertan cerca.", "pt": "Dorminhocos acordam perto.", "fr": "Ennemis dorment, réveil proche.", "de": "Schläfer wachen nah auf.", "hi": "सोते हुए दुश्मन पास में जागते हैं।", "ja": "眠る敵は近くで目覚める。", "zh": "熟睡的敌人在靠近时醒来。", "ko": "잠자는 적은 가까이 오면 깹니다.", "ar": "الأعداء النائمون يستيقظون عند الاقتراب"},
	"LEVEL_HINT_9": {"en": "Turrets aim before firing.", "tr": "Taretler ates etmeden nisan alir.", "es": "Torretas apuntan antes.", "pt": "Torres miram antes.", "fr": "Tourelles visent avant.", "de": "Türme zielen vorher.", "hi": "बुर्ज फायर करने से पहले निशाना लगाते हैं।", "ja": "タレットは発射前に狙いを定めます。", "zh": "炮塔在开火前瞄准。", "ko": "포탑은 발사 전 조준합니다.", "ar": "الأبراج تصوب قبل الإطلاق"},
	"LEVEL_HINT_10": {"en": "Good luck on your journey!", "tr": "Maceranda bol sans!", "es": "¡Buena suerte!", "pt": "Boa sorte!", "fr": "Bonne chance!", "de": "Viel Glück!", "hi": "शुभकामनाएं!", "ja": "旅の幸運を祈る！", "zh": "祝你好运！", "ko": "행운을 빕니다!", "ar": "حظاً سعيداً في رحلتك"},
	
	"PLAY_TUTORIAL": {"en": "PLAY TUTORIAL", "tr": "OGRETICI OYNA", "es": "JUGAR TUTORIAL", "pt": "JOGAR TUTORIAL", "fr": "JOUER TUTORIEL", "de": "TUTORIAL SPIELEN", "hi": "ट्यूटोरियल खेलें", "ja": "チュートリアルをプレイ", "zh": "玩教程", "ko": "튜토리얼 플레이", "ar": "لعب التعليمي"},
	
	"TUTORIAL_MOVE": {"en": "Swipe your finger to move.", "tr": "Hareket etmek icin parmagini ekranda kaydir.", "es": "Desliza el dedo para moverte.", "pt": "Deslize o dedo para mover.", "fr": "Glissez le doigt pour bouger.", "de": "Wische mit dem Finger zum Bewegen.", "hi": "ले जाने के लिए अपनी उंगली स्वाइप करें।", "ja": "指をスワイプして移動します。", "zh": "滑动手指移动。", "ko": "손가락을 스와이프하여 이동하세요.", "ar": "مرر إصبعك للتحرك"},
	"TUTORIAL_RED_ENEMY": {"en": "Red enemies chase you! Avoid them.", "tr": "Kirmizi dusmanlar seni kovalar! Onlardan kac.", "es": "¡Los rojos te persiguen! Evítalos.", "pt": "Vermelhos te perseguem! Evite.", "fr": "Les rouges pourchassent! Évitez.", "de": "Rote jagen dich! Meide sie.", "hi": "लाल दुश्मन आपका पीछा करते हैं! उनसे बचें।", "ja": "赤い敵は追いかけてきます！避けてください。", "zh": "红色敌人追逐你！避开它们。", "ko": "빨간 적은 당신을 쫓아옵니다! 피하세요.", "ar": "الأعداء الحمر يطاردونك! تجنبهم"},
	"TUTORIAL_SLEEPY": {"en": "Brown enemies sleep. Don't get close!", "tr": "Kahverengi dusmanlar uyur. Yaklasma!", "es": "Los marrones duermen. ¡No te acerques!", "pt": "Marrons dormem. Não chegue perto!", "fr": "Les bruns dorment. Ne pas approcher!", "de": "Braune schlafen. Nicht nähern!", "hi": "भूरे दुश्मन सोते हैं। करीब मत जाओ!", "ja": "茶色の敵は眠ります。近づかないで！", "zh": "棕色敌人睡觉。别靠近！", "ko": "갈색 적은 잠을 잡니다. 가까이 가지 마세요!", "ar": "الأعداء البنيون ينامون. لا تقترب!"},
	"TUTORIAL_FIND": {"en": "Find the Portal to escape.", "tr": "Kacmak icin Portali bul.", "es": "Encuentra el Portal.", "pt": "Encontre o Portal.", "fr": "Trouvez le Portail.", "de": "Finde das Portal.", "hi": "पोर्टल का पता लगाएं।", "ja": "ポータルを見つけてください。", "zh": "找到传送门。", "ko": "포털을 찾으세요.", "ar": "ابحث عن البوابة للهرب"},
}

func get_text(key: String) -> String:
	if TEXTS.has(key):
		return TEXTS[key].get(language, TEXTS[key]["en"])
	return key




func _input(event):
	# Kullanıcı isteği üzerine F8 yerine 8 tuşu
	if event is InputEventKey and event.pressed and event.keycode == KEY_8:
		take_screenshot()

func take_screenshot():
	await RenderingServer.frame_post_draw
	
	var viewport = get_viewport()
	if not viewport:
		return
		
	var texture = viewport.get_texture()
	if not texture:
		return
		
	var image = texture.get_image()
	if not image or image.is_empty():
		print("Screenshot failed: Image is empty")
		return
	
	var time = Time.get_datetime_dict_from_system()
	var filename = "user://screenshot_%d-%02d-%02d_%02d-%02d-%02d.png" % [time.year, time.month, time.day, time.hour, time.minute, time.second]
	
	var err = image.save_png(filename)
	if err == OK:
		var global_path = ProjectSettings.globalize_path(filename)
		print("Screenshot saved to: ", global_path)
	else:
		print("Failed to save screenshot. Error: ", err)
