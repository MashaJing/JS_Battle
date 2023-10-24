extends Node2D

export var MAX_HP = 100
export var HP = 100
export var ATK = 100

signal Down
signal Up
signal Healed
signal TookDamage


func _ready():
	connect("Down", TeamStats, "_on_ally_down")
	connect("Up", TeamStats, "_on_ally_up")

	print('Character stats ready')

func take_damage(damage):
#	play standard hit sound
	emit_signal("TookDamage")
	var new_HP = HP - damage
	print('NEW hp ', new_HP)
	if HP >= 0 and new_HP <= 0:
		print('emited down!!!')
		emit_signal("Down", get_parent().name)
# - больше не принимаем сигнал take_damage - Крис исключён из списка целей атак??
	HP = new_HP


func heal(delta):
#	play standard heal sound
	var new_HP = HP + delta
	print('NEW hp ', new_HP)

	if new_HP > MAX_HP:
		new_HP = MAX_HP

	if HP < 0 and new_HP > 0:
		print('emited up!!!')
		emit_signal("Up", get_parent().name)
	emit_signal("Healed")	
	HP = new_HP
