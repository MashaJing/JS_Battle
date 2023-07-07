extends Area2D

signal full_house
var bullet_counter = 0
var bullet_limit = 0


func _ready():
	pass


func _on_ExplosionArea_area_entered(area):
	bullet_counter+=1
	if bullet_counter >= bullet_limit:
		emit_signal('full_house')
