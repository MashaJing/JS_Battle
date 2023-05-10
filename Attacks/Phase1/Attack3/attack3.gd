extends Node

onready var DollarSpawnLocation = $Path2D/PathFollow2D
onready var Dollar = preload("res://Bullets/bullet_dollar/Dollar.tscn")
var suck_direction = Vector2.ZERO


func _ready():
	$Spamton/AnimationPlayer.play("default")
	yield(get_tree().create_timer(2.0), "timeout")
	$Spamton/AnimatedSprite.play("increase_head_inclined")
	yield($Spamton/AnimatedSprite, "animation_finished")
	$Spamton/AnimationPlayer.play("big_head_attack_inclined")
	suck_direction = Vector2(1, 1)

func _process(delta):
	$Heart.position += suck_direction

func _on_DollarSpawnTimer_timeout():
	var kromer = Dollar.instance()
	DollarSpawnLocation.unit_offset = randf()
	kromer.position = DollarSpawnLocation.global_position
	kromer.speed = 1
	kromer.move_to($Spamton)
	kromer.ttl = 10
	add_child(kromer)
