extends Node2D

var CFRAMES_PATH = "res://Attacks/UltimateAttack/Assets/CollisionFrames/jevils_gift/"
var N_FRAMES = 12

var sprite_polygon_array = []


func load_sprite_array():
	for index in range(N_FRAMES):
		sprite_polygon_array.append(load(CFRAMES_PATH + "cframe{index}.tscn".format({"index": index + 1})))


func change_to_sprite(frame_ind):
	var time_before = OS.get_ticks_msec()
	var BadFrame = get_node_or_null("BadAnimation")
	if BadFrame != null:
		print('aaaaaaaaa')
		remove_child(BadFrame)
	print('bbb')
	
	if frame_ind >= len(sprite_polygon_array):
		$AnimatedSprite.stop()
	else:
		var new_frame = sprite_polygon_array[frame_ind].instance()
		if new_frame:
			add_child(new_frame)
		print(get_children())
		var time_after = OS.get_ticks_msec()
		print(time_after - time_before)

func _ready():
	load_sprite_array()
	$AnimatedSprite.play("default")

func _process(delta):
	pass

func _on_AnimatedSprite_frame_changed():
	change_to_sprite($AnimatedSprite.frame)