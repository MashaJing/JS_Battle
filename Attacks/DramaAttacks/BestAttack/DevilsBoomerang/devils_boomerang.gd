extends Node2D

var DevilsKnife = preload("res://Bullets/DevilsKnife/KnifePath.tscn")
@onready var path1 = $KnifePath1
@onready var path2 = $KnifePath2


func _ready():
	$AnimationPlayer.play("run_left")
	await $AnimationPlayer.animation_finished
	spawn_knife_on_path(path1)
	
	await path1.child_exiting_tree
	$AnimationPlayer.play("run_from_left")
	await $AnimationPlayer.animation_finished
	spawn_knife_on_path(path2)

	# Джевил делает разворот -> бежит -> 
	# Спавн ножа на пути 2 в след. момент (по низу, назад в место респавна)


func spawn_knife_on_path(path):
	var devils_knife = DevilsKnife.instantiate()
	devils_knife.speed = 550
	devils_knife.end_rotation_speed = 0
	path.add_child(devils_knife)

