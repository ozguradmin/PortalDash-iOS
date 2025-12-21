extends Node

# ==============================================================================
# MICRO ROGUE: SKIN MANAGER
# CLEANED VERSION (No invalid characters)
# ==============================================================================

# Skin data structure
const SKINS = {
	# --- DEFAULT ---
	"default": {
		"name_en": "Portal Dash", "name_tr": "Mezar Kosucusu", "name_es": "Portal Dash", "name_pt": "Portal Dash", "name_fr": "Portal Dash", "name_de": "Portal Dash", "name_hi": "तैयार", "name_ja": "ポータルダッシュ", "name_zh": "传送门冲刺", "name_ko": "포털 대시", "name_ar": "بورتال داش",
		"price": 0, "rarity": "default",
		"colors": {"main": Color(0.0, 0.7, 1.0), "dark": Color(0.0, 0.4, 0.7), "mask": Color(0.1, 0.1, 0.3), "eyes": Color(1, 1, 1), "outline": Color(0, 0, 0), "hp_bg": Color(0.1, 0.1, 0.1, 0.8), "hp_fill": Color(0.2, 0.9, 0.4)}
	},
	# --- COMMON (500-1000) ---
	"crimson_knight": {
		"name_en": "Crimson Knight", "name_tr": "Kizil Sovalye", "name_es": "Caballero Rojo", "name_pt": "Cavaleiro Carmesim", "name_fr": "Chevalier Rouge", "name_de": "Purpurritter", "name_hi": "क्रिमसन नाइट", "name_ja": "深紅の騎士", "name_zh": "深红骑士", "name_ko": "진홍의 기사", "name_ar": "الفارس القرمزي",
		"price": 500, "rarity": "common"
	},
	"toxic_zombie": {
		"name_en": "Toxic Zombie", "name_tr": "Zehirli Zombi", "name_es": "Zombi Tóxico", "name_pt": "Zumbi Tóxico", "name_fr": "Zombie Toxique", "name_de": "Giftzombie", "name_hi": "जहरीला ज़ोंबी", "name_ja": "猛毒ゾンビ", "name_zh": "剧毒僵尸", "name_ko": "독성 좀비", "name_ar": "زومبي سام",
		"price": 750, "rarity": "common"
	},
	"cyber_bot": {
		"name_en": "Cyber-Bot X99", "name_tr": "Siber-Bot X99", "name_es": "Ciber-Bot X99", "name_pt": "Ciber-Robô", "name_fr": "Cyber-Bot X99", "name_de": "Cyber-Bot X99", "name_hi": "साइबर-बोट", "name_ja": "サイバーボット", "name_zh": "赛博机器人", "name_ko": "사이버 봇", "name_ar": "روبوت إلكتروني",
		"price": 850, "rarity": "common"
	},
	"pumpkin_king": {
		"name_en": "Pumpkin King", "name_tr": "Balkabagi Kral", "name_es": "Rey Calabaza", "name_pt": "Rei Abóbora", "name_fr": "Roi Citrouille", "name_de": "Kürbiskönig", "name_hi": "कद्दू राजा", "name_ja": "パンプキンキング", "name_zh": "南瓜王", "name_ko": "호박 왕", "name_ar": "ملك اليقطين",
		"price": 950, "rarity": "common"
	},
	# --- RARE (1500-2500) ---
	"grand_wizard": {
		"name_en": "Grand Wizard", "name_tr": "Ulu Buyucu", "name_es": "Gran Mago", "name_pt": "Grão-Mago", "name_fr": "Grand Sorcier", "name_de": "Erzmagier", "name_hi": "महा जादूगर", "name_ja": "大魔導士", "name_zh": "大巫师", "name_ko": "대마법사", "name_ar": "الساحر الكبير",
		"price": 1500, "rarity": "rare"
	},
	"steampunk_diver": {
		"name_en": "Steampunk Diver", "name_tr": "Steampunk Dalgic", "name_es": "Buzo Steampunk", "name_pt": "Mergulhador Steam", "name_fr": "Plongeur Steam", "name_de": "Steampunk-Taucher", "name_hi": "स्टीमपंक गोताखोर", "name_ja": "スチームパンク", "name_zh": "蒸汽朋克潜水员", "name_ko": "스팀펑크 다이버", "name_ar": "غواص بخاري",
		"price": 1750, "rarity": "rare"
	},
	"berserker": {
		"name_en": "Berserker", "name_tr": "Viking Savascisi", "name_es": "Berserker", "name_pt": "Berserker", "name_fr": "Berserker", "name_de": "Berserker", "name_hi": "बर्साकर", "name_ja": "バーサーカー", "name_zh": "狂战士", "name_ko": "광전사", "name_ar": "هائج",
		"price": 2000, "rarity": "rare"
	},
	"desperado": {
		"name_en": "Desperado", "name_tr": "Col Haydutu", "name_es": "Desperado", "name_pt": "Desperado", "name_fr": "Desperado", "name_de": "Desperado", "name_hi": "डेस्पिराडो", "name_ja": "デスペラード", "name_zh": "亡命之徒", "name_ko": "무법자", "name_ar": "خارج عن القانون",
		"price": 2200, "rarity": "rare"
	},
	"the_mimic": {
		"name_en": "The Mimic", "name_tr": "Canli Sandik", "name_es": "Mímico", "name_pt": "Mímico", "name_fr": "Mimique", "name_de": "Mimic", "name_hi": "नकलची", "name_ja": "ミミック", "name_zh": "拟态怪", "name_ko": "미믹", "name_ar": "المقلد",
		"price": 2400, "rarity": "rare"
	},
	# --- EPIC (3000-5000) ---
	"the_signal": {
		"name_en": "The Signal", "name_tr": "Trafik Isigi", "name_es": "La Señal", "name_pt": "O Sinal", "name_fr": "Le Signal", "name_de": "Das Signal", "name_hi": "संकेत", "name_ja": "シグナル", "name_zh": "信号灯", "name_ko": "신호", "name_ar": "الإشارة",
		"price": 3200, "rarity": "epic"
	},
	"venus_flytrap": {
		"name_en": "Venus Flytrap", "name_tr": "Etcil Bitki", "name_es": "Venus Atrapamoscas", "name_pt": "Planta Carnívora", "name_fr": "Dionée", "name_de": "Venusfliegenfalle", "name_hi": "वीनस फ्लाईट्रैप", "name_ja": "ハエトリグサ", "name_zh": "捕蝇草", "name_ko": "파리지옥", "name_ar": "صائد الذباب",
		"price": 3500, "rarity": "epic"
	},
	"samurai_oni": {
		"name_en": "Demon Warlord", "name_tr": "Samuray Oni", "name_es": "Señor Demonio", "name_pt": "Lorde Demônio", "name_fr": "Seigneur Démon", "name_de": "Dämonenfürst", "name_hi": "दानव सरदार", "name_ja": "鬼侍", "name_zh": "鬼武者", "name_ko": "오니 사무라이", "name_ar": "أمير الشياطين",
		"price": 4000, "rarity": "epic"
	},
	"frostbite": {
		"name_en": "Frostbite", "name_tr": "Buz Golemi", "name_es": "Congelación", "name_pt": "Congelante", "name_fr": "Gelure", "name_de": "Frostbeule", "name_hi": "फ्रॉस्टबाइट", "name_ja": "フロストバイト", "name_zh": "冻伤", "name_ko": "동상", "name_ar": "قضمة الصقيع",
		"price": 4200, "rarity": "epic"
	},
	"cctv": {
		"name_en": "CCTV Guardian", "name_tr": "Gozetleme Kulesi", "name_es": "Guardián CCTV", "name_pt": "Guardião CCTV", "name_fr": "Gardien CCTV", "name_de": "Kamera-Wächter", "name_hi": "सीसीटीवी अभिभावक", "name_ja": "監視カメラ", "name_zh": "监控守卫", "name_ko": "CCTV 수호자", "name_ar": "حارس الكاميرا",
		"price": 4500, "rarity": "epic"
	},
	"demon_hunter": {
		"name_en": "Demon Hunter", "name_tr": "Iblis Avcisi", "name_es": "Cazador Demonios", "name_pt": "Caçador Demônios", "name_fr": "Chasseur Démons", "name_de": "Dämonenjäger", "name_hi": "दानव शिकारी", "name_ja": "デーモンハンター", "name_zh": "恶魔猎手", "name_ko": "악마 사냥꾼", "name_ar": "صائد الشياطين",
		"price": 4800, "rarity": "epic"
	},
	"lightning_ninja": {
		"name_en": "Lightning Ninja", "name_tr": "Yildirim Ninjasi", "name_es": "Ninja Rayo", "name_pt": "Ninja Relâmpago", "name_fr": "Ninja Éclair", "name_de": "Blitz-Ninja", "name_hi": "बिजली निंजा", "name_ja": "雷忍者", "name_zh": "闪电忍者", "name_ko": "번개 닌자", "name_ar": "نينجا البرق",
		"price": 5000, "rarity": "epic"
	},
	"thorfinn": {
		"name_en": "Revenge Viking", "name_tr": "Intikamci Thorfinn", "name_es": "Vikingo Vengador", "name_pt": "Viking Vingador", "name_fr": "Viking Vengeur", "name_de": "Rache-Wikinger", "name_hi": "बदला लेने वाला", "name_ja": "復讐のバイキング", "name_zh": "复仇维京人", "name_ko": "복수의 바이킹", "name_ar": "فايكنغ الانتقام",
		"price": 5000, "rarity": "epic"
	},
	# --- LEGENDARY (7500+) ---
	"ufo_pilot": {
		"name_en": "UFO Pilot", "name_tr": "UFO Pilotu", "name_es": "Piloto OVNI", "name_pt": "Piloto OVNI", "name_fr": "Pilote OVNI", "name_de": "UFO-Pilot", "name_hi": "यूएफओ पायलट", "name_ja": "UFOパイロット", "name_zh": "UFO飞行员", "name_ko": "UFO 조종사", "name_ar": "طيار UFO",
		"price": 7500, "rarity": "legendary"
	},
	"spectral_ghost": {
		"name_en": "Spectral Ghost", "name_tr": "Hayalet Korsan", "name_es": "Fantasma Espectral", "name_pt": "Fantasma Espectral", "name_fr": "Fantôme Spectral", "name_de": "Spektra-Geist", "name_hi": "भूत", "name_ja": "スペクトルゴースト", "name_zh": "幽灵", "name_ko": "유령", "name_ar": "شبح الطيف",
		"price": 8000, "rarity": "legendary"
	},
	"medusa": {
		"name_en": "Gorgon Queen", "name_tr": "Medusa", "name_es": "Reina Gorgona", "name_pt": "Rainha Górgona", "name_fr": "Reine Gorgone", "name_de": "Gorgonen-Königin", "name_hi": "गोरगन रानी", "name_ja": "ゴルゴンクイーン", "name_zh": "美杜莎", "name_ko": "고르곤 여왕", "name_ar": "ميدوسا",
		"price": 9000, "rarity": "legendary"
	},
	"anubis": {
		"name_en": "Anubis", "name_tr": "Olum Tanrisi", "name_es": "Anubis", "name_pt": "Anúbis", "name_fr": "Anubis", "name_de": "Anubis", "name_hi": "अनुबिस", "name_ja": "アヌビス", "name_zh": "阿努比斯", "name_ko": "아누비스", "name_ar": "أنوبيس",
		"price": 10000, "rarity": "legendary"
	},
	"dark_knight": {
		"name_en": "The Dark Knight", "name_tr": "Kara Sovalye", "name_es": "Caballero Oscuro", "name_pt": "Cavaleiro das Trevas", "name_fr": "Chevalier Noir", "name_de": "Dunkler Ritter", "name_hi": "डार्क नाइट", "name_ja": "ダークナイト", "name_zh": "黑暗骑士", "name_ko": "다크 나이트", "name_ar": "فارس الظلام",
		"price": 12000, "rarity": "legendary"
	},
	# --- MYTHIC (PAHALI ÖZEL SKINLER) ---
	"retro_tv": {
		"name_en": "The Glitch", "name_tr": "Retro TV", "name_es": "El Glitch", "name_pt": "O Glitch", "name_fr": "Le Glitch", "name_de": "Der Glitch", "name_hi": "गड़बड़", "name_ja": "グリッチ", "name_zh": "故障", "name_ko": "글리치",
		"price": 15000, "rarity": "mythic"
	},
	"boombox_boy": {
		"name_en": "Boombox Boy", "name_tr": "Muzik Kutusu", "name_es": "Chico Boombox", "name_pt": "Garoto Boombox", "name_fr": "Garçon Boombox", "name_de": "Boombox-Junge", "name_hi": "बूमबॉक्स बॉय", "name_ja": "ブームボックス", "name_zh": "音响小子", "name_ko": "붐박스 보이",
		"price": 20000, "rarity": "mythic"
	},
	"chainsaw_hybrid": {
		"name_en": "Chainsaw Hybrid", "name_tr": "Testere Adam", "name_es": "Híbrido Motosierra", "name_pt": "Híbrido Motoserra", "name_fr": "Hybride Tronçonneuse", "name_de": "Kettensägen-Hybrid", "name_hi": "चेनसॉ हाइब्रिड", "name_ja": "チェーンソー男", "name_zh": "电锯人", "name_ko": "전기톱 하이브리드",
		"price": 25000, "rarity": "mythic"
	},
	"cosmic_emperor": {
		"name_en": "Cosmic Emperor", "name_tr": "Kozmik Imparator", "name_es": "Emperador Cósmico", "name_pt": "Imperador Cósmico", "name_fr": "Empereur Cosmique", "name_de": "Kosmischer Kaiser", "name_hi": "ब्रह्मांडीय सम्राट", "name_ja": "宇宙皇帝", "name_zh": "宇宙大帝", "name_ko": "우주 황제",
		"price": 30000, "rarity": "mythic"
	}
}

