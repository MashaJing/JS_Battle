extends Node

onready var inventorium = $Inventorium

var Spamton_ATK = 100
var MAX_TP = 100
var TP = 0
var tp_delta = 10

# как-то прокинуть хп каждого? Или прям тут? Мб сделать 2 глобальных узла для каждой из сторон?
# можно, чтоб каждая посылала свой сигнал о проигрыше + считать у нас уровень насилия?
onready var heroes = []
onready var AttackTargets = heroes
signal game_over


func _ready():
	pass
#	как-то приконнектить их вовремя
#	for target in heroes:
#		target.get_node("PlayerStats").connect("Down", self, "_on_ally_down")
#		target.get_node("PlayerStats").connect("Up", self, "_on_ally_up")


func _process(delta):
	pass

# обработка сигнала take damage:
	# TargetEnemy получает дамаг в размере из статы
	# Итерируемся по каждому из target-героев (сделать каждому отдельный узел?)
	# и шлём сигнал герой.down, чтобы в меню и выборе следующей цели он пропускался


func _on_take_damage():
	for target in heroes:
		print('teamstats caught signal: target')
		# атаку прокинуть в зависимости от пули
		target.get_node("PlayerStats").take_damage(Spamton_ATK)

		# мб переименовать ф-ию, чтобы было не только про обработку сигнала?
		_on_tp_decreased()

# TP для всех общий, поэтому он тут
func _on_tp_increased():
	print('ENTERED!')
	TP += tp_delta
	if TP > MAX_TP:
		TP = MAX_TP
	print("TP: ", TP)


func _on_tp_decreased():
	print('ENTERED!')
	TP -= tp_delta
	if TP < 0:
		TP = 0
	print("TP: ", TP)


# мб сразу в ридере и вызывать?
func _on_defend(defender):
	defender.defend()


# мб сразу в ридере и вызывать?
func _on_heal(healed_player, hp_delta):
	healed_player.healed(hp_delta)


func _on_ally_down(ally):
	heroes.erase(ally)
	if len(heroes) == 0:
		emit_signal("game_over")
	print(heroes)


func _on_ally_up(ally):
	heroes.append(ally)
	print(heroes)


func choose_target(targets: Node2D = null) -> void:
	print()
	pass
	if targets == null:
		AttackTargets = [heroes[randi() % len(heroes)]]
	else:
		AttackTargets = targets
	print("_______________________________________")
	print('target: ', AttackTargets)
	print("_______________________________________")
