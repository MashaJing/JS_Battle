# глобально храним только путь до нужной сцены.
# Отсюда все сцены будут получать инфу о том, куда им дальше переключаться
extends Node2D

class Attack:
	var path
	var mode
	
	func _set(path, value):
		self.path = value

	func _init(path, mode=null):
		self.path = path
		self.mode = mode

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
			attack.path = root_path + attack.path
			self.attacks.append(attack)
		self.break_condition = _break_condition  # при is_played_once=false - условие выхода из цикла
		self.threshold = _threshold
		self.is_played_once = _is_played_once  # true - фаза не зацикливается


var PRELUDE = [
	Attack.new("/PreBattle/PreBattleDialogue.tscn")
]

var PHASE_0 = [
	Attack.new("/Dimonds_Minitons/Attack1.tscn"),
#	Attack.new("/DullSpamton/DullSpamton.tscn"),
	Attack.new("/DullJevil/DullJevil.tscn"),
]

var PHASE_1 = [
	Attack.new("/MonologueAttack.tscn"),
]

var PHASE_2 = [
	Attack.new("/Attack3/Attack3.tscn"),
	Attack.new("/TestAttack/PwdAttack.tscn"),
	Attack.new("/NoseAttack/NoseAttack.tscn", 0),
]
var PHASE_3 = [
#	__________ PHASE 2 ____________ (отделить папками и тут как-то)	
	Attack.new("/CardPlay/Party/Party.tscn"),
	Attack.new("/CarouselKids/CarouselKids.tscn"),
	Attack.new("/SharedForm/SharedForm.tscn"),
	 Attack.new("/NoseAttack/NoseAttack.tscn", 1), # переводить в этой фазе в другой режим
#	__________ PHASE 3 ____________ 
	Attack.new("/TestAttack/PwdAttack.tscn"),
#	Attack.new("res://Attacks/MadSpamAttack/MadSpamAttack.tscn"),
	Attack.new("/Attack2/Attack2.tscn"),
]

var PHASE_4 = [
#	Attack.new("/MilkAttack/MilkAttack.tscn"),
	Attack.new("/SharedForm/SharedForm.tscn"),
	Attack.new("/UnusedJevilAttack/UnusedJevilAttack.tscn"),
]

var PHASE_ULTIMATE = [
#	Attack.new("/BadAnimation/BadAnimation.tscn"),
	Attack.new("/BallFallingAttack/BallFallingAttack.tscn")
]

var END = [
	Attack.new("/HappyEnd/HappyEnd.tscn")
]

var phases = [
	Phase.new("res://Cutscenes", PRELUDE),
	Phase.new("res://Attacks/DullAttacks", PHASE_0),
	Phase.new("res://Attacks/DramaAttacks", PHASE_1),
	Phase.new("res://Attacks/Phase2", PHASE_2),
	Phase.new("res://Attacks/Phase2", PHASE_3),
	Phase.new("res://Attacks/Phase2", PHASE_4),
	Phase.new("res://Attacks/UltimateAttack", PHASE_ULTIMATE),
	Phase.new("res://Cutscenes", END),
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


# возвращает класс Attack, включающий в себя путь до следующей атаки и её режим, если есть
func get_next_attack():
	ATTACK_INDEX += 1

	# окончание не зацикленной фазы, когда атаки закончились
	if ATTACK_INDEX >= len(phases[PHASE_INDEX].attacks):
		ATTACK_INDEX = 0

		if phases[PHASE_INDEX].is_played_once:
			PHASE_INDEX += 1

	# окончание зацикленной фазы по специальному условию
	if not phases[PHASE_INDEX].is_played_once and ConStats.call(phases[PHASE_INDEX].break_condition, phases[PHASE_INDEX].threshold):
		ATTACK_INDEX = 0
		PHASE_INDEX += 1
	
	if PHASE_INDEX < len(phases) and ATTACK_INDEX < len(phases[PHASE_INDEX].attacks):
		print(ATTACK_INDEX)
		print(len(phases[PHASE_INDEX].attacks))
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
