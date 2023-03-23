extends Node

onready var Jevil = $Jevil
onready var Spamton = $Spamton

onready var Kris = $Kris
onready var Susie = $Susie
onready var Ralsei = null

var Spamton_ATK = 100
var MAX_TP = 100
var TP = 0

onready var heroes = [$Kris, $Susie]
onready var AttackTargets = heroes


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
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

func _on_Kris_down():
	#AttackTargets.pop_at() исключить Криса
	pass

func choose_target():
	AttackTargets = [heroes[randi() % heroes.size()]]
	print(AttackTargets)

func _on_Menu_attck_begins():
	choose_target()
