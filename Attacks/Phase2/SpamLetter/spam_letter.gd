extends Node2D

var bullet_batch = preload('res://Bullets/DimondsBatch/DimondsBatch.tscn')
var bullet = preload('res://Bullets/Worm/Worm.tscn')


func _ready():
	$AnimationPlayer.play("letter_resend")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(GlobalPartySettings.PARTY_ROOT_SCENE_PATH)


func spawn_bullets():
	var batch = bullet_batch.instance()
	batch.BULLET = bullet
	batch.heart_position = $Heart.global_position
	batch.SHOOT_ANGLE = 30
	batch.global_position =  $Path2D/PathFollow2D/Letter.global_position
	add_child(batch)
