extends Node2D

signal attack_ended

func _on_AttackTimer_timeout():
	emit_signal("attack_ended")
