extends Node

signal attack_ended

onready var DollarSpawnLocation = $Path2D/PathFollow2D
onready var Dollar = preload("res://Bullets/bullet_dollar/Dollar.tscn")
var suck_direction = Vector2.ZERO


func _ready():
	$Spamton/AnimationPlayer.play("default")
	yield(get_tree().create_timer(2.0), "timeout")
	$Spamton/AnimationPlayer.play("increase_head_inclined")
	yield($Spamton/AnimationPlayer, "animation_finished")
	$Spamton/AnimationPlayer.play("big_head_attack_inclined")
	suck_direction = Vector2(0.5, 0.5)

func _process(delta):
	$KinematicHeart.position += suck_direction

func _on_DollarSpawnTimer_timeout():
	pass
#	var kromer = Dollar.instance()
#	DollarSpawnLocation.unit_offset = randf()
#	kromer.position = DollarSpawnLocation.global_position
#	kromer.speed = 1
#	kromer.move_to($Spamton)
#	kromer.ttl = 10
#	add_child(kromer)

func _on_AttackTimer_timeout():
	emit_signal("attack_ended")