# Rarity colors for UI
const RARITY_COLORS = {
	"default": Color(0.7, 0.7, 0.7),
	"common": Color(0.5, 0.8, 0.5),
	"rare": Color(0.3, 0.5, 1.0),
	"epic": Color(0.7, 0.3, 0.9),
	"legendary": Color(1.0, 0.8, 0.0),
	"mythic": Color(1.0, 0.3, 0.5)
}

func get_skin_data(skin_id: String) -> Dictionary:
	if SKINS.has(skin_id):
		return SKINS[skin_id]
	return SKINS["default"]

func get_skin_name(skin_id: String) -> String:
	var skin = get_skin_data(skin_id)
	var key = "name_" + Global.language
	return skin.get(key, skin.get("name_en", "Unknown"))

func get_all_skins() -> Array:
	return SKINS.keys()

func get_rarity_color(rarity: String) -> Color:
	return RARITY_COLORS.get(rarity, Color.WHITE)

# Drawing function for character preview and in-game rendering
func draw_skin_preview(node: CanvasItem, center: Vector2, scale_input, skin_id: String, time: float, is_blinking: bool = false, alpha: float = 1.0):
	var s = Vector2(1, 1)
	if scale_input is float or scale_input is int:
		s = Vector2(scale_input, scale_input)
	elif scale_input is Vector2:
		s = scale_input
 
	var msec = float(Time.get_ticks_msec())
	
	# Helper to apply alpha to any color
	var apply_alpha = func(c: Color) -> Color:
		return Color(c.r, c.g, c.b, c.a * alpha)
 
	# Common Shadow (Base)
	var shadow_col = apply_alpha.call(Color(0,0,0,0.3))
	
	match skin_id:
		"default":
			var bounce = sin(time * 5.0) * 2.0 * s.y
			var c_main = apply_alpha.call(Color(0.0, 0.7, 1.0))
			var c_dark = apply_alpha.call(Color(0.0, 0.4, 0.7))
			var c_mask = apply_alpha.call(Color(0.1, 0.1, 0.3))
			var c_eyes = apply_alpha.call(Color(1, 1, 1))
			var c_outline = apply_alpha.call(Color(0, 0, 0))
 
			node.draw_rect(Rect2(center.x - 8*s.x, center.y + 16*s.y, 16*s.x, 4*s.y), shadow_col)
			node.draw_rect(Rect2(center + Vector2(-8, 12) * s, Vector2(6, 6) * s), c_dark)
			node.draw_rect(Rect2(center + Vector2(2, 12) * s, Vector2(6, 6) * s), c_dark)
			var body_pos = center + (Vector2(-7, 6) * s) + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(14, 10) * s), c_main)
			node.draw_rect(Rect2(center + (Vector2(-14, 8) * s) + Vector2(0, bounce), Vector2(5, 5) * s), c_main)
			node.draw_rect(Rect2(center + (Vector2(9, 8) * s) + Vector2(0, bounce), Vector2(5, 5) * s), c_main)
			var head_pos = center + (Vector2(-13, -14) * s) + Vector2(0, bounce)
			var head_size = Vector2(26, 24) * s
			node.draw_rect(Rect2(head_pos, head_size), c_main)
			node.draw_rect(Rect2(head_pos.x, head_pos.y + head_size.y - (4*s.y), head_size.x, 4*s.y), c_dark)
			node.draw_rect(Rect2(head_pos, head_size), c_outline, false, 2.0 * min(s.x, s.y))
			var mask_pos = Vector2(head_pos.x + (4*s.x), head_pos.y + (6*s.y))
			node.draw_rect(Rect2(mask_pos, Vector2(18, 12) * s), c_mask)
			if not is_blinking:
				node.draw_rect(Rect2(mask_pos.x + (2*s.x), mask_pos.y + (3*s.y), 4*s.x, 6*s.y), c_eyes)
				node.draw_rect(Rect2(mask_pos.x + (12*s.x), mask_pos.y + (3*s.y), 4*s.x, 6*s.y), c_eyes)

		"crimson_knight":
			var C_HERO_MAIN = apply_alpha.call(Color(0.75, 0.75, 0.75))
			var C_HERO_DARK = apply_alpha.call(Color(0.4, 0.4, 0.45))
			var C_MASK_BG = apply_alpha.call(Color(0.1, 0.1, 0.15))
			var C_EYES = apply_alpha.call(Color(1.0, 0.8, 0.0))
			var C_OUTLINE = apply_alpha.call(Color(0, 0, 0))
 
			var bounce = sin(msec / 200.0) * 2.0 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), C_HERO_DARK)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), C_HERO_DARK)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-7, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(14, 10)*s), C_HERO_MAIN)
			node.draw_rect(Rect2(body_pos.x + 5*s.x, body_pos.y + 2*s.y, 4*s.x, 6*s.y), C_HERO_DARK)
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-14, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_HERO_DARK)
			node.draw_rect(Rect2(center + Vector2(9, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_HERO_DARK)
 
			# E. KAFA
			var head_pos = center + Vector2(-13, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_HERO_MAIN)
			node.draw_rect(Rect2(head_pos.x, head_pos.y + 20*s.y, 26*s.x, 4*s.y), C_HERO_DARK)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_OUTLINE, false, 2.0 * s.x)
 
			# F. YÜZ / MASKE
			var mask_pos = Vector2(head_pos.x + 4*s.x, head_pos.y + 8*s.y)
			node.draw_rect(Rect2(mask_pos, Vector2(18, 8)*s), C_MASK_BG)
			node.draw_rect(Rect2(mask_pos.x + 3*s.x, mask_pos.y + 3*s.y, 5*s.x, 2*s.y), C_EYES)
			node.draw_rect(Rect2(mask_pos.x + 10*s.x, mask_pos.y + 3*s.y, 5*s.x, 2*s.y), C_EYES)

		"toxic_zombie":
			var C_HERO_MAIN = apply_alpha.call(Color(0.4, 0.6, 0.2))
			var C_HERO_DARK = apply_alpha.call(Color(0.2, 0.35, 0.1))
			var C_EYE_L = apply_alpha.call(Color(1, 0.2, 0.2))
			var C_EYE_R = apply_alpha.call(Color(0.9, 0.9, 0.8))
			var C_TZ_OUTLINE = apply_alpha.call(Color(0.1, 0.2, 0.0))
 
			var bounce = sin(msec / 150.0) * 1.5 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), C_HERO_DARK)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), C_HERO_MAIN)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-7, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(14, 10)*s), C_HERO_MAIN)
			node.draw_rect(Rect2(body_pos.x, body_pos.y + 6*s.y, 14*s.x, 4*s.y), C_HERO_DARK)
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-14, 9)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_HERO_MAIN)
			node.draw_rect(Rect2(center + Vector2(9, 7)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_HERO_MAIN)
 
			# E. KAFA
			var head_pos = center + Vector2(-13, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_HERO_MAIN)
			node.draw_rect(Rect2(head_pos.x + 16*s.x, head_pos.y, 8*s.x, 6*s.y), C_HERO_DARK)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_TZ_OUTLINE, false, 2.0 * s.x)
 
			# F. YÜZ
			var mask_pos = Vector2(head_pos.x + 4*s.x, head_pos.y + 8*s.y)
			node.draw_rect(Rect2(mask_pos, Vector2(18, 10)*s), C_HERO_DARK)
			node.draw_rect(Rect2(mask_pos.x + 2*s.x, mask_pos.y + 4*s.y, 4*s.x, 4*s.y), C_EYE_L)
			node.draw_rect(Rect2(mask_pos.x + 10*s.x, mask_pos.y + 2*s.y, 6*s.x, 6*s.y), C_EYE_R)

		"cyber_bot":
			var C_HERO_MAIN = apply_alpha.call(Color(0.6, 0.7, 0.8))
			var C_HERO_DARK = apply_alpha.call(Color(0.3, 0.35, 0.4))
			var C_ENERGY = apply_alpha.call(Color(0.0, 1.0, 1.0))
			var C_VISOR = apply_alpha.call(Color(1.0, 0.2, 0.2))
			var C_OUTLINE = apply_alpha.call(Color(0.1, 0.1, 0.2))
 
			var bounce = 0.0
			if int(msec / 100.0) % 2 != 0: bounce = 1.0 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-9, 12)*s, Vector2(7, 6)*s), C_HERO_DARK)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(7, 6)*s), C_HERO_DARK)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-7, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(14, 10)*s), C_HERO_MAIN)
			node.draw_rect(Rect2(body_pos.x + 5*s.x, body_pos.y + 3*s.y, 4*s.x, 4*s.y), C_ENERGY)
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-15, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_HERO_DARK)
			node.draw_rect(Rect2(center + Vector2(10, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_HERO_DARK)
 
			# E. KAFA
			var head_pos = center + Vector2(-13, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_HERO_MAIN)
			node.draw_rect(Rect2(head_pos.x + 4*s.x, head_pos.y - 6*s.y, 2*s.x, 6*s.y), C_HERO_DARK)
			node.draw_rect(Rect2(head_pos.x + 3*s.x, head_pos.y - 8*s.y, 4*s.x, 2*s.y), C_VISOR)
			node.draw_rect(Rect2(head_pos.x - 2*s.x, head_pos.y + 10*s.y, 2*s.x, 6*s.y), C_HERO_DARK)
			node.draw_rect(Rect2(head_pos.x + 26*s.x, head_pos.y + 10*s.y, 2*s.x, 6*s.y), C_HERO_DARK)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_OUTLINE, false, 2.0 * s.x)
 
			# F. YÜZ
			var mask_pos = Vector2(head_pos.x + 2*s.x, head_pos.y + 8*s.y)
			node.draw_rect(Rect2(mask_pos, Vector2(22, 8)*s), apply_alpha.call(Color(0.1, 0.1, 0.1)))
			node.draw_rect(Rect2(mask_pos.x + 2*s.x, mask_pos.y + 3*s.y, 18*s.x, 2*s.y), C_VISOR)

		"pumpkin_king":
			var C_HEAD = apply_alpha.call(Color(1.0, 0.5, 0.0))
			var C_SUIT = apply_alpha.call(Color(0.4, 0.1, 0.6))
			var C_GLOW = apply_alpha.call(Color(1.0, 0.9, 0.4))
			var C_STEM = apply_alpha.call(Color(0.2, 0.6, 0.1))
			var C_OUTLINE = apply_alpha.call(Color(0.2, 0.1, 0.0))
			var C_DARK = apply_alpha.call(Color(0.1, 0.1, 0.1))
 
			var bounce = sin(msec / 250.0) * 3.0 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), C_DARK)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), C_DARK)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-7, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(14, 10)*s), C_SUIT)
			node.draw_rect(Rect2(body_pos + Vector2(5, 2)*s, Vector2(4, 3)*s), C_DARK)
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-14, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_HEAD)
			node.draw_rect(Rect2(center + Vector2(9, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_HEAD)
 
			# E. KAFA
			var head_pos = center + Vector2(-13, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_HEAD)
			node.draw_rect(Rect2(head_pos + Vector2(10, -6)*s, Vector2(6, 6)*s), C_STEM)
			node.draw_rect(Rect2(head_pos.x + 6*s.x, head_pos.y, 1*s.x, 24*s.y), apply_alpha.call(Color(0.8, 0.4, 0.0)))
			node.draw_rect(Rect2(head_pos.x + 19*s.x, head_pos.y, 1*s.x, 24*s.y), apply_alpha.call(Color(0.8, 0.4, 0.0)))
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_OUTLINE, false, 2.0 * s.x)
 
			# F. YÜZ
			var face_y = head_pos.y + 8*s.y
			node.draw_rect(Rect2(head_pos.x + 5*s.x, face_y, 6*s.x, 5*s.y), C_GLOW)
			node.draw_rect(Rect2(head_pos.x + 15*s.x, face_y, 6*s.x, 5*s.y), C_GLOW)
			node.draw_rect(Rect2(head_pos.x + 6*s.x, face_y + 10*s.y, 14*s.x, 2*s.y), C_GLOW)
			node.draw_rect(Rect2(head_pos.x + 8*s.x, face_y + 9*s.y, 2*s.x, 4*s.y), C_GLOW)
			node.draw_rect(Rect2(head_pos.x + 16*s.x, face_y + 9*s.y, 2*s.x, 4*s.y), C_GLOW)
			node.draw_rect(Rect2(head_pos.x + 12*s.x, face_y + 11*s.y, 2*s.x, 2*s.y), C_GLOW)

		"grand_wizard":
			var C_ROBE = apply_alpha.call(Color(0.3, 0.0, 0.5))
			var C_DARK = apply_alpha.call(Color(0.1, 0.0, 0.3))
			var C_BEARD = apply_alpha.call(Color(0.9, 0.9, 0.95))
			var C_MAGIC = apply_alpha.call(Color(1.0, 0.2, 0.8))
			var C_WOOD = apply_alpha.call(Color(0.4, 0.2, 0.1))
			var C_SKIN = apply_alpha.call(Color(0.9, 0.7, 0.6))
			var _C_OUTLINE = apply_alpha.call(Color(0.0, 0.0, 0.0))
 
			var bounce = sin(msec / 300.0) * 3.0 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 22)*s, 6*s.x, apply_alpha.call(Color(0,0,0,0.2)))
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-6, 14)*s, Vector2(4, 4)*s), C_DARK)
			node.draw_rect(Rect2(center + Vector2(2, 14)*s, Vector2(4, 4)*s), C_DARK)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-8, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(16, 12)*s), C_ROBE)
 
			# D. ELLER ve ASA
			node.draw_rect(Rect2(center + Vector2(-15, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_SKIN)
			var hand_r_pos = center + Vector2(10, 8)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(hand_r_pos, Vector2(5, 5)*s), C_SKIN)
			node.draw_rect(Rect2(hand_r_pos.x + 1*s.x, hand_r_pos.y - 10*s.y, 3*s.x, 24*s.y), C_WOOD)
			node.draw_rect(Rect2(hand_r_pos.x - 1*s.x, hand_r_pos.y - 14*s.y, 7*s.x, 7*s.y), C_MAGIC)
 
			# E. KAFA
			var head_pos = center + Vector2(-13, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_SKIN)
			node.draw_rect(Rect2(head_pos.x + 6*s.x, head_pos.y + 10*s.y, 4*s.x, 2*s.y), apply_alpha.call(Color(0,0,0)))
			node.draw_rect(Rect2(head_pos.x + 16*s.x, head_pos.y + 10*s.y, 4*s.x, 2*s.y), apply_alpha.call(Color(0,0,0)))
 
			# SAKAL
			node.draw_rect(Rect2(head_pos.x + 2*s.x, head_pos.y + 16*s.y, 22*s.x, 12*s.y), C_BEARD)
			node.draw_rect(Rect2(head_pos.x + 8*s.x, head_pos.y + 28*s.y, 10*s.x, 4*s.y), C_BEARD)
 
			# F. BÜYÜCÜ ŞAPKASI
			var hat_y = head_pos.y - 4*s.y
			node.draw_rect(Rect2(head_pos.x - 4*s.x, hat_y, 34*s.x, 4*s.y), C_ROBE)
			node.draw_rect(Rect2(head_pos.x + 2*s.x, hat_y - 8*s.y, 22*s.x, 8*s.y), C_ROBE)
			node.draw_rect(Rect2(head_pos.x + 8*s.x, hat_y - 14*s.y, 10*s.x, 6*s.y), C_ROBE)
			node.draw_rect(Rect2(head_pos.x + 8*s.x, hat_y - 14*s.y, 10*s.x, 6*s.y), C_ROBE)
			node.draw_rect(Rect2(head_pos.x + 12*s.x, hat_y - 18*s.y, 6*s.x, 4*s.y), C_ROBE)
 
		"steampunk_diver":
			var C_BRONZE = apply_alpha.call(Color(0.7, 0.5, 0.3))
			var C_TANK = apply_alpha.call(Color(0.4, 0.2, 0.1))
			var C_GLASS = apply_alpha.call(Color(0.2, 0.8, 0.9))
			var C_LIGHT = apply_alpha.call(Color(1.0, 1.0, 1.0, 0.7))
			var C_OUTLINE = apply_alpha.call(Color(0.2, 0.1, 0.0))
 
			var bounce = sin(msec / 400.0) * 4.0 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# OKSİJEN TANKI
			node.draw_rect(Rect2(center.x - 12*s.x, center.y - 4*s.y + bounce, 6*s.x, 18*s.y), C_TANK)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), C_BRONZE)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), C_BRONZE)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-7, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(14, 10)*s), C_BRONZE)
			node.draw_rect(Rect2(body_pos.x + 4*s.x, body_pos.y + 3*s.y, 6*s.x, 4*s.y), apply_alpha.call(Color(0.2, 0.1, 0.0)))
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-15, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_BRONZE)
			node.draw_rect(Rect2(center + Vector2(10, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_BRONZE)
 
			# E. KAFA
			var head_pos = center + Vector2(-13, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_OUTLINE, false, 2.0 * s.x)
			node.draw_rect(Rect2(head_pos + Vector2(2,2)*s, Vector2(22, 20)*s), C_BRONZE)
			node.draw_rect(Rect2(head_pos.x - 4*s.x, head_pos.y + 16*s.y, 4*s.x, 4*s.y), apply_alpha.call(Color(0.1, 0.1, 0.1)))
 
			# F. YÜZ (Vizör)
			var visor_pos = head_pos + Vector2(3, 3)*s
			node.draw_rect(Rect2(visor_pos, Vector2(20, 18)*s), C_GLASS)
			node.draw_rect(Rect2(visor_pos.x + 2*s.x, visor_pos.y + 2*s.y, 4*s.x, 4*s.y), C_LIGHT)
			node.draw_rect(Rect2(visor_pos.x + 14*s.x, visor_pos.y + 12*s.y, 2*s.x, 2*s.y), C_LIGHT)
			node.draw_rect(Rect2(visor_pos.x + 6*s.x, visor_pos.y + 6*s.y, 8*s.x, 8*s.y), apply_alpha.call(Color(0,0,0, 0.5)))

		"berserker":
			var bz_fur_dark = apply_alpha.call(Color(0.35, 0.2, 0.1))
			var bz_fur_light = apply_alpha.call(Color(0.5, 0.3, 0.15))
			var bz_helmet = apply_alpha.call(Color(0.45, 0.5, 0.55))
			var bz_helmet_l = apply_alpha.call(Color(0.6, 0.65, 0.7))
			var bz_horn = apply_alpha.call(Color(0.95, 0.9, 0.8))
			var bz_skin = apply_alpha.call(Color(0.9, 0.7, 0.6))
			var bz_beard = apply_alpha.call(Color(0.85, 0.35, 0.1))
			var bz_beard_s = apply_alpha.call(Color(0.7, 0.25, 0.05))
			var bz_eye_glow = apply_alpha.call(Color(1, 1, 1))

			var bz_bounce = sin(msec / 120.0) * 1.5 * s.y
			var bz_breath = cos(msec / 200.0) * 0.5 * s.x

			# 1. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 9*s.x, shadow_col)

			# 2. PELERİN (En Arkada)
			var bz_cape_pos = center + Vector2(-10, 2)*s + Vector2(0, bz_bounce*0.8)
			node.draw_rect(Rect2(bz_cape_pos, Vector2(20, 18)*s), bz_fur_dark)

			# 3. AYAKLAR (Kürk Botlar)
			node.draw_rect(Rect2(center + Vector2(-8, 14)*s, Vector2(6, 6)*s), bz_fur_light)
			node.draw_rect(Rect2(center + Vector2(2, 14)*s, Vector2(6, 6)*s), bz_fur_light)

			# 4. GÖVDE (Zırhlı)
			var bz_body_pos = center + Vector2(-7, 6)*s + Vector2(0, bz_bounce)
			# Ana gövde
			node.draw_rect(Rect2(bz_body_pos, Vector2(14, 10)*s), bz_fur_dark)
			# Zırh detayı (göğüs)
			node.draw_rect(Rect2(bz_body_pos.x + 2*s.x - bz_breath, bz_body_pos.y, 10*s.x + bz_breath*2, 8*s.y), bz_fur_light)

			# 5. KAFA GRUBU
			var bz_head_c = center + Vector2(0, -6)*s + Vector2(0, bz_bounce)

			# Sakal (Alt Katman - Geniş)
			node.draw_rect(Rect2(bz_head_c.x - 7*s.x, bz_head_c.y + 2*s.y, 14*s.x, 10*s.y), bz_beard_s)

			# Yüz (Deri)
			node.draw_rect(Rect2(bz_head_c.x - 6*s.x, bz_head_c.y - 6*s.y, 12*s.x, 10*s.y), bz_skin)

			# Sakal (Üst Katman - Detay)
			node.draw_rect(Rect2(bz_head_c.x - 6*s.x, bz_head_c.y + 4*s.y, 12*s.x, 6*s.y), bz_beard)
			node.draw_rect(Rect2(bz_head_c.x - 2*s.x, bz_head_c.y + 8*s.y, 4*s.x, 4*s.y), bz_beard)

			# Bıyıklar
			node.draw_rect(Rect2(bz_head_c.x - 7*s.x, bz_head_c.y + 2*s.y, 4*s.x, 3*s.y), bz_beard)
			node.draw_rect(Rect2(bz_head_c.x + 3*s.x, bz_head_c.y + 2*s.y, 4*s.x, 3*s.y), bz_beard)

			# Miğfer (Ana Kısım)
			node.draw_rect(Rect2(bz_head_c.x - 7*s.x, bz_head_c.y - 9*s.y, 14*s.x, 8*s.y), bz_helmet)
			# Miğfer Burun Koruyucu
			node.draw_rect(Rect2(bz_head_c.x - 1*s.x, bz_head_c.y - 2*s.y, 2*s.x, 4*s.y), bz_helmet_l)

			# Boynuzlar
			# Sol Boynuz
			node.draw_rect(Rect2(bz_head_c.x - 10*s.x, bz_head_c.y - 7*s.y, 3*s.x, 5*s.y), bz_horn)
			node.draw_rect(Rect2(bz_head_c.x - 11*s.x, bz_head_c.y - 10*s.y, 2*s.x, 3*s.y), bz_horn)
			# Sağ Boynuz
			node.draw_rect(Rect2(bz_head_c.x + 7*s.x, bz_head_c.y - 7*s.y, 3*s.x, 5*s.y), bz_horn)
			node.draw_rect(Rect2(bz_head_c.x + 9*s.x, bz_head_c.y - 10*s.y, 2*s.x, 3*s.y), bz_horn)

			# Yüz Detayları (Gözler - Öfkeli/Beyaz)
			node.draw_rect(Rect2(bz_head_c.x - 4*s.x, bz_head_c.y - 1*s.y, 3*s.x, 2*s.y), bz_eye_glow)
			node.draw_rect(Rect2(bz_head_c.x + 1*s.x, bz_head_c.y - 1*s.y, 3*s.x, 2*s.y), bz_eye_glow)

			# 6. ELLER (Yumruklar sıkılı)
			node.draw_rect(Rect2(center + Vector2(-12, 6)*s + Vector2(0, bz_bounce*1.1), Vector2(5, 5)*s), bz_skin)
			node.draw_rect(Rect2(center + Vector2(7, 6)*s + Vector2(0, bz_bounce*1.1), Vector2(5, 5)*s), bz_skin)

		"retro_tv":
			var C_CASE = apply_alpha.call(Color(0.8, 0.75, 0.6))
			var C_HOODIE = apply_alpha.call(Color(0.3, 0.3, 0.35))
			var noise_val = (int(msec / 50.0) % 3) * 0.1
			var C_SCREEN_NOISE = apply_alpha.call(Color(0.1 + noise_val, 0.1 + noise_val, 0.2 + noise_val))
 
			var bounce = sin(msec / 150.0) * 1.5 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), apply_alpha.call(Color(0.9, 0.2, 0.2)))
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), apply_alpha.call(Color(0.9, 0.2, 0.2)))
 
			# C. GÖVDE
			var body_pos = center + Vector2(-8, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(16, 10)*s), C_HOODIE)
			node.draw_rect(Rect2(body_pos.x + 4*s.x, body_pos.y + 2*s.y, 1*s.x, 6*s.y), apply_alpha.call(Color(0.8, 0.8, 0.8)))
			node.draw_rect(Rect2(body_pos.x + 11*s.x, body_pos.y + 2*s.y, 1*s.x, 6*s.y), apply_alpha.call(Color(0.8, 0.8, 0.8)))
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-15, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_HOODIE)
			node.draw_rect(Rect2(center + Vector2(10, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_HOODIE)
 
			# E. KAFA
			var head_pos = center + Vector2(-14, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(28, 22)*s), C_CASE)
			node.draw_rect(Rect2(head_pos.x + 8*s.x, head_pos.y + 22*s.y, 12*s.x, 2*s.y), apply_alpha.call(Color(0.2,0.2,0.2)))
 
			# ANTENLER
			node.draw_rect(Rect2(head_pos.x + 4*s.x, head_pos.y - 6*s.y, 2*s.x, 6*s.y), apply_alpha.call(Color(0.5,0.5,0.5)))
			node.draw_rect(Rect2(head_pos.x + 22*s.x, head_pos.y - 8*s.y, 2*s.x, 8*s.y), apply_alpha.call(Color(0.5,0.5,0.5)))
 
			# EKRAN
			var screen_pos = Vector2(head_pos.x + 2*s.x, head_pos.y + 2*s.y)
			node.draw_rect(Rect2(screen_pos, Vector2(20, 18)*s), C_SCREEN_NOISE)
 
			# YAN KONTROL
			node.draw_rect(Rect2(head_pos.x + 23*s.x, head_pos.y + 4*s.y, 4*s.x, 14*s.y), apply_alpha.call(Color(0.2, 0.2, 0.2)))
			node.draw_rect(Rect2(head_pos.x + 24*s.x, head_pos.y + 6*s.y, 2*s.x, 2*s.y), apply_alpha.call(Color(1, 0, 0)))
			node.draw_rect(Rect2(head_pos.x + 24*s.x, head_pos.y + 10*s.y, 2*s.x, 2*s.y), apply_alpha.call(Color(0.8, 0.8, 0.8)))
			node.draw_rect(Rect2(head_pos.x + 24*s.x, head_pos.y + 14*s.y, 2*s.x, 2*s.y), apply_alpha.call(Color(0.8, 0.8, 0.8)))
 
			# YÜZ İFADESİ
			var eye_color = apply_alpha.call(Color(0, 1, 0))
			node.draw_rect(Rect2(screen_pos.x + 4*s.x, screen_pos.y + 6*s.y, 4*s.x, 4*s.y), eye_color)
			node.draw_rect(Rect2(screen_pos.x + 12*s.x, screen_pos.y + 6*s.y, 4*s.x, 4*s.y), eye_color)

		"desperado":
			var C_PONCHO_BASE = apply_alpha.call(Color(0.6, 0.2, 0.2))
			var C_PONCHO_DETAIL = apply_alpha.call(Color(0.8, 0.6, 0.4))
			var C_HAT = apply_alpha.call(Color(0.4, 0.25, 0.15))
			var C_SKIN = apply_alpha.call(Color(0.7, 0.5, 0.4))
			var C_OUTLINE = apply_alpha.call(Color(0.2, 0.1, 0.0))
 
			var bounce = sin(msec / 180.0) * 1.5 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), C_HAT)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), C_HAT)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-7, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(14, 10)*s), apply_alpha.call(Color(0.8, 0.8, 0.7)))
			node.draw_rect(Rect2(body_pos.x + 4*s.x, body_pos.y - 2*s.y, 12*s.x, 14*s.y), C_PONCHO_BASE)
			node.draw_rect(Rect2(body_pos.x + 4*s.x, body_pos.y + 6*s.y, 12*s.x, 2*s.y), C_PONCHO_DETAIL)
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-15, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_SKIN)
			node.draw_rect(Rect2(center + Vector2(10, 9)*s + Vector2(0, bounce), Vector2(4, 4)*s), C_PONCHO_BASE)
 
			# E. KAFA
			var head_pos = center + Vector2(-13, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_SKIN)
			node.draw_rect(Rect2(head_pos.x, head_pos.y + 12*s.y, 26*s.x, 12*s.y), apply_alpha.call(Color(0.1, 0.1, 0.15)))
			node.draw_rect(Rect2(head_pos.x - 2*s.x, head_pos.y + 14*s.y, 2*s.x, 4*s.y), apply_alpha.call(Color(0.1, 0.1, 0.15)))
			node.draw_rect(Rect2(head_pos.x + 6*s.x, head_pos.y + 8*s.y, 4*s.x, 2*s.y), apply_alpha.call(Color(0,0,0)))
			node.draw_rect(Rect2(head_pos.x + 16*s.x, head_pos.y + 8*s.y, 4*s.x, 2*s.y), apply_alpha.call(Color(0,0,0)))
 
			# ŞAPKA
			var hat_y = head_pos.y - 6*s.y
			node.draw_rect(Rect2(head_pos.x - 6*s.x, head_pos.y - 2*s.y, 38*s.x, 4*s.y), C_HAT)
			node.draw_rect(Rect2(head_pos.x + 2*s.x, hat_y, 22*s.x, 8*s.y), C_HAT)
			node.draw_rect(Rect2(head_pos.x + 2*s.x, head_pos.y - 2*s.y, 22*s.x, 2*s.y), C_PONCHO_DETAIL)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_OUTLINE, false, 2.0 * s.x)

		"the_mimic":
			var C_WOOD = apply_alpha.call(Color(0.5, 0.3, 0.1))
			var C_IRON = apply_alpha.call(Color(0.4, 0.4, 0.45))
			var C_FLESH = apply_alpha.call(Color(0.7, 0.1, 0.2))
			var C_GOLD = apply_alpha.call(Color(1.0, 0.8, 0.0))
			var C_CLOTH = apply_alpha.call(Color(0.2, 0.2, 0.3))
 
			var bounce = sin(msec / 120.0) * 2.0 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), apply_alpha.call(Color(0.3, 0.3, 0.3)))
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), apply_alpha.call(Color(0.3, 0.3, 0.3)))
 
			# C. GÖVDE
			var body_pos = center + Vector2(-7, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(14, 10)*s), C_CLOTH)
			node.draw_rect(Rect2(body_pos.x + 12*s.x, body_pos.y + 2*s.y, 2*s.x, 8*s.y), apply_alpha.call(Color(0.6, 0.6, 0.6)))
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-15, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_WOOD)
			node.draw_rect(Rect2(center + Vector2(10, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_WOOD)
 
			# E. KAFA
			var head_pos = center + Vector2(-13, -14)*s + Vector2(0, bounce)
 
			# -- ALT PARÇA --
			node.draw_rect(Rect2(head_pos.x, head_pos.y + 12*s.y, 26*s.x, 12*s.y), C_WOOD)
			node.draw_rect(Rect2(head_pos.x + 4*s.x, head_pos.y + 12*s.y, 4*s.x, 12*s.y), C_IRON)
			node.draw_rect(Rect2(head_pos.x + 18*s.x, head_pos.y + 12*s.y, 4*s.x, 12*s.y), C_IRON)
			node.draw_rect(Rect2(head_pos.x + 11*s.x, head_pos.y + 12*s.y, 4*s.x, 4*s.y), C_GOLD)
 
			# -- AĞIZ İÇİ --
			var mouth_gap = abs(bounce) * 1.5 + 2.0 * s.y
			node.draw_rect(Rect2(head_pos.x + 2*s.x, head_pos.y + 12*s.y - mouth_gap, 22*s.x, mouth_gap), C_FLESH)
			node.draw_rect(Rect2(head_pos.x + 20*s.x, head_pos.y + 10*s.y, 3*s.x, 3*s.y), C_GOLD)
			node.draw_rect(Rect2(head_pos.x + 8*s.x, head_pos.y + 12*s.y, 6*s.x, 6*s.y + bounce), apply_alpha.call(Color(0.9, 0.2, 0.3)))
 
			# -- ÜST PARÇA (KAPAK) --
			var lid_y = head_pos.y - mouth_gap
			node.draw_rect(Rect2(head_pos.x, lid_y, 26*s.x, 12*s.y), C_WOOD)
			node.draw_rect(Rect2(head_pos.x + 4*s.x, lid_y, 4*s.x, 12*s.y), C_IRON)
			node.draw_rect(Rect2(head_pos.x + 18*s.x, lid_y, 4*s.x, 12*s.y), C_IRON)
			node.draw_rect(Rect2(head_pos.x + 6*s.x, lid_y + 6*s.y, 4*s.x, 4*s.y), apply_alpha.call(Color(1, 1, 0)))
			node.draw_rect(Rect2(head_pos.x + 16*s.x, lid_y + 6*s.y, 4*s.x, 4*s.y), apply_alpha.call(Color(1, 1, 0)))

		"boombox_boy":
			var C_BODY = apply_alpha.call(Color(0.8, 0.0, 0.5))
			var C_CASE = apply_alpha.call(Color(0.25, 0.25, 0.3))
			var C_SPEAKER = apply_alpha.call(Color(0.1, 0.1, 0.1))
			var C_TAPE = apply_alpha.call(Color(0.0, 0.8, 0.8))
 
			var bounce = abs(sin(msec / 100.0)) * 2.0 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-9, 12)*s, Vector2(7, 6)*s), apply_alpha.call(Color(0.9, 0.9, 0.9)))
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(7, 6)*s), apply_alpha.call(Color(0.9, 0.9, 0.9)))
 
			# C. GÖVDE
			var body_pos = center + Vector2(-8, 6)*s + Vector2(0, bounce/2.0)
			node.draw_rect(Rect2(body_pos, Vector2(16, 10)*s), C_BODY)
			node.draw_rect(Rect2(body_pos.x + 7*s.x, body_pos.y, 2*s.x, 10*s.y), apply_alpha.call(Color(0,0,0, 0.5)))
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-16, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_SPEAKER)
			node.draw_rect(Rect2(center + Vector2(11, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_SPEAKER)
 
			# E. KAFA (KASETÇALAR)
			var head_pos = center + Vector2(-15, -14)*s + Vector2(0, bounce)
			var head_w = 30
			var head_h = 22
 
			# Kasa
			node.draw_rect(Rect2(head_pos, Vector2(head_w, head_h)*s), C_CASE)
			node.draw_rect(Rect2(head_pos.x + 4*s.x, head_pos.y - 4*s.y, 22*s.x, 4*s.y), C_CASE)
			node.draw_rect(Rect2(head_pos.x + 6*s.x, head_pos.y - 2*s.y, 18*s.x, 2*s.y), apply_alpha.call(Color(0.1,0.1,0.1)))
 
			# SOL HOPARLÖR
			node.draw_rect(Rect2(head_pos.x + 2*s.x, head_pos.y + 4*s.y, 8*s.x, 14*s.y), C_SPEAKER)
			var w_size = (2.0 * s.x) + bounce
			node.draw_rect(Rect2(head_pos.x + 5*s.x - w_size/2.0, head_pos.y + 11*s.y - w_size/2.0, w_size+2*s.x, w_size+2*s.y), apply_alpha.call(Color(0.5, 0.5, 0.5)))
 
			# SAĞ HOPARLÖR
			node.draw_rect(Rect2(head_pos.x + 20*s.x, head_pos.y + 4*s.y, 8*s.x, 14*s.y), C_SPEAKER)
			node.draw_rect(Rect2(head_pos.x + 23*s.x - w_size/2.0, head_pos.y + 11*s.y - w_size/2.0, w_size+2*s.x, w_size+2*s.y), apply_alpha.call(Color(0.5, 0.5, 0.5)))
 
			# ORTA KISIM
			node.draw_rect(Rect2(head_pos.x + 11*s.x, head_pos.y + 4*s.y, 8*s.x, 6*s.y), C_TAPE)
			node.draw_rect(Rect2(head_pos.x + 12*s.x, head_pos.y + 6*s.y, 2*s.x, 2*s.y), apply_alpha.call(Color(1,1,1)))
			node.draw_rect(Rect2(head_pos.x + 16*s.x, head_pos.y + 6*s.y, 2*s.x, 2*s.y), apply_alpha.call(Color(1,1,1)))
 
			# EQ Çubukları
			var eq_h1 = (int(float(msec) / 100.0) % 4 + 1) * s.y
			var eq_h2 = (int((float(msec) / 100.0) + 1.0) % 4 + 1) * s.y
			node.draw_rect(Rect2(head_pos.x + 12*s.x, head_pos.y + 16*s.y - eq_h1, 2*s.x, eq_h1), apply_alpha.call(Color(0,1,0)))
			node.draw_rect(Rect2(head_pos.x + 15*s.x, head_pos.y + 16*s.y - eq_h2, 2*s.x, eq_h2), apply_alpha.call(Color(1,1,0)))
			
			# Anten
			node.draw_rect(Rect2(head_pos.x + 2*s.x, head_pos.y - 10*s.y, 1*s.x, 10*s.y), apply_alpha.call(Color(0.6, 0.6, 0.6)))

		"the_signal":
			var _C_POLE = apply_alpha.call(Color(0.2, 0.2, 0.2))
			var C_CASE = apply_alpha.call(Color(0.9, 0.7, 0.1))
			var C_OFF = apply_alpha.call(Color(0.1, 0.1, 0.1))
			var C_RED = apply_alpha.call(Color(1.0, 0.1, 0.1))
			var C_YELLOW = apply_alpha.call(Color(1.0, 0.8, 0.0))
			var C_GREEN = apply_alpha.call(Color(0.0, 1.0, 0.4))
			var C_VEST = apply_alpha.call(Color(1.0, 0.4, 0.0))
 
			var cycle = int(msec / 800.0) % 3
			var light_r = C_RED if cycle == 0 else C_OFF
			var light_y = C_YELLOW if cycle == 1 else C_OFF
			var light_g = C_GREEN if cycle == 2 else C_OFF
 
			var bounce = sin(msec / 200.0) * 1.0 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 7*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), apply_alpha.call(Color(0.2,0.2,0.2)))
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), apply_alpha.call(Color(0.2,0.2,0.2)))
 
			# C. GÖVDE
			var body_pos = center + Vector2(-8, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(16, 10)*s), apply_alpha.call(Color(0.2, 0.2, 0.25)))
			node.draw_rect(Rect2(body_pos.x + 2*s.x, body_pos.y, 4*s.x, 10*s.y), C_VEST)
			node.draw_rect(Rect2(body_pos.x + 10*s.x, body_pos.y, 4*s.x, 10*s.y), C_VEST)
			node.draw_rect(Rect2(body_pos.x, body_pos.y + 6*s.y, 16*s.x, 2*s.y), apply_alpha.call(Color(0.8, 0.8, 0.8)))
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-15, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_CASE)
			node.draw_rect(Rect2(center + Vector2(10, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_CASE)
 
			# E. KAFA (Uzun Blok)
			var head_w = 16
			var head_h = 32
			var head_pos = center + Vector2(-head_w/2.0, -22)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(head_w, head_h)*s), C_CASE)
			node.draw_rect(Rect2(head_pos.x + (head_w - 2)*s.x, head_pos.y, 2*s.x, head_h*s.y), apply_alpha.call(Color(0,0,0,0.2)))
 
			# Işıklar
			var light_x = head_pos.x + 4*s.x
			var light_size = 8*s.x
			node.draw_rect(Rect2(light_x, head_pos.y + 3*s.y, light_size, light_size), light_r)
			node.draw_rect(Rect2(light_x, head_pos.y + 12*s.y, light_size, light_size), light_y)
			node.draw_rect(Rect2(light_x, head_pos.y + 21*s.y, light_size, light_size), light_g)
 
			# Siperlikler
			node.draw_rect(Rect2(head_pos.x + 2*s.x, head_pos.y + 2*s.y, 12*s.x, 2*s.y), apply_alpha.call(Color(0,0,0)))
			node.draw_rect(Rect2(head_pos.x + 2*s.x, head_pos.y + 11*s.y, 12*s.x, 2*s.y), apply_alpha.call(Color(0,0,0)))
			node.draw_rect(Rect2(head_pos.x + 2*s.x, head_pos.y + 20*s.y, 12*s.x, 2*s.y), apply_alpha.call(Color(0,0,0)))

		"venus_flytrap":
			var C_PLANT = apply_alpha.call(Color(0.1, 0.4, 0.1))
			var C_MOUTH_IN = apply_alpha.call(Color(0.6, 0.1, 0.4))
			var C_TEETH = apply_alpha.call(Color(0.9, 0.9, 0.7))
			var C_VINE = apply_alpha.call(Color(0.3, 0.7, 0.2))
			var C_CLOTH = apply_alpha.call(Color(0.2, 0.25, 0.35))
 
			var bounce = sin(msec / 300.0) * 2.0 * s.y
			var jaw_open = abs(sin(msec / 200.0)) * 4.0 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), C_CLOTH)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), C_CLOTH)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-7, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(14, 10)*s), C_CLOTH)
			node.draw_rect(Rect2(body_pos.x - 2*s.x, body_pos.y + 2*s.y, 18*s.x, 2*s.y), C_VINE)
			node.draw_rect(Rect2(body_pos.x - 2*s.x, body_pos.y + 6*s.y, 18*s.x, 2*s.y), C_VINE)
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-15, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_VINE)
			node.draw_rect(Rect2(center + Vector2(10, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_VINE)
 
			# E. KAFA
			var head_pos = center + Vector2(-14, -14)*s + Vector2(0, bounce)
 
			# ALT ÇENE
			node.draw_rect(Rect2(head_pos.x, head_pos.y + 12*s.y, 28*s.x, 10*s.y), C_PLANT)
			node.draw_rect(Rect2(head_pos.x + 2*s.x, head_pos.y + 12*s.y, 2*s.x, 4*s.y), C_TEETH)
			node.draw_rect(Rect2(head_pos.x + 13*s.x, head_pos.y + 12*s.y, 2*s.x, 4*s.y), C_TEETH)
			node.draw_rect(Rect2(head_pos.x + 24*s.x, head_pos.y + 12*s.y, 2*s.x, 4*s.y), C_TEETH)
 
			# AĞIZ BOŞLUĞU
			node.draw_rect(Rect2(head_pos.x + 2*s.x, head_pos.y + 10*s.y - jaw_open, 24*s.x, jaw_open + 4*s.y), C_MOUTH_IN)
 
			# ÜST ÇENE
			var top_jaw_y = head_pos.y - jaw_open
			node.draw_rect(Rect2(head_pos.x, top_jaw_y, 28*s.x, 12*s.y), C_PLANT)
			node.draw_rect(Rect2(head_pos.x + 4*s.x, top_jaw_y + 4*s.y, 4*s.x, 4*s.y), apply_alpha.call(Color(1, 0.8, 0.0)))
			node.draw_rect(Rect2(head_pos.x + 20*s.x, top_jaw_y + 4*s.y, 4*s.x, 4*s.y), apply_alpha.call(Color(1, 0.8, 0.0)))
			node.draw_rect(Rect2(head_pos.x + 6*s.x, top_jaw_y + 12*s.y, 2*s.x, 4*s.y), C_TEETH)
			node.draw_rect(Rect2(head_pos.x + 18*s.x, top_jaw_y + 12*s.y, 2*s.x, 4*s.y), C_TEETH)
			node.draw_rect(Rect2(head_pos.x + 12*s.x, top_jaw_y - 6*s.y, 4*s.x, 6*s.y), C_VINE)

		"samurai_oni":
			var C_ARMOR = apply_alpha.call(Color(0.6, 0.1, 0.1))
			var C_GOLD = apply_alpha.call(Color(0.9, 0.7, 0.1))
			var C_MASK = apply_alpha.call(Color(0.1, 0.1, 0.1))
			var C_HORN = apply_alpha.call(Color(0.9, 0.8, 0.6))
			var C_FLAG = apply_alpha.call(Color(0.9, 0.9, 0.9))
 
			var bounce = sin(msec / 150.0) * 1.0 * s.y
 
			# A. SAVAŞ SANCAĞI (SASHIMONO)
			var flag_base_x = center.x + 6*s.x
			var flag_base_y = center.y - 10*s.y + bounce
			node.draw_rect(Rect2(flag_base_x, flag_base_y - 20*s.y, 2*s.x, 30*s.y), apply_alpha.call(Color(0.2, 0.1, 0.0)))
			node.draw_rect(Rect2(flag_base_x - 10*s.x, flag_base_y - 18*s.y, 10*s.x, 16*s.y), C_FLAG)
			node.draw_rect(Rect2(flag_base_x - 7*s.x, flag_base_y - 14*s.y, 4*s.x, 4*s.y), apply_alpha.call(Color(1, 0, 0)))
 
			# B. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# C. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-9, 12)*s, Vector2(7, 6)*s), C_ARMOR)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(7, 6)*s), C_ARMOR)
 
			# D. GÖVDE
			var body_pos = center + Vector2(-8, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(16, 10)*s), C_ARMOR)
			node.draw_rect(Rect2(body_pos.x + 2*s.x, body_pos.y + 3*s.y, 12*s.x, 1*s.y), C_GOLD)
			node.draw_rect(Rect2(body_pos.x + 2*s.x, body_pos.y + 7*s.y, 12*s.x, 1*s.y), C_GOLD)
			node.draw_rect(Rect2(body_pos.x - 4*s.x, body_pos.y - 2*s.y, 4*s.x, 6*s.y), C_ARMOR)
			node.draw_rect(Rect2(body_pos.x + 16*s.x, body_pos.y - 2*s.y, 4*s.x, 6*s.y), C_ARMOR)
 
			# E. ELLER
			node.draw_rect(Rect2(center + Vector2(-16, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_MASK)
			node.draw_rect(Rect2(center + Vector2(11, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_MASK)
 
			# F. KAFA
			var head_pos = center + Vector2(-13, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_ARMOR)
			node.draw_rect(Rect2(head_pos.x + 2*s.x, head_pos.y + 4*s.y, 22*s.x, 18*s.y), C_MASK)
			node.draw_rect(Rect2(head_pos.x + 5*s.x, head_pos.y + 8*s.y, 6*s.x, 4*s.y), C_GOLD)
			node.draw_rect(Rect2(head_pos.x + 15*s.x, head_pos.y + 8*s.y, 6*s.x, 4*s.y), C_GOLD)
			node.draw_rect(Rect2(head_pos.x + 6*s.x, head_pos.y + 16*s.y, 2*s.x, 4*s.y), apply_alpha.call(Color(1,1,1)))
			node.draw_rect(Rect2(head_pos.x + 18*s.x, head_pos.y + 16*s.y, 2*s.x, 4*s.y), apply_alpha.call(Color(1,1,1)))
			node.draw_rect(Rect2(head_pos.x + 8*s.x, head_pos.y - 4*s.y, 10*s.x, 4*s.y), C_GOLD)
			node.draw_rect(Rect2(head_pos.x - 2*s.x, head_pos.y, 2*s.x, 6*s.y), C_HORN)
			node.draw_rect(Rect2(head_pos.x + 26*s.x, head_pos.y + 2*s.y, 2*s.x, 3*s.y), C_HORN)

		"frostbite":
			var C_ICE_LIGHT = apply_alpha.call(Color(0.8, 0.9, 1.0))
			var C_ICE_DEEP = apply_alpha.call(Color(0.2, 0.4, 0.8))
			var C_EYES = apply_alpha.call(Color(1.0, 1.0, 1.0))
			var C_SNOW = apply_alpha.call(Color(1.0, 1.0, 1.0, 0.8))
 
			var bounce = sin(msec / 300.0) * 1.5 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, apply_alpha.call(Color(0, 0.2, 0.4, 0.3)))
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-9, 12)*s, Vector2(8, 6)*s), C_ICE_DEEP)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(8, 6)*s), C_ICE_DEEP)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-8, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(16, 12)*s), C_ICE_DEEP)
			node.draw_rect(Rect2(body_pos.x + 2*s.x, body_pos.y + 2*s.y, 6*s.x, 4*s.y), C_ICE_LIGHT)
			node.draw_rect(Rect2(body_pos.x + 10*s.x, body_pos.y + 6*s.y, 4*s.x, 6*s.y), C_ICE_LIGHT)
 
			# D. KOLLAR (Asimetrik)
			node.draw_rect(Rect2(center + Vector2(-16, 8)*s + Vector2(0, bounce), Vector2(6, 6)*s), C_ICE_LIGHT)
			var spike_pos = center + Vector2(10, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(spike_pos, Vector2(8, 10)*s), C_ICE_DEEP)
			node.draw_rect(Rect2(spike_pos.x + 2*s.x, spike_pos.y + 10*s.y, 4*s.x, 6*s.y), C_ICE_LIGHT)
 
			# E. KAFA
			var head_pos = center + Vector2(-13, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_ICE_DEEP)
			node.draw_rect(Rect2(head_pos.x, head_pos.y - 6*s.y, 6*s.x, 6*s.y), C_ICE_LIGHT)
			node.draw_rect(Rect2(head_pos.x + 16*s.x, head_pos.y - 8*s.y, 8*s.x, 8*s.y), C_ICE_LIGHT)
			node.draw_rect(Rect2(head_pos.x + 6*s.x, head_pos.y + 8*s.y, 4*s.x, 4*s.y), C_EYES)
			node.draw_rect(Rect2(head_pos.x + 16*s.x, head_pos.y + 7*s.y, 4*s.x, 6*s.y), C_EYES)
			node.draw_rect(Rect2(head_pos.x + 10*s.x, head_pos.y + 24*s.y, 6*s.x, 4*s.y), C_ICE_LIGHT)
 
			# Kar Efekti
			var snow_y1 = fmod(msec / 20.0, 40.0)
			node.draw_rect(Rect2(head_pos.x - 4*s.x, head_pos.y + 10*s.y + snow_y1*s.y, 2*s.x, 2*s.y), C_SNOW)

		"cctv":
			var C_CAM_BODY = apply_alpha.call(Color(0.85, 0.85, 0.9))
			var C_LENS = apply_alpha.call(Color(0.1, 0.1, 0.15))
			var C_GLASS = apply_alpha.call(Color(0.0, 0.0, 0.3))
			var C_REC = apply_alpha.call(Color(1.0, 0.0, 0.0))
			var C_WIRE1 = apply_alpha.call(Color(1.0, 0.8, 0.2))
			var C_WIRE2 = apply_alpha.call(Color(0.2, 0.5, 1.0))
 
			var bounce = sin(msec / 200.0) * 1.0 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), apply_alpha.call(Color(0.2, 0.2, 0.2)))
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), apply_alpha.call(Color(0.2, 0.2, 0.2)))
 
			# C. GÖVDE
			var body_pos = center + Vector2(-7, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(16, 12)*s), apply_alpha.call(Color(0.6, 0.7, 0.8)))
			node.draw_rect(Rect2(body_pos.x + 6*s.x, body_pos.y, 2*s.x, 8*s.y), apply_alpha.call(Color(0.1, 0.1, 0.1)))
			node.draw_rect(Rect2(body_pos.x - 2*s.x, body_pos.y + 6*s.y, 3*s.x, 4*s.y), apply_alpha.call(Color(0.1, 0.1, 0.1)))
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-14, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), apply_alpha.call(Color(0.8, 0.7, 0.6)))
			node.draw_rect(Rect2(center + Vector2(10, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), apply_alpha.call(Color(0.8, 0.7, 0.6)))
 
			# E. KAFA (Kamera)
			var head_pos = center + Vector2(-14, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(28, 20)*s), C_CAM_BODY)
			node.draw_rect(Rect2(head_pos.x - 4*s.x, head_pos.y + 4*s.y, 4*s.x, 2*s.y), C_WIRE1)
			node.draw_rect(Rect2(head_pos.x - 6*s.x, head_pos.y + 4*s.y, 2*s.x, 8*s.y), C_WIRE1)
			node.draw_rect(Rect2(head_pos.x - 2*s.x, head_pos.y + 8*s.y, 2*s.x, 6*s.y), C_WIRE2)
 
			var lens_x = head_pos.x + 6*s.x
			var lens_y = head_pos.y + 4*s.y
			node.draw_rect(Rect2(lens_x, lens_y, 16*s.x, 12*s.y), C_LENS)
			var zoom = abs(sin(msec / 500.0)) * 4.0 * s.x
			node.draw_rect(Rect2(lens_x + 4*s.x - zoom/2, lens_y + 4*s.y - zoom/2, 8*s.x + zoom, 4*s.y + zoom), C_GLASS)
			node.draw_rect(Rect2(lens_x + 10*s.x, lens_y + 4*s.y, 2*s.x, 2*s.y), apply_alpha.call(Color(1,1,1, 0.7)))
 
			if int(msec / 500.0) % 2 == 0:
				node.draw_rect(Rect2(head_pos.x + 24*s.x, head_pos.y + 2*s.y, 3*s.x, 3*s.y), C_REC)
			else:
				node.draw_rect(Rect2(head_pos.x + 24*s.x, head_pos.y + 2*s.y, 3*s.x, 3*s.y), apply_alpha.call(Color(0.3, 0, 0)))

		"demon_hunter":
			var C_CHECK_G = apply_alpha.call(Color(0.2, 0.8, 0.4))
			var C_CHECK_B = apply_alpha.call(Color(0.1, 0.1, 0.1))
			var C_HAIR = apply_alpha.call(Color(0.4, 0.1, 0.1))
			var C_WATER = apply_alpha.call(Color(0.2, 0.6, 1.0, 0.7))
			var C_SKIN = apply_alpha.call(Color(0.9, 0.75, 0.65))
 
			var bounce = sin(msec / 150.0) * 1.5 * s.y
			var water_flow = int(float(msec) / 50.0) % 20
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), apply_alpha.call(Color(0.9, 0.9, 0.9)))
			node.draw_rect(Rect2(center + Vector2(-8, 16)*s, Vector2(6, 2)*s), C_HAIR)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), apply_alpha.call(Color(0.9, 0.9, 0.9)))
			node.draw_rect(Rect2(center + Vector2(2, 16)*s, Vector2(6, 2)*s), C_HAIR)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-8, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(16, 12)*s), C_CHECK_G)
			node.draw_rect(Rect2(body_pos, Vector2(4, 4)*s), C_CHECK_B)
			node.draw_rect(Rect2(body_pos + Vector2(8, 0)*s, Vector2(4, 4)*s), C_CHECK_B)
			node.draw_rect(Rect2(body_pos + Vector2(4, 4)*s, Vector2(4, 4)*s), C_CHECK_B)
			node.draw_rect(Rect2(body_pos + Vector2(12, 4)*s, Vector2(4, 4)*s), C_CHECK_B)
			node.draw_rect(Rect2(body_pos + Vector2(0, 8)*s, Vector2(4, 4)*s), C_CHECK_B)
			node.draw_rect(Rect2(body_pos + Vector2(8, 8)*s, Vector2(4, 4)*s), C_CHECK_B)
 
			# D. ELLER ve KILIÇ
			node.draw_rect(Rect2(center + Vector2(-15, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_CHECK_G)
			var hand_r_pos = center + Vector2(10, 8)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(hand_r_pos, Vector2(5, 5)*s), C_CHECK_G)
			node.draw_rect(Rect2(hand_r_pos.x - 2*s.x, hand_r_pos.y - 10*s.y, 2*s.x, 20*s.y), apply_alpha.call(Color(0.1, 0.1, 0.1)))
			node.draw_rect(Rect2(hand_r_pos.x - 6*s.x, hand_r_pos.y - 12*s.y + (water_flow % 10)*s.y, 6*s.x, 6*s.y), C_WATER)
			node.draw_rect(Rect2(hand_r_pos.x + 2*s.x, hand_r_pos.y + 2*s.y - (water_flow % 10)*s.y, 4*s.x, 4*s.y), C_WATER)
 
			# E. KAFA
			var head_pos = center + Vector2(-12, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(24, 22)*s), C_SKIN)
			node.draw_rect(Rect2(head_pos.x, head_pos.y - 4*s.y, 24*s.x, 6*s.y), C_HAIR)
			node.draw_rect(Rect2(head_pos.x - 2*s.x, head_pos.y, 4*s.x, 12*s.y), C_HAIR)
			node.draw_rect(Rect2(head_pos.x + 22*s.x, head_pos.y, 4*s.x, 12*s.y), C_HAIR)
			node.draw_rect(Rect2(head_pos.x + 4*s.x, head_pos.y + 2*s.y, 5*s.x, 4*s.y), apply_alpha.call(Color(0.6, 0.2, 0.2)))
			node.draw_rect(Rect2(head_pos.x + 5*s.x, head_pos.y + 10*s.y, 5*s.x, 5*s.y), apply_alpha.call(Color(0.6, 0.1, 0.2)))
			node.draw_rect(Rect2(head_pos.x + 14*s.x, head_pos.y + 10*s.y, 5*s.x, 5*s.y), apply_alpha.call(Color(0.6, 0.1, 0.2)))
			node.draw_rect(Rect2(head_pos.x + 22*s.x, head_pos.y + 14*s.y + bounce/2, 3*s.x, 6*s.y), apply_alpha.call(Color(0.9, 0.9, 0.9)))
			node.draw_rect(Rect2(head_pos.x + 23*s.x, head_pos.y + 16*s.y + bounce/2, 1*s.x, 2*s.y), apply_alpha.call(Color(1, 0, 0)))

		"chainsaw_hybrid":
			var C_ENGINE = apply_alpha.call(Color(1.0, 0.6, 0.0))
			var C_METAL = apply_alpha.call(Color(0.6, 0.6, 0.65))
			var C_SHIRT = apply_alpha.call(Color(0.95, 0.95, 0.95))
			var C_BLACK = apply_alpha.call(Color(0.1, 0.1, 0.15))
			var C_TEETH = apply_alpha.call(Color(0.8, 0.8, 0.8))
			var C_SKIN = apply_alpha.call(Color(0.9, 0.7, 0.6))
 
			var shake = 1 if (int(msec / 50.0) % 2 == 0) else -1
			var bounce = sin(msec / 100.0) * 1.0 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), C_SHIRT)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), C_SHIRT)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-7, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(14, 10)*s), C_SHIRT)
			node.draw_rect(Rect2(body_pos.x + 6*s.x, body_pos.y, 2*s.x, 9*s.y), C_BLACK)
			node.draw_rect(Rect2(body_pos.x + 5*s.x, body_pos.y + 8*s.y, 3*s.x, 2*s.y), C_BLACK)
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-15, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_SKIN)
			node.draw_rect(Rect2(center + Vector2(10, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_SKIN)
 
			# E. KAFA
			var head_pos = center + Vector2(-13, -14)*s + Vector2(shake * s.x, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(26, 20)*s), C_ENGINE)
			node.draw_rect(Rect2(head_pos.x + 2*s.x, head_pos.y + 4*s.y, 8*s.x, 6*s.y), apply_alpha.call(Color(0,0,0, 0.3)))
			node.draw_rect(Rect2(head_pos.x - 4*s.x, head_pos.y + 8*s.y, 4*s.x, 8*s.y), apply_alpha.call(Color(0.2, 0.2, 0.2)))
			node.draw_rect(Rect2(head_pos.x + 14*s.x, head_pos.y + 6*s.y, 24*s.x, 10*s.y), C_METAL)
 
			var chain_move = int(msec / 20.0) % 8
			node.draw_rect(Rect2(head_pos.x + (16 + chain_move)*s.x, head_pos.y + 4*s.y, 4*s.x, 2*s.y), C_TEETH)
			node.draw_rect(Rect2(head_pos.x + (26 + chain_move)*s.x, head_pos.y + 4*s.y, 4*s.x, 2*s.y), C_TEETH)
			node.draw_rect(Rect2(head_pos.x + (20 + chain_move)*s.x, head_pos.y + 16*s.y, 4*s.x, 2*s.y), C_TEETH)
 
			node.draw_rect(Rect2(head_pos.x + 8*s.x, head_pos.y + 10*s.y, 4*s.x, 4*s.y), apply_alpha.call(Color(1,1,1)))
			node.draw_rect(Rect2(head_pos.x + 9*s.x, head_pos.y + 11*s.y, 2*s.x, 2*s.y), apply_alpha.call(Color(1,0,0)))

		"lightning_ninja":
			var C_VEST = apply_alpha.call(Color(0.2, 0.35, 0.2))
			var C_UNDER = apply_alpha.call(Color(0.1, 0.1, 0.25))
			var C_HAIR = apply_alpha.call(Color(0.8, 0.85, 0.9))
			var C_ELEC = apply_alpha.call(Color(0.4, 0.8, 1.0))
			var C_EYE_RED = apply_alpha.call(Color(1.0, 0.2, 0.2))
 
			var bounce = sin(msec / 150.0) * 1.5 * s.y
			var zap = int(msec / 40.0) % 3
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), C_UNDER)
			node.draw_rect(Rect2(center + Vector2(-8, 14)*s, Vector2(6, 2)*s), apply_alpha.call(Color(0.9,0.8,0.7)))
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), C_UNDER)
			node.draw_rect(Rect2(center + Vector2(2, 14)*s, Vector2(6, 2)*s), apply_alpha.call(Color(0.9,0.8,0.7)))
 
			# C. GÖVDE
			var body_pos = center + Vector2(-8, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(16, 10)*s), C_VEST)
			node.draw_rect(Rect2(body_pos.x + 7*s.x, body_pos.y, 2*s.x, 10*s.y), apply_alpha.call(Color(0.1, 0.2, 0.1)))
			node.draw_rect(Rect2(body_pos.x - 2*s.x, body_pos.y, 2*s.x, 6*s.y), C_UNDER)
			node.draw_rect(Rect2(body_pos.x + 16*s.x, body_pos.y, 2*s.x, 6*s.y), C_UNDER)
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-15, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), apply_alpha.call(Color(0.1,0.1,0.1)))
			var hand_r_pos = center + Vector2(10, 10)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(hand_r_pos, Vector2(5, 5)*s), apply_alpha.call(Color(0.1,0.1,0.1)))
 
			var zap_size = (8 + zap * 2) * s.x
			node.draw_rect(Rect2(hand_r_pos.x - 2*s.x, hand_r_pos.y - 2*s.y, zap_size, zap_size), C_ELEC)
			if zap == 0: node.draw_rect(Rect2(hand_r_pos.x + 6*s.x, hand_r_pos.y - 6*s.y, 2*s.x, 4*s.y), apply_alpha.call(Color(1,1,1)))
			if zap == 1: node.draw_rect(Rect2(hand_r_pos.x - 4*s.x, hand_r_pos.y + 6*s.y, 4*s.x, 2*s.y), apply_alpha.call(Color(1,1,1)))
 
			# E. KAFA
			var head_pos = center + Vector2(-12, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(24, 22)*s), apply_alpha.call(Color(0.9, 0.8, 0.7)))
			node.draw_rect(Rect2(head_pos.x, head_pos.y + 12*s.y, 24*s.x, 10*s.y), apply_alpha.call(Color(0.1, 0.1, 0.2)))
			node.draw_rect(Rect2(head_pos.x, head_pos.y + 2*s.y, 24*s.x, 6*s.y), apply_alpha.call(Color(0.1, 0.1, 0.2)))
			node.draw_rect(Rect2(head_pos.x + 6*s.x, head_pos.y + 3*s.y, 12*s.x, 4*s.y), apply_alpha.call(Color(0.7, 0.7, 0.8)))
 
			node.draw_rect(Rect2(head_pos.x + 6*s.x, head_pos.y + 9*s.y, 4*s.x, 2*s.y), apply_alpha.call(Color(0,0,0)))
			node.draw_rect(Rect2(head_pos.x + 14*s.x, head_pos.y + 8*s.y, 2*s.x, 6*s.y), apply_alpha.call(Color(0.6, 0.3, 0.3)))
			node.draw_rect(Rect2(head_pos.x + 14*s.x, head_pos.y + 9*s.y, 4*s.x, 2*s.y), C_EYE_RED)
 
			node.draw_rect(Rect2(head_pos.x - 2*s.x, head_pos.y - 6*s.y, 20*s.x, 8*s.y), C_HAIR)
			node.draw_rect(Rect2(head_pos.x + 14*s.x, head_pos.y - 8*s.y, 8*s.x, 10*s.y), C_HAIR)

		"thorfinn":
			var C_HAIR = apply_alpha.call(Color(0.85, 0.75, 0.4))
			var C_LEATHER_DARK = apply_alpha.call(Color(0.3, 0.2, 0.1))
			var C_TUNIC = apply_alpha.call(Color(0.7, 0.65, 0.55))
			var C_STEEL = apply_alpha.call(Color(0.6, 0.65, 0.7))
			var C_SKIN_DIRTY = apply_alpha.call(Color(0.85, 0.7, 0.6))
 
			var bounce = sin(msec / 100.0) * 1.5 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), C_LEATHER_DARK)
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 2)*s), C_TUNIC)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), C_LEATHER_DARK)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 2)*s), C_TUNIC)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-7, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(14, 10)*s), C_TUNIC)
			node.draw_rect(Rect2(body_pos.x, body_pos.y, 14*s.x, 6*s.y), C_LEATHER_DARK)
			node.draw_rect(Rect2(body_pos.x + 6*s.x, body_pos.y + 6*s.y, 2*s.x, 2*s.y), apply_alpha.call(Color(0.5, 0.4, 0.3)))
 
			# D. ELLER
			var hand_l_pos = center + Vector2(-15, 8)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(hand_l_pos, Vector2(5, 5)*s), C_LEATHER_DARK)
			node.draw_rect(Rect2(hand_l_pos.x + 1*s.x, hand_l_pos.y + 4*s.y, 3*s.x, 8*s.y), C_STEEL)
			node.draw_rect(Rect2(hand_l_pos.x, hand_l_pos.y - 2*s.y, 5*s.x, 2*s.y), C_LEATHER_DARK)
 
			var hand_r_pos = center + Vector2(10, 8)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(hand_r_pos, Vector2(5, 5)*s), C_LEATHER_DARK)
			node.draw_rect(Rect2(hand_r_pos.x + 1*s.x, hand_r_pos.y - 6*s.y, 3*s.x, 8*s.y), C_STEEL)
			node.draw_rect(Rect2(hand_r_pos.x, hand_r_pos.y + 4*s.y, 5*s.x, 2*s.y), C_LEATHER_DARK)
 
			# E. KAFA
			var head_pos = center + Vector2(-13, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_SKIN_DIRTY)
			node.draw_rect(Rect2(head_pos.x + 4*s.x, head_pos.y + 14*s.y, 3*s.x, 2*s.y), apply_alpha.call(Color(0.4, 0.3, 0.2, 0.5)))
			node.draw_rect(Rect2(head_pos.x + 18*s.x, head_pos.y + 16*s.y, 2*s.x, 2*s.y), apply_alpha.call(Color(0.4, 0.3, 0.2, 0.5)))
			
			node.draw_rect(Rect2(head_pos.x + 4*s.x, head_pos.y + 8*s.y, 6*s.x, 2*s.y), C_HAIR)
			node.draw_rect(Rect2(head_pos.x + 16*s.x, head_pos.y + 8*s.y, 6*s.x, 2*s.y), C_HAIR)
			node.draw_rect(Rect2(head_pos.x + 6*s.x, head_pos.y + 10*s.y, 4*s.x, 3*s.y), apply_alpha.call(Color(0.2, 0.1, 0)))
			node.draw_rect(Rect2(head_pos.x + 16*s.x, head_pos.y + 10*s.y, 4*s.x, 3*s.y), apply_alpha.call(Color(0.2, 0.1, 0)))
 
			node.draw_rect(Rect2(head_pos.x - 2*s.x, head_pos.y - 6*s.y, 30*s.x, 8*s.y), C_HAIR)
			node.draw_rect(Rect2(head_pos.x - 4*s.x, head_pos.y - 2*s.y, 6*s.x, 12*s.y), C_HAIR)
			node.draw_rect(Rect2(head_pos.x + 24*s.x, head_pos.y, 4*s.x, 10*s.y), C_HAIR)
			node.draw_rect(Rect2(head_pos.x + 10*s.x, head_pos.y, 6*s.x, 4*s.y), C_HAIR)

		"cosmic_emperor":
			var C_VOID_DARK = apply_alpha.call(Color(0.08, 0.05, 0.12))
			var C_ARMOR_GOLD = apply_alpha.call(Color(0.9, 0.75, 0.3))
			var C_PLANET_RED = apply_alpha.call(Color(1.0, 0.3, 0.2))
			var C_PLANET_BLUE = apply_alpha.call(Color(0.2, 0.6, 1.0))
			var C_NEBULA_GRN = apply_alpha.call(Color(0.3, 0.9, 0.5))
			var C_STAR_CORE = apply_alpha.call(Color(1.0, 1.0, 0.8))
 
			var bounce = sin(msec / 250.0) * 2.0 * s.y
			var orbit_time = msec / 600.0
 
			var vortex_slow = msec / 400.0
			var vortex_fast = -msec / 250.0
 
			var orbit_y_center = center.y - 6*s.y + bounce
			var p1_x = cos(orbit_time) * 26.0 * s.x
			var p1_y = sin(orbit_time) * 6.0 * s.y
			var p1_z = sin(orbit_time)
 
			var p2_x = cos(orbit_time + PI) * 26.0 * s.x
			var p2_y = sin(orbit_time + PI) * 6.0 * s.y
			var p2_z = sin(orbit_time + PI)
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 20)*s, 7*s.x, shadow_col)
 
			# B. ARKA PLANETLER
			if p1_z < 0: node.draw_rect(Rect2(center.x + p1_x - 3*s.x, orbit_y_center + p1_y, 7*s.x, 7*s.y), C_PLANET_RED)
			if p2_z < 0: node.draw_rect(Rect2(center.x + p2_x - 3*s.x, orbit_y_center + p2_y + 4*s.y, 6*s.x, 6*s.y), C_PLANET_BLUE)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-8, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(16, 12)*s), C_VOID_DARK)
			node.draw_rect(Rect2(body_pos.x - 5*s.x, body_pos.y - 3*s.y, 6*s.x, 9*s.y), C_ARMOR_GOLD)
			node.draw_rect(Rect2(body_pos.x + 15*s.x, body_pos.y - 3*s.y, 6*s.x, 9*s.y), C_ARMOR_GOLD)
			node.draw_rect(Rect2(body_pos.x + 5*s.x, body_pos.y + 1*s.y, 6*s.x, 10*s.y), C_ARMOR_GOLD)
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-17, 8)*s + Vector2(0, bounce), Vector2(6, 6)*s), C_ARMOR_GOLD)
			node.draw_rect(Rect2(center + Vector2(11, 8)*s + Vector2(0, bounce), Vector2(6, 6)*s), C_ARMOR_GOLD)
 
			# E. KAFA
			var head_pos = center + Vector2(-13, -14)*s + Vector2(0, bounce)
			var head_center = head_pos + Vector2(13, 12)*s
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_VOID_DARK)
			
			var r1 = 9.0 * s.x
			node.draw_rect(Rect2(head_center.x + cos(vortex_slow)*r1, head_center.y + sin(vortex_slow)*r1, 2*s.x, 2*s.y), C_PLANET_BLUE)
			node.draw_rect(Rect2(head_center.x + cos(vortex_slow + 2)*r1, head_center.y + sin(vortex_slow + 2)*r1, 2*s.x, 2*s.y), C_PLANET_BLUE)
			var r2 = 6.0 * s.x
			node.draw_rect(Rect2(head_center.x + cos(vortex_fast)*r2 - 1*s.x, head_center.y + sin(vortex_fast)*r2 - 1*s.y, 3*s.x, 3*s.y), C_NEBULA_GRN)
			node.draw_rect(Rect2(head_center.x + cos(vortex_fast + PI)*r2, head_center.y + sin(vortex_fast + PI)*r2, 2*s.x, 2*s.y), C_STAR_CORE)
			node.draw_rect(Rect2(head_center.x - 2*s.x, head_center.y - 2*s.y, 5*s.x, 5*s.y), C_PLANET_RED)
 
			var crown_y = head_pos.y - 9*s.y + sin(orbit_time*2) * 1.5 * s.y
			node.draw_rect(Rect2(head_pos.x + 1*s.x, crown_y, 24*s.x, 5*s.y), C_ARMOR_GOLD)
 
			# F. ÖN PLANETLER
			if p1_z >= 0: node.draw_rect(Rect2(center.x + p1_x - 3*s.x, orbit_y_center + p1_y, 7*s.x, 7*s.y), C_PLANET_RED)
			if p2_z >= 0: node.draw_rect(Rect2(center.x + p2_x - 3*s.x, orbit_y_center + p2_y + 4*s.y, 6*s.x, 6*s.y), C_PLANET_BLUE)
 
			# G. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-9, 14)*s, Vector2(7, 8)*s), C_ARMOR_GOLD)
			node.draw_rect(Rect2(center + Vector2(2, 14)*s, Vector2(7, 8)*s), C_ARMOR_GOLD)

		"ufo_pilot":
			var C_SAUCER_METAL = apply_alpha.call(Color(0.7, 0.7, 0.75))
			var C_SAUCER_DARK = apply_alpha.call(Color(0.4, 0.4, 0.45))
			var C_GLASS = apply_alpha.call(Color(0.6, 0.9, 1.0, 0.4))
			var C_ALIEN_SKIN = apply_alpha.call(Color(0.2, 0.8, 0.2))
			var C_THRUST = apply_alpha.call(Color(0.2, 1.0, 0.8))
 
			var hover = sin(msec / 200.0) * 3.0 * s.y
			var lights_rot = msec / 100.0
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 24)*s, 7*s.x, shadow_col)
 
			# B. MOTOR ALEVLERİ
			var thrust_len = (6 + (randf() * 4.0)) * s.y
			var thrust_pos = center + Vector2(0, 14)*s + Vector2(0, hover)
			node.draw_rect(Rect2(thrust_pos.x - 3*s.x, thrust_pos.y, 6*s.x, thrust_len), C_THRUST)
			node.draw_rect(Rect2(thrust_pos.x - 1*s.x, thrust_pos.y, 2*s.x, thrust_len - 2*s.y), apply_alpha.call(Color(1,1,1)))
 
			# C. UFO GÖVDESİ
			var saucer_y = center.y + 6*s.y + hover
			node.draw_rect(Rect2(center.x - 9*s.x, saucer_y, 18*s.x, 6*s.y), C_SAUCER_METAL)
			node.draw_rect(Rect2(center.x - 5*s.x, saucer_y + 4*s.y, 10*s.x, 4*s.y), C_SAUCER_DARK)
 
			for i in range(3):
				var angle = lights_rot + (i * (PI * 2.0 / 3.0))
				var lx = cos(angle) * 14.0 * s.x
				var ly = sin(angle) * 3.0 * s.y
				if sin(angle) > 0:
					node.draw_rect(Rect2(center.x + lx - 1*s.x, saucer_y + ly - 1*s.y, 3*s.x, 3*s.y), apply_alpha.call(Color(1, 0, 0)))
 
			# D. UZAYLI
			var pilot_y = saucer_y - 8*s.y
			node.draw_rect(Rect2(center.x - 4*s.x, pilot_y, 8*s.x, 6*s.y), apply_alpha.call(Color(0.1, 0.1, 0.1)))
			var alien_head_pos = Vector2(center.x - 7*s.x, pilot_y - 10*s.y)
			node.draw_rect(Rect2(alien_head_pos, Vector2(14, 12)*s), C_ALIEN_SKIN)
			node.draw_rect(Rect2(alien_head_pos.x + 1*s.x, alien_head_pos.y + 4*s.y, 4*s.x, 6*s.y), apply_alpha.call(Color(0,0,0)))
			node.draw_rect(Rect2(alien_head_pos.x + 9*s.x, alien_head_pos.y + 4*s.y, 4*s.x, 6*s.y), apply_alpha.call(Color(0,0,0)))
 
			node.draw_rect(Rect2(center.x - 8*s.x, pilot_y + 2*s.y, 4*s.x, 4*s.y), C_ALIEN_SKIN)
			node.draw_rect(Rect2(center.x + 4*s.x, pilot_y + 2*s.y, 4*s.x, 4*s.y), C_ALIEN_SKIN)
 
			# E. CAM FANUS
			var glass_pos = Vector2(center.x - 12*s.x, pilot_y - 12*s.y)
			node.draw_rect(Rect2(glass_pos, Vector2(24, 18)*s), C_GLASS)
			node.draw_rect(Rect2(glass_pos.x + 4*s.x, glass_pos.y + 4*s.y, 4*s.x, 4*s.y), apply_alpha.call(Color(1,1,1, 0.6)))

		"spectral_ghost":
			var C_GHOST_BODY = apply_alpha.call(Color(0.2, 1.0, 0.8, 0.5))
			var C_GHOST_SOLID = apply_alpha.call(Color(0.2, 1.0, 0.8, 0.9))
			var C_BONES = apply_alpha.call(Color(0.9, 0.9, 1.0, 0.7))
			var C_EYE_GLOW = apply_alpha.call(Color(1.0, 1.0, 0.2, 1.0))
 
			var wave = sin(msec / 300.0) * 2.0 * s.y
			var float_hand = cos(msec / 250.0) * 2.0 * s.y
 
			# A. YER IŞIĞI
			node.draw_circle(center + Vector2(0, 22)*s, 5*s.x, apply_alpha.call(Color(0.2, 1.0, 0.8, 0.2)))
 
			# B. KUYRUK
			var tail_y = center.y + 12*s.y + wave
			node.draw_rect(Rect2(center.x - 4*s.x, tail_y, 8*s.x, 6*s.y), C_GHOST_BODY)
			node.draw_rect(Rect2(center.x - 2*s.x + wave, tail_y + 6*s.y, 4*s.x, 6*s.y), C_GHOST_BODY)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-8, 6)*s + Vector2(0, wave)
			node.draw_rect(Rect2(body_pos, Vector2(16, 12)*s), C_GHOST_BODY)
			node.draw_rect(Rect2(body_pos.x + 4*s.x, body_pos.y + 3*s.y, 8*s.x, 1*s.y), C_BONES)
			node.draw_rect(Rect2(body_pos.x + 4*s.x, body_pos.y + 6*s.y, 8*s.x, 1*s.y), C_BONES)
			node.draw_rect(Rect2(body_pos.x + 4*s.x, body_pos.y + 9*s.y, 8*s.x, 1*s.y), C_BONES)
 
			# D. ELLER ve KILIÇ
			var hand_l_pos = center + Vector2(-18, 8)*s + Vector2(0, wave + float_hand)
			node.draw_rect(Rect2(hand_l_pos, Vector2(6, 6)*s), C_GHOST_SOLID)
 
			var hand_r_pos = center + Vector2(12, 8)*s + Vector2(0, wave - float_hand)
			node.draw_rect(Rect2(hand_r_pos, Vector2(6, 6)*s), C_GHOST_SOLID)
			node.draw_rect(Rect2(hand_r_pos.x + 2*s.x, hand_r_pos.y - 8*s.y, 2*s.x, 14*s.y), apply_alpha.call(Color(1,1,1,0.6))) # KILIÇ
 
			# E. KAFA
			var head_pos = center + Vector2(-12, -14)*s + Vector2(0, wave)
			node.draw_rect(Rect2(head_pos, Vector2(24, 22)*s), C_GHOST_BODY)
			node.draw_rect(Rect2(head_pos.x - 6*s.x, head_pos.y - 6*s.y, 36*s.x, 6*s.y), apply_alpha.call(Color(0.1, 0.1, 0.2, 0.8)))
			node.draw_rect(Rect2(head_pos.x + 2*s.x, head_pos.y - 12*s.y, 20*s.x, 8*s.y), apply_alpha.call(Color(0.1, 0.1, 0.2, 0.8)))
			node.draw_rect(Rect2(head_pos.x + 6*s.x, head_pos.y + 10*s.y, 4*s.x, 4*s.y), C_EYE_GLOW)
			node.draw_rect(Rect2(head_pos.x + 16*s.x, head_pos.y + 10*s.y, 4*s.x, 4*s.y), C_EYE_GLOW)
			node.draw_rect(Rect2(head_pos.x + 11*s.x, head_pos.y + 16*s.y, 2*s.x, 3*s.y), C_GHOST_SOLID)

		"medusa":
			var C_SKIN_GREEN = apply_alpha.call(Color(0.4, 0.7, 0.4))
			var C_SNAKE_DARK = apply_alpha.call(Color(0.2, 0.5, 0.2))
			var C_SNAKE_LITE = apply_alpha.call(Color(0.5, 0.8, 0.5))
			var C_GOLD_JEWEL = apply_alpha.call(Color(1.0, 0.8, 0.0))
			var C_EYE_STONE = apply_alpha.call(Color(1.0, 1.0, 0.8))
			var C_DRESS = apply_alpha.call(Color(0.9, 0.9, 0.8))
 
			var breathe = sin(msec / 300.0) * 1.5 * s.y
			var snake_wiggle = float(msec) / 200.0
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. ETEK
			var skirt_pos = center + Vector2(-8, 10)*s
			node.draw_rect(Rect2(skirt_pos, Vector2(16, 8)*s), C_DRESS)
			node.draw_rect(Rect2(skirt_pos.x + 4*s.x, skirt_pos.y, 1*s.x, 8*s.y), apply_alpha.call(Color(0.8, 0.8, 0.7)))
			node.draw_rect(Rect2(skirt_pos.x + 10*s.x, skirt_pos.y, 1*s.x, 8*s.y), apply_alpha.call(Color(0.8, 0.8, 0.7)))
 
			# C. GÖVDE
			var body_pos = center + Vector2(-7, 6)*s + Vector2(0, breathe)
			node.draw_rect(Rect2(body_pos, Vector2(14, 10)*s), C_DRESS)
			node.draw_rect(Rect2(body_pos.x + 1*s.x, body_pos.y + 6*s.y, 12*s.x, 2*s.y), C_GOLD_JEWEL)
			node.draw_rect(Rect2(body_pos.x + 2*s.x, body_pos.y - 2*s.y, 10*s.x, 4*s.y), C_SKIN_GREEN)
 
			# D. ELLER
			node.draw_rect(Rect2(center + Vector2(-15, 8)*s + Vector2(0, breathe), Vector2(5, 5)*s), C_SKIN_GREEN)
			node.draw_rect(Rect2(center + Vector2(10, 8)*s + Vector2(0, breathe), Vector2(5, 5)*s), C_SKIN_GREEN)
 
			# E. KAFA
			var head_pos = center + Vector2(-12, -14)*s + Vector2(0, breathe)
			node.draw_rect(Rect2(head_pos, Vector2(24, 22)*s), C_SKIN_GREEN)
			node.draw_rect(Rect2(head_pos.x + 5*s.x, head_pos.y + 10*s.y, 5*s.x, 3*s.y), C_EYE_STONE)
			node.draw_rect(Rect2(head_pos.x + 14*s.x, head_pos.y + 10*s.y, 5*s.x, 3*s.y), C_EYE_STONE)
			node.draw_rect(Rect2(head_pos.x + 9*s.x, head_pos.y + 16*s.y, 6*s.x, 2*s.y), C_SNAKE_DARK)
 
			# YILAN SAÇLAR
			for i in range(5):
				var offset = i * 1.5
				var sway_x = cos(snake_wiggle + offset) * 3.0 * s.x
				var sway_y = sin(snake_wiggle + offset) * 2.0 * s.y
				var root_x = head_pos.x + (2 + i * 4) * s.x
				var root_y = head_pos.y - 2 * s.y
				node.draw_rect(Rect2(root_x, root_y - 4*s.y, 4*s.x, 6*s.y), C_SNAKE_DARK)
				var snake_head_x = root_x + sway_x
				var snake_head_y = root_y - 8*s.y + sway_y
				node.draw_rect(Rect2(snake_head_x, snake_head_y, 4*s.x, 4*s.y), C_SNAKE_LITE)
				if sin((snake_wiggle + i)*3) > 0.8:
					node.draw_rect(Rect2(snake_head_x + 1*s.x, snake_head_y - 2*s.y, 2*s.x, 2*s.y), apply_alpha.call(Color(1, 0.2, 0.2)))
 
			var earring_sway = sin(snake_wiggle) * 1.0 * s.y
			node.draw_rect(Rect2(head_pos.x - 1*s.x, head_pos.y + 14*s.y + earring_sway, 2*s.x, 4*s.y), C_GOLD_JEWEL)
			node.draw_rect(Rect2(head_pos.x + 23*s.x, head_pos.y + 14*s.y + earring_sway, 2*s.x, 4*s.y), C_GOLD_JEWEL)

		"anubis":
			var C_GOLD = apply_alpha.call(Color(1.0, 0.8, 0.2))
			var C_BLACK_SKIN = apply_alpha.call(Color(0.1, 0.1, 0.12))
			var C_EGYPT_BLU = apply_alpha.call(Color(0.1, 0.6, 0.8))
			var C_CLOTH_WHT = apply_alpha.call(Color(0.9, 0.9, 0.8))
			var _C_EYE_GLOW = apply_alpha.call(Color(0.2, 1.0, 0.8))
 
			var breathe = sin(msec / 250.0) * 1.5 * s.y
 
			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)
 
			# B. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), C_BLACK_SKIN)
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 2)*s), C_GOLD)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), C_BLACK_SKIN)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 2)*s), C_GOLD)
 
			# C. GÖVDE
			var body_pos = center + Vector2(-7, 6)*s + Vector2(0, breathe)
			node.draw_rect(Rect2(body_pos, Vector2(14, 10)*s), C_BLACK_SKIN)
			node.draw_rect(Rect2(body_pos.x, body_pos.y + 8*s.y, 14*s.x, 4*s.y), C_CLOTH_WHT)
			node.draw_rect(Rect2(body_pos.x + 5*s.x, body_pos.y + 8*s.y, 4*s.x, 6*s.y), C_EGYPT_BLU)
			node.draw_rect(Rect2(body_pos.x - 2*s.x, body_pos.y, 18*s.x, 4*s.y), C_GOLD)
			node.draw_rect(Rect2(body_pos.x + 7*s.x, body_pos.y, 2*s.x, 4*s.y), C_EGYPT_BLU)
 
			# D. ELLER ve ASA
			node.draw_rect(Rect2(center + Vector2(-15, 8)*s + Vector2(0, breathe), Vector2(5, 5)*s), C_BLACK_SKIN)
			node.draw_rect(Rect2(center.x - 15*s.x, center.y + 11*s.y + breathe, 5*s.x, 2*s.y), C_GOLD)
 
			var hand_r_pos = center + Vector2(10, 8)*s + Vector2(0, breathe)
			node.draw_rect(Rect2(hand_r_pos, Vector2(5, 5)*s), C_BLACK_SKIN)
			node.draw_rect(Rect2(hand_r_pos.x, hand_r_pos.y + 3*s.y, 5*s.x, 2*s.y), C_GOLD)
			node.draw_rect(Rect2(hand_r_pos.x + 2*s.x, hand_r_pos.y - 12*s.y, 2*s.x, 24*s.y), C_GOLD)
			node.draw_rect(Rect2(hand_r_pos.x, hand_r_pos.y - 14*s.y, 6*s.x, 2*s.y), C_EGYPT_BLU)
			node.draw_rect(Rect2(hand_r_pos.x - 1*s.x, hand_r_pos.y - 16*s.y, 8*s.x, 2*s.y), C_GOLD)
 
			# E. KAFA
			var head_pos = center + Vector2(-12, -14)*s + Vector2(0, breathe)
			node.draw_rect(Rect2(head_pos, Vector2(24, 22)*s), C_BLACK_SKIN)
			node.draw_rect(Rect2(head_pos.x - 2*s.x, head_pos.y, 4*s.x, 20*s.y), C_GOLD)
			node.draw_rect(Rect2(head_pos.x + 22*s.x, head_pos.y, 4*s.x, 20*s.y), C_GOLD)
			node.draw_rect(Rect2(head_pos.x, head_pos.y - 2*s.y, 24*s.x, 6*s.y), C_GOLD)
			node.draw_rect(Rect2(head_pos.x + 2*s.x, head_pos.y - 12*s.y, 6*s.x, 12*s.y), C_BLACK_SKIN)
			node.draw_rect(Rect2(head_pos.x + 16*s.x, head_pos.y - 12*s.y, 6*s.x, 12*s.y), C_BLACK_SKIN)
			node.draw_rect(Rect2(head_pos.x + 4*s.x, head_pos.y - 10*s.y, 2*s.x, 8*s.y), C_GOLD)
			node.draw_rect(Rect2(head_pos.x + 18*s.x, head_pos.y - 10*s.y, 2*s.x, 8*s.y), C_GOLD)
			node.draw_rect(Rect2(head_pos.x + 8*s.x, head_pos.y + 12*s.y, 8*s.x, 8*s.y), C_BLACK_SKIN)
			node.draw_rect(Rect2(head_pos.x + 10*s.x, head_pos.y + 18*s.y, 4*s.x, 2*s.y), apply_alpha.call(Color(0,0,0)))
			node.draw_rect(Rect2(head_pos.x + 3*s.x, head_pos.y + 9*s.y, 8*s.x, 4*s.y), apply_alpha.call(Color(0,0,0)))
			node.draw_rect(Rect2(head_pos.x + 13*s.x, head_pos.y + 9*s.y, 8*s.x, 4*s.y), apply_alpha.call(Color(0,0,0)))

		"dark_knight":
			var C_SUIT_DARK = apply_alpha.call(Color(0.15, 0.15, 0.18))
			var C_SUIT_GREY = apply_alpha.call(Color(0.3, 0.3, 0.35))
			var C_BELT = apply_alpha.call(Color(1.0, 0.8, 0.0))
			var C_FACE = apply_alpha.call(Color(0.9, 0.7, 0.6))
			var C_CAPE = apply_alpha.call(Color(0.1, 0.1, 0.12))
			var C_EYES = apply_alpha.call(Color(1.0, 1.0, 1.0))
			var bounce = sin(msec / 200.0) * 2.0 * s.y

			# A. GÖLGE
			node.draw_circle(center + Vector2(0, 18)*s, 8*s.x, shadow_col)

			# B. PELERİN (Arka)
			var cape_sway = sin(msec / 300.0) * 2.0 * s.x
			node.draw_rect(Rect2(center.x - 10*s.x + cape_sway, center.y + 4*s.y + bounce, 20*s.x, 14*s.y), C_CAPE)

			# C. AYAKLAR
			node.draw_rect(Rect2(center + Vector2(-8, 12)*s, Vector2(6, 6)*s), C_SUIT_DARK)
			node.draw_rect(Rect2(center + Vector2(2, 12)*s, Vector2(6, 6)*s), C_SUIT_DARK)

			# D. GÖVDE (Zırh)
			var body_pos = center + Vector2(-8, 6)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(body_pos, Vector2(16, 12)*s), C_SUIT_GREY)

			# Yarasa Sembolü (Basit)
			node.draw_rect(Rect2(body_pos.x + 4*s.x, body_pos.y + 2*s.y, 8*s.x, 3*s.y), C_SUIT_DARK)

			# Kemer
			node.draw_rect(Rect2(body_pos.x, body_pos.y + 10*s.y, 16*s.x, 2*s.y), C_BELT)
			node.draw_rect(Rect2(body_pos.x + 6*s.x, body_pos.y + 10*s.y, 4*s.x, 3*s.y), C_BELT)

			# E. ELLER
			node.draw_rect(Rect2(center + Vector2(-15, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_SUIT_DARK)
			node.draw_rect(Rect2(center + Vector2(10, 8)*s + Vector2(0, bounce), Vector2(5, 5)*s), C_SUIT_DARK)

			# F. KAFA (Maske)
			var head_pos = center + Vector2(-13, -14)*s + Vector2(0, bounce)
			node.draw_rect(Rect2(head_pos, Vector2(26, 24)*s), C_SUIT_DARK)

			# Çene (Açık)
			node.draw_rect(Rect2(head_pos.x + 8*s.x, head_pos.y + 18*s.y, 10*s.x, 6*s.y), C_FACE)

			# Gözler (Beyaz)
			node.draw_rect(Rect2(head_pos.x + 6*s.x, head_pos.y + 12*s.y, 5*s.x, 3*s.y), C_EYES)
			node.draw_rect(Rect2(head_pos.x + 15*s.x, head_pos.y + 12*s.y, 5*s.x, 3*s.y), C_EYES)

			# Kulaklar
			node.draw_rect(Rect2(head_pos.x, head_pos.y - 6*s.y, 4*s.x, 6*s.y), C_SUIT_DARK)
			node.draw_rect(Rect2(head_pos.x + 22*s.x, head_pos.y - 6*s.y, 4*s.x, 6*s.y), C_SUIT_DARK)
