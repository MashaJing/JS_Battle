extends Node2D

signal attack_ended

onready var Drip = preload("res://Bullets/MilkDrip/MilkDrip.tscn")
onready var Level = preload("res://Attacks/Phase2/MilkAttack/MilkLevel/MilkLevel.tscn")

var DRIP_AMOUNT = 30
var MILK_HEGHT = 17.0


func _ready():
	$KinematicHeart/Heart.connect("health_changed", self, "_on_Heart_hit")
	$AnimationPlayer.play("milk_falls")
	yield($AnimationPlayer, "animation_finished")
	while $MilkLevel.scale.y < MILK_HEGHT:
		var bullet = Drip.instance()
		var bullet2 = Drip.instance()
		bullet.global_position = $Bottle/DripSpawn.global_position
		bullet2.global_position = $Bottle2/DripSpawn.global_position
		
		bullet.target_object = $MilkLevel.global_position
		bullet2.target_object = $MilkLevel.global_position
		add_child(bullet)
		add_child(bullet2)
		bullet2.speed_x *= -1
		bullet.add_to_group("bullets")
		bullet2.add_to_group("bullets")
		yield(get_tree().create_timer(0.2), "timeout")
	emit_signal("attack_ended")


func _on_MilkLevel_area_entered(area):
	if area.is_in_group("bullets"):
		area.queue_free()
		$MilkLevel.scale.y += 0.2


# вынести область с сердечком в отдельную сцену
func _on_Area2D_area_exited(area):
	if area.is_in_group("bullets"):
		area.queue_free()


func _on_Heart_hit():
	# звучит слишком жестко, нужен более подходящий звук
#	$Heart/SlapSound.play()
	$AnimationPlayer.play("slap_heart")
	print("attack_ended")
