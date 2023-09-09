# глобально храним только путь до нужной сцены.
# Отсюда все сцены будут получать инфу о том, куда им дальше переключаться

extends Node2D

var ROOT_SCENE_PATH = "res://Main.tscn"
var GAME_OVER_SCENE_PATH = "res://Cutscenes/GameOver/GameOver.tscn"
var CRINGE_GAME_OVER_SCENE_PATH = "res://Cutscenes/CringeGameOver/CringeGameOver.tscn"
var CRINGE_ATTACK_PATH = "res://Attacks/CringeAttack/CringeAttack.tscn"
var CRINGE_ATTACKS_ON = true  # может быть завязан на MADE_UP
var MADE_UP = true

# STATE-MACHINE ? ПО ФАЗАМ
var CUR_ATTACK_IND = -1
var ATTACKS = [
#	__________ TESTING ____________
#	"res://Cutscenes/TestingScene.tscn",
	"res://Cutscenes/JevilDown/JevilDown.tscn",
#	"res://Cutscenes/SpamDown/SpamDown.tscn",
#	_______________________________
#	"res://Cutscenes/PreBattle/PreBattleDialogue.tscn",
#	__________ DULL ATTACKS ____________
#	"res://Attacks/DullAttacks/Dimonds_Minitons/Attack1.tscn",
#	"res://Attacks/DullAttacks/DullSpamton/DullSpamton.tscn",
#	"res://Attacks/DullAttacks/DullJevil/DullJevil.tscn",
##	__________ DRAMA ATTACK ____________
	"res://Attacks/DramaAttacks/MonologueAttack.tscn",
#	__________ PHASE 2 ____________ (отделить папками и тут как-то)	
	"res://Attacks/Phase1/Attack2/Attack2.tscn",
	"res://Attacks/Phase2/TestAttack/PwdAttack.tscn",
	"res://Attacks/Phase2/Attack3/Attack3.tscn",
	"res://Attacks/Phase2/NoseAttack/NoseAttack.tscn",
	"res://Attacks/Phase2/MilkAttack/MilkAttack.tscn",
	"res://Attacks/Phase2/CardPlay/Party/Party.tscn",
#	__________ PHASE 3 ____________ (отделить папками и тут как-то)
	"res://Attacks/Phase2/CarouselKids/CarouselKids.tscn",
	"res://Attacks/Phase2/NoseAttack/NoseAttack.tscn", # переводить в этой фазе в другой режим
	"res://Attacks/Phase2/UnusedJevilAttack/UnusedJevilAttack.tscn",
	"res://Attacks/Phase2/SharedForm/SharedForm.tscn",
	"res://Attacks/Phase2/TestAttack/PwdAttack.tscn",
#	__________ULTIMATE PHASE ____________
	"res://Attacks/UltimateAttack/BadAnimation/BadAnimation.tscn",
	"res://Attacks/Phase2/BallFallingAttack/BallFallingAttack.tscn",
]

func get_next():
	CUR_ATTACK_IND += 1
	if CUR_ATTACK_IND < len(ATTACKS):
		var attack = ATTACKS[CUR_ATTACK_IND]
		return attack
	else:
		print('а всё, а больше нет атак')


#func pick_random():
#	if len(PARTIES) > 0:
#		var pos = randi() % len(PARTIES)
#		return PARTIES.pop_at(pos)
