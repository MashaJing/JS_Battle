extends Node2D

@export var MAX_HP = 100
@export var HP = 100
@export var ATK = 100
@export var DEF = 10

@export var SPARE = 0
var SPARE_DELTA = 10  # точно тут?

signal Down
signal Up
signal UpdateHp
signal TookDamage
signal Speared


func _ready():
	_init_signals()
	print('Character stats ready')

func take_damage(damage):
#	play standard hit sound
	var new_HP = HP - damage
	print('NEW hp ', new_HP)
	if HP >= 0 and new_HP <= 0:
		print('emited down!!!')
		emit_signal("Down", get_parent().name)
	HP = new_HP
	emit_signal("TookDamage")
	emit_signal("UpdateHp")
# - больше не принимаем сигнал take_damage - исключён из списка целей атак??


func heal(delta):
	$HealSound.play()
	var new_HP = HP + delta
	print('NEW hp ', new_HP)

	if new_HP > MAX_HP:
		new_HP = MAX_HP

	if HP < 0 and new_HP > 0:
		emit_signal("Up", get_parent().name)
	HP = new_HP
		
	emit_signal("UpdateHp")


func _init_signals():
	connect("Down", Callable(TeamStats, "_on_ally_down"))
	connect("Up", Callable(TeamStats, "_on_ally_up"))

	DecisionReader.connect("healed", heal)


func defend():
	DEF += 10
	# here used to be yield(). RIP
	DEF -= 10
	

func spare():
	var new_spare = SPARE + SPARE_DELTA
	if new_spare > 100:
		new_spare = 100
	SPARE = new_spare
	if SPARE == 100:
		emit_signal("Speared", get_parent().name)
	
