extends Node

onready var Jevil = $Jevil
onready var Spamton = $Spamton

onready var Kris = $Kris
onready var Susie = $Susie
onready var Ralsei = null

var Spamton_ATK = 100
var MAX_TP = 100
var TP = 0
var tp_delta = 10

onready var heroes = [$Kris, $Susie]
onready var AttackTargets = heroes


func _ready():
	pass

func _process(delta):
	pass

# обработка сигнала take damage:
	# TargetEnemy получает дамаг в размере из статы
	# Итерируемся по каждому из target-героев (сделать каждому отдельный узел?)
	# и шлём сигнал герой.down, чтобы в меню и выборе следующей цели он пропускался

func _on_take_damage():
	print('teamstats caught signal!')
	for target in AttackTargets:
		print(target)
		target.take_damage(Spamton_ATK)

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

func _on_Kris_down():
	#AttackTargets.pop_at() исключить Криса
	pass

func choose_target(target=null):
	if target == null:
		AttackTargets = [heroes[randi() % len(heroes)]]
	else:
		AttackTargets = target
	print('target: ', AttackTargets)

func _on_Menu_attck_begins():
	pass
	#choose_target()
