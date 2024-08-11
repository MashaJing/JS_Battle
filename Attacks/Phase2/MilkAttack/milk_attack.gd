extends Node2D

signal attack_ended

@onready var Drip = preload("res://Bullets/MilkDrip/MilkDrip.tscn")
@onready var Level = preload("res://Attacks/Phase2/MilkAttack/MilkLevel/MilkLevel.tscn")


var DRIP_AMOUNT = 30
var MILK_HEGHT = 17.0


func _ready():
	$KinematicHeart/Heart.connect("health_changed", Callable(self, "_on_Heart_hit"))
	$AnimationPlayer.play("milk_falls")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("bottle_goes")
	while $MilkLevel.scale.y < MILK_HEGHT:
		var bullet = Drip.instantiate()
		bullet.global_position = $Bottle/DripSpawn.global_position
		
		bullet.target_object = $MilkLevel.global_position
		add_child(bullet)
		bullet.add_to_group("bullets")
		await get_tree().create_timer(0.2).timeout
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
	$HeartAnimationPlayer.play("slap_heart")
	print("attack_ended")
