extends Node2D

var bullet_batch = preload('res://Bullets/DimondsBatch/DimondsBatch.tscn')
var bullet = preload('res://Bullets/Worm/Worm.tscn')
signal card_attack_ended


func _ready():
	$AnimationPlayer.play("letter_resend")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("card_attack_ended")

func spawn_bullets():
	var batch = bullet_batch.instance()
	batch.BULLET = bullet
	batch.heart_position = $Heart.global_position
	batch.SHOOT_ANGLE = 30
	batch.global_position =  $Path2D/PathFollow2D/Letter.global_position
	add_child(batch)
