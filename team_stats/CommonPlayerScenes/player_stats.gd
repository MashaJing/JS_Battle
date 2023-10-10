extends Node2D

export var MAX_HP = 100
export var HP = 100

signal Down
signal Up
signal Healed
signal TookDamage


func _ready():
	print('Kris ready')

func take_damage(damage):
	emit_signal("TookDamage")
	var new_HP = HP - damage
	print('Base hp ', new_HP)
	if HP >= 0 and new_HP <= 0:
		print('emited down!!!')
		emit_signal("Down")
# - больше не принимаем сигнал take_damage - Крис исключён из списка целей атак??
	HP = new_HP


func healed(delta):
	var new_HP = HP + delta
	print('Base hp ', new_HP)

	if HP < 0 and new_HP > 0:
		emit_signal("Up")
	
	HP = new_HP
