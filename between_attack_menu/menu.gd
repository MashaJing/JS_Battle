extends Node

signal attck_begins


func _ready():
	print('menu is ready!')	

func _on_AttackButton_pressed():
	print('button pressed!')
	call_deferred("emit_signal", "attck_begins")
