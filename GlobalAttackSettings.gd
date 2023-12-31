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
}


# STATE-MACHINE ? ПО ФАЗАМ
var CUR_ATTACK_IND = -1
# атака:
# - участники (при смерти одного - опред. катсцена)
var ATTACKS = [
#	__________ TESTING ____________
#	CUTSCENES_ROOT_PATH + "/TestingScene.tscn",
#	CUTSCENES_ROOT_PATH + "/JevilDown/JevilDown.tscn",
#	CUTSCENES_ROOT_PATH + "/SpamDown/SpamDown.tscn",
#	_______________________________
#	CUTSCENES_ROOT_PATH +"/PreBattle/PreBattleDialogue.tscn",
#	__________ DULL ATTACKS ____________
#	Phase.Dull + "/Dimonds_Minitons/Attack1.tscn",
#	Phase.Dull + "/DullSpamton/DullSpamton.tscn",
#	Phase.Dull + "/DullJevil/DullJevil.tscn",
##	__________ DRAMA ATTACK ____________
#	Phase.Drama + "/MonologueAttack.tscn",
#	__________ PHASE 2 ____________ (отделить папками и тут как-то)	
	"res://Attacks/MadSpamAttack/MadSpamAttack.tscn",
#	Phase.Phase3 + "/TestAttack/PwdAttack.tscn",
#	Phase.Phase2 + "/Attack3/Attack3.tscn",
#	Phase.Phase2 + "/NoseAttack/NoseAttack.tscn",
#	Phase.Phase2 + "/MilkAttack/MilkAttack.tscn",
#	Phase.Phase2 + "/Attack2/Attack2.tscn",
#	Phase.Phase2 + "/CardPlay/Party/Party.tscn",
#	__________ PHASE 3 ____________ (отделить папками и тут как-то)
#	Phase.Phase2 + "/CarouselKids/CarouselKids.tscn",
#	Phase.Phase2 + "/NoseAttack/NoseAttack.tscn", # переводить в этой фазе в другой режим
#	Phase.Phase3 + "/UnusedJevilAttack/UnusedJevilAttack.tscn",
#	Phase.Phase3 + "/SharedForm/SharedForm.tscn",
#	Phase.Phase3 + "/TestAttack/PwdAttack.tscn",
#	__________ULTIMATE PHASE ____________
#	Phase.Ultimate + "/BadAnimation/BadAnimation.tscn",
#	Phase.Phase2 + "/BallFallingAttack/BallFallingAttack.tscn",
]

func get_next():
	CUR_ATTACK_IND += 1
	# выкидывать первые две фазы, если они помирились
	if CUR_ATTACK_IND < len(ATTACKS):
		var attack = ATTACKS[CUR_ATTACK_IND]
		return attack
	else:
		print('а всё, а больше нет атак')


func get_attack():
	if CUR_ATTACK_IND < len(ATTACKS):
		var attack = ATTACKS[CUR_ATTACK_IND]
		return attack


func _on_jevil_down():
	ATTACKS.insert(CUR_ATTACK_IND+1, CUTSCENES.jevil_down)
	ATTACKS.resize(CUR_ATTACK_IND+2)


func _on_spam_down():
	ATTACKS.insert(CUR_ATTACK_IND+1, CUTSCENES.spam_down)
	ATTACKS.resize(CUR_ATTACK_IND+2)

# непонятно, как атаку связывать с фазой. Зачем мне это?
# - чтобы определять режим конкретной атаки (в NoseAttack и т.д.) - 
# - чтобы красиво обращаться по пути "фаза"/"атака"


#func pick_random():
#	if len(PARTIES) > 0:
#		var pos = randi() % len(PARTIES)
#		return PARTIES.pop_at(pos)
