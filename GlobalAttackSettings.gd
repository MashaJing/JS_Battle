# глобально храним только путь до нужной сцены.
# Отсюда все сцены будут получать инфу о том, куда им дальше переключаться
extends Node2D

class Phase:
	var root_path
	var attacks
	var is_played_once
	var break_condition
	var threshold

	func _init(_root_path, _attacks,
				_is_played_once=true, _break_condition=null, _threshold=null):
		self.root_path = _root_path
		self.attacks = []
		for attack in _attacks:
			self.attacks.append(root_path + attack)
		self.break_condition = _break_condition  # при is_played_once=false - условие выхода из цикла
		self.threshold = _threshold
		self.is_played_once = _is_played_once  # true - фаза не зацикливается


var PRELUDE = [
	"/PreBattle/PreBattleDialogue.tscn"
]

var PHASE_0 = [
	"/Dimonds_Minitons/Attack1.tscn",
#	"/DullSpamton/DullSpamton.tscn",
	"/DullJevil/DullJevil.tscn",
]

var PHASE_1 = [
	"/MonologueAttack.tscn",
]

var PHASE_2 = [
	 "/TestAttack/PwdAttack.tscn",
	"/Attack3/Attack3.tscn",
	"/NoseAttack/NoseAttack.tscn",
]
var PHASE_3 = [
#	__________ PHASE 2 ____________ (отделить папками и тут как-то)	
	"/CardPlay/Party/Party.tscn",
	"/CarouselKids/CarouselKids.tscn",
	"/SharedForm/SharedForm.tscn",
	 "/NoseAttack/NoseAttack.tscn", # переводить в этой фазе в другой режим
#	__________ PHASE 3 ____________ (отделить папками и тут как-то)
	"/TestAttack/PwdAttack.tscn",
#	"res://Attacks/MadSpamAttack/MadSpamAttack.tscn",
	"/Attack2/Attack2.tscn",
]

var PHASE_4 = [
#	Phase.Phase2 + "/MilkAttack/MilkAttack.tscn",
#	Phase.Phase3 + "/SharedForm/SharedForm.tscn",
	"/UnusedJevilAttack/UnusedJevilAttack.tscn",
]

var PHASE_ULTIMATE = [
	"/BadAnimation/BadAnimation.tscn",
#	Phase.Phase2 + "/BallFallingAttack/BallFallingAttack.tscn",	
]

var phases = [
	Phase.new("res://Cutscenes", PRELUDE),
	Phase.new("res://Attacks/DullAttacks", PHASE_0),
	Phase.new("res://Attacks/DramaAttacks", PHASE_1),
	Phase.new("res://Attacks/Phase2", PHASE_2, false, "compare_hp", 5),
	Phase.new("res://Attacks/Phase2", PHASE_2),
	Phase.new("res://Attacks/Phase3", PHASE_3),
	Phase.new("res://Attacks/Phase3", PHASE_4),
	Phase.new("res://Attacks/UltimateAttack", PHASE_ULTIMATE),
]

var ATTACK_INDEX = -1
var PHASE_INDEX = 0

var MAD_SPAM = []


# TODO: чёт кастомный инит тупизна какая-то
func init():
	# удаляем атаки про перемирие, если они уже не нужны по сюжету
#	if GlobalPlotSettings.MADE_UP:
#		var new_phases = phases.slice(2, -1)
#		phases = new_phases
	pass


# возвращает путь до следующей атаки
func get_next_attack():
	ATTACK_INDEX += 1

	if ATTACK_INDEX >= len(phases[PHASE_INDEX].attacks):
		ATTACK_INDEX = 0

		# окончание не зацикленной фазы
		if phases[PHASE_INDEX].is_played_once:
			PHASE_INDEX += 1
			return phases[PHASE_INDEX].attacks[ATTACK_INDEX]

	# окончание зацикленной фазы по специальному условию
	if not phases[PHASE_INDEX].is_played_once and ConStats.call(phases[PHASE_INDEX].break_condition, phases[PHASE_INDEX].threshold):
		ATTACK_INDEX = 0
		PHASE_INDEX += 1

	return phases[PHASE_INDEX].attacks[ATTACK_INDEX]


func play_enemy_down(name):
	if GlobalPlotSettings.BOTH_ALIVE:
		match name:
			"Jevil":
				GlobalPlotSettings.JEVIL_UP = false
				phases[PHASE_INDEX].attacks.insert(ATTACK_INDEX+1,
					GlobalPlotSettings.CUTSCENES.jevil_down)
			"Spamton":
				GlobalPlotSettings.SPAMTON_UP = false
				phases[PHASE_INDEX].attacks.insert(ATTACK_INDEX+1,
					GlobalPlotSettings.CUTSCENES.spam_down)
	else:
		print("adadadaa game overrr")
		phases[PHASE_INDEX].attacks.insert(ATTACK_INDEX+1,
			GlobalPlotSettings.CUTSCENES.game_over)
		
#	phases[PHASE_INDEX].attacks.resize(ATTACK_INDEX+2) # исключить все атаки с чуваком


func reset():
	ATTACK_INDEX = -1
	PHASE_INDEX = 0
