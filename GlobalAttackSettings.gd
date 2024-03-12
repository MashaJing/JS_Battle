# глобально храним только путь до нужной сцены.
# Отсюда все сцены будут получать инфу о том, куда им дальше переключаться
extends Node2D

const Phase = {
# ну и херь, как-то надо избежать повторения
 Dull= "res://Attacks/DullAttacks",
 Drama=  "res://Attacks/DramaAttacks",
 Phase2= "res://Attacks/Phase2",
 Phase3= "res://Attacks/Phase3",
 Ultimate= "res://Attacks/UltimateAttack"
}

var GAME_OVER_PATH = "res://Cutscenes/GameOver/GameOver.tscn"
var CRINGE_GAME_OVER_PATH = "res://Cutscenes/CringeGameOver/CringeGameOver.tscn"
var CRINGE_ATTACK_PATH = "res://Attacks/CringeAttack/CringeAttack.tscn"

# =================== vital paths  ===================
const ROOT_SCENE_PATH = "res://Main.tscn"
const ATTACKS_ROOT_PATH = "res://Attacks"
const CUTSCENES_ROOT_PATH = "res://Cutscenes"

# =================== PLOT EVENTS ===================
var MADE_UP = false
var BOTH_ALIVE = true
#var CRINGE_ATTACKS_ON = MADE_UP and BOTH_ALIVE

# =================== CUTSCENES =====================
const CUTSCENES = {
	pre_battle = CUTSCENES_ROOT_PATH + "/PreBattle/PreBattleDialogue.tscn",
	jevil_down = CUTSCENES_ROOT_PATH + "/JevilDown/JevilDown.tscn",
	spam_down = CUTSCENES_ROOT_PATH + "/SpamDown/SpamDown.tscn",
	# unused
	cringe_game_over = CUTSCENES_ROOT_PATH + "/JevilDown/JevilDown.tscn",
	game_over = CUTSCENES_ROOT_PATH + "/GameOver/GameOver.tscn"
#	CUTSCENES_ROOT_PATH + "/TestingScene.tscn",
}

# STATE-MACHINE ? ПО ФАЗАМ
var CUR_ATTACK_IND = -1

# есть два вида фаз:
# меняется только извне
var CUR_PHASE_IND = 0

var PHASE_0 = [
	Phase.Dull + "/Dimonds_Minitons/Attack1.tscn",
	Phase.Dull + "/DullSpamton/DullSpamton.tscn",
	Phase.Dull + "/DullJevil/DullJevil.tscn",
]

var PHASE_1 = [
	Phase.Drama + "/MonologueAttack.tscn",
]

var PHASE_2 = [
#	Phase.Phase3 + "/TestAttack/PwdAttack.tscn",
	Phase.Phase2 + "/Attack3/Attack3.tscn",
#	Phase.Phase2 + "/NoseAttack/NoseAttack.tscn",
]
var PHASE_3 = [
#	__________ PHASE 2 ____________ (отделить папками и тут как-то)	
	Phase.Phase2 + "/Attack2/Attack2.tscn",
#	Phase.Phase2 + "/CardPlay/Party/Party.tscn",
#	__________ PHASE 3 ____________ (отделить папками и тут как-то)
#	Phase.Phase2 + "/CarouselKids/CarouselKids.tscn",
#	Phase.Phase2 + "/NoseAttack/NoseAttack.tscn", # переводить в этой фазе в другой режим
#	Phase.Phase3 + "/TestAttack/PwdAttack.tscn",
#	"res://Attacks/MadSpamAttack/MadSpamAttack.tscn",

]

var PHASE_4 = [
#	Phase.Phase2 + "/MilkAttack/MilkAttack.tscn",
#	Phase.Phase3 + "/SharedForm/SharedForm.tscn",
	Phase.Phase3 + "/UnusedJevilAttack/UnusedJevilAttack.tscn",
#	Phase.Phase2 + "/BallFallingAttack/BallFallingAttack.tscn",	
]

var PHASE_ULTIMATE = [
	Phase.Ultimate + "/BadAnimation/BadAnimation.tscn",
]

var MAD_SPAM = []

var ATTACKS = [PHASE_0, PHASE_1, PHASE_2, PHASE_3, PHASE_4]


func start_next_phase():
	CUR_PHASE_IND += 1
	CUR_ATTACK_IND = -1


# достаёт атаку из массива атак текущей фазы
func get_next():
	CUR_ATTACK_IND += 1
	# выкидывать первые две фазы, если они помирились - глобально задать первой фазой 2
	print(ATTACKS[CUR_PHASE_IND])
	if CUR_ATTACK_IND >= len(ATTACKS[CUR_PHASE_IND]):
		CUR_ATTACK_IND = 0
	return ATTACKS[CUR_PHASE_IND][CUR_ATTACK_IND]


func _on_jevil_down():
	ATTACKS.insert(CUR_PHASE_IND+1, [CUTSCENES.jevil_down])
	ATTACKS.resize(CUR_ATTACK_IND+2)


func _on_spam_down():
	ATTACKS.insert(CUR_ATTACK_IND+1, [CUTSCENES.spam_down])
	ATTACKS.resize(CUR_ATTACK_IND+2)
