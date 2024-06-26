# глобально храним только путь до нужной сцены.
# Отсюда все сцены будут получать инфу о том, куда им дальше переключаться
extends Node2D

class Phase:
	var root_path
	var attacks
	var is_played_once
	var break_condition
	var threshold

	func _init(root_path, attacks, break_condition, threshold, is_played_once=false):
		self.root_path = root_path
		self.attacks = []
		for attack in attacks:
			self.attacks.append(root_path + attack)
		self.break_condition = break_condition  # при is_played_once=false - условие выхода из цикла
		self.threshold = threshold
		self.is_played_once = is_played_once  # true - фаза не зацикливается


var PHASE_0 = [
#	CUTSCENES.pre_battle,
	"/Dimonds_Minitons/Attack1.tscn",
	"/DullSpamton/DullSpamton.tscn",
	"/DullJevil/DullJevil.tscn",
]

var PHASE_1 = [
	"/MonologueAttack.tscn",
]

var PHASE_2 = [
#	 "/TestAttack/PwdAttack.tscn",
	"/Attack3/Attack3.tscn",
#	"/NoseAttack/NoseAttack.tscn",
]
var PHASE_3 = [
#	__________ PHASE 2 ____________ (отделить папками и тут как-то)	
#	"/CardPlay/Party/Party.tscn",
#	"/CarouselKids/CarouselKids.tscn",
	"/SharedForm/SharedForm.tscn",
#	 "/NoseAttack/NoseAttack.tscn", # переводить в этой фазе в другой режим
#	__________ PHASE 3 ____________ (отделить папками и тут как-то)
#	"/TestAttack/PwdAttack.tscn",
#	"res://Attacks/MadSpamAttack/MadSpamAttack.tscn",
#	"/Attack2/Attack2.tscn",
]

var PHASE_4 = [
#	Phase.Phase2 + "/MilkAttack/MilkAttack.tscn",
#	Phase.Phase3 + "/SharedForm/SharedForm.tscn",
	"/UnusedJevilAttack/UnusedJevilAttack.tscn",
#	Phase.Phase2 + "/BallFallingAttack/BallFallingAttack.tscn",	
]

var PHASE_ULTIMATE = [
	"/BadAnimation/BadAnimation.tscn",
]

var Phases = [
#	Phase.new("res://Attacks/DullAttacks", PHASE_0),
#	Phase.new("res://Attacks/DramaAttacks", PHASE_1, "compare_hp", 10, true),
	Phase.new("res://Attacks/Phase2", PHASE_2, "compare_hp", 9, true),
	Phase.new("res://Attacks/Phase3", PHASE_3, "compare_hp", 5),
	Phase.new("res://Attacks/Phase3", PHASE_4, "compare_hp", 3),
	Phase.new("res://Attacks/UltimateAttack", PHASE_ULTIMATE, "compare_hp", 0),
]

var GAME_OVER_PATH = "res://Cutscenes/GameOver/GameOver.tscn"
var CRINGE_GAME_OVER_PATH = "res://Cutscenes/CringeGameOver/CringeGameOver.tscn"
var CRINGE_ATTACK_PATH = "res://Attacks/CringeAttack/CringeAttack.tscn"

# =================== vital paths  ===================
const ROOT_SCENE_PATH = "res://Main.tscn"
const CUTSCENES_ROOT_PATH = "res://Cutscenes"

# =================== PLOT EVENTS ===================
var MADE_UP = false
var BOTH_ALIVE = true
# выкидывать первые две фазы, если они помирились - глобально задать первой фазой 2
var CRINGE_ATTACKS_ON = MADE_UP and BOTH_ALIVE

# =================== CUTSCENES =====================
const CUTSCENES = {
	pre_battle = CUTSCENES_ROOT_PATH + "/PreBattle/PreBattleDialogue.tscn",
	jevil_down = CUTSCENES_ROOT_PATH + "/JevilDown/JevilDown.tscn",
	spam_down = CUTSCENES_ROOT_PATH + "/SpamDown/SpamDown.tscn",
	# unused
	cringe_game_over = CUTSCENES_ROOT_PATH + "/JevilDown/JevilDown.tscn",
	game_over = CUTSCENES_ROOT_PATH + "/GameOver/GameOver.tscn"
}

var ATTACK_INDEX = -1

# меняется только извне
var PHASE_INDEX = 0

var MAD_SPAM = []


# возвращает путь до следующей атаки
func get_next_attack():
	ATTACK_INDEX += 1

	if ATTACK_INDEX >= len(Phases[PHASE_INDEX].attacks):
		ATTACK_INDEX = 0

		# окончание не зацикленной фазы
		if Phases[PHASE_INDEX].is_played_once:
			PHASE_INDEX += 1
			return Phases[PHASE_INDEX].attacks[ATTACK_INDEX]

	# окончание зацикленной фазы по специальному условию
	if ConStats.call(Phases[PHASE_INDEX].break_condition, Phases[PHASE_INDEX].threshold):
		ATTACK_INDEX = 0
		PHASE_INDEX += 1

	return Phases[PHASE_INDEX].attacks[ATTACK_INDEX]


func _on_jevil_down():
	Phases[PHASE_INDEX].attacks.insert(PHASE_INDEX+1, [CUTSCENES.jevil_down])
	Phases[PHASE_INDEX].attacks.resize(ATTACK_INDEX+2)


func _on_spam_down():
	Phases[PHASE_INDEX].attacks.insert(ATTACK_INDEX+1, [CUTSCENES.spam_down])
	Phases[PHASE_INDEX].attacks.resize(ATTACK_INDEX+2)
