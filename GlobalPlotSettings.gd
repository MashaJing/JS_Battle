extends Node

var DEFAULT_GAME_OVER_PATH = "res://Cutscenes/GameOver/GameOver.tscn"
var CRINGE_GAME_OVER_PATH = "res://Cutscenes/CringeGameOver/CringeGameOver.tscn"
var CRINGE_ATTACK_PATH = "res://Attacks/CringeAttack/CringeAttack.tscn"

# =================== vital paths  ===================
const GAME_SCENE_PATH = "res://Main.tscn"
const CUTSCENES_ROOT_PATH = "res://Cutscenes"

# =================== CUTSCENES =====================
const CUTSCENES = {
	pre_battle = CUTSCENES_ROOT_PATH + "/PreBattle/PreBattleDialogue.tscn",
	jevil_down = CUTSCENES_ROOT_PATH + "/JevilDown/JevilDown.tscn",
	spam_down = CUTSCENES_ROOT_PATH + "/SpamDown/SpamDown.tscn",
	# unused
	cringe_game_over = CUTSCENES_ROOT_PATH + "/JevilDown/JevilDown.tscn",
	game_over = CUTSCENES_ROOT_PATH + "/GameOver/GameOver.tscn"
}

# =================== PLOT EVENTS ===================
var FIRST_LAUNCH = true
var SUMMONED_ANGEL = false
var MADE_UP = false
var JEVIL_UP = true
var SPAMTON_UP = true
var BOTH_ALIVE = JEVIL_UP and SPAMTON_UP
# выкидывать первые две фазы, если они помирились - глобально задать первой фазой 2
var CRINGE_ATTACKS_ON = MADE_UP and BOTH_ALIVE


func get_game_over(state):
	if state == "cringe_attack":
		return CRINGE_GAME_OVER_PATH
	else:
		return DEFAULT_GAME_OVER_PATH

func reset():
	FIRST_LAUNCH = false
	Dialogic.set_variable("first_launch", FIRST_LAUNCH)
