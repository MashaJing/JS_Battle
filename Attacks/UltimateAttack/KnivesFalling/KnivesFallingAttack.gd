extends Node2D
var Knife = preload("res://Attacks/UltimateAttack/KnivesFalling/KnifeFalling.tscn")


func _ready():
	$AnimationPlayer.play("attack")

func spawn_knife_on_point():
	var knife = Knife.instance()
	knife.position = get_random_position()
	add_child(knife)

func get_random_position():
	var child_ind = randi() % $Spawns.get_child_count()
	print(child_ind)
	return $Spawns.get_children()[child_ind].position
