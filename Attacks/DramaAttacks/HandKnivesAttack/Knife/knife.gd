extends Area2D


var speed_up = 0
var time = 0

var ROTATION_DIRECTION = Vector2.ZERO setget set_target, get_target
onready var AnimPlayer = get_node("AnimationPlayer")


func set_target(target):
	ROTATION_DIRECTION = position.direction_to(target.global_position)

func get_target():
	return ROTATION_DIRECTION

func create_anim():
	var rotate_to_target = Animation.new()
	var track_rot = rotate_to_target.add_track(Animation.TYPE_VALUE)
	var path = String(self.get_path())
	rotate_to_target.track_set_path(track_rot, path + ":rotation_degrees")
	rotate_to_target.length = 1.7
	
	rotate_to_target.track_insert_key(track_rot, 0.0, 0)
	rotate_to_target.track_insert_key(track_rot, 1.0, rad2deg(ROTATION_DIRECTION.angle() - 1))
	AnimPlayer.add_animation("rotate_to_target", rotate_to_target)
	
	AnimPlayer.play("rotate_to_target")

	# сделать появление из прозрачного аналогично
	#var track_modulate = rotate_to_target.add_track(Animation.TYPE_VALUE)
	#rotate_to_target.track_set_path(track_modulate, path + ":Sprite:modulate")
	#AnimPlayer.add_animation("rotate_to_target", rotate_to_target)
	#rotate_to_target.length = 0.5

	#rotate_to_target.track_insert_key(track_modulate, 0.0, 0)
	#rotate_to_target.track_insert_key(track_modulate, 0.5, direction.angle() - ROTATION_DIRECTION)


func _process(delta):
	time += delta
	position += time * time * ROTATION_DIRECTION * speed_up

func _ready():
	create_anim()

func _on_AnimationPlayer_animation_finished(anim_name):
	# скорость появляется только по окончании анимации
	speed_up = 5
