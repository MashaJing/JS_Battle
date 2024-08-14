extends Area2D

@onready var anim = $AnimationPlayer

var font_path = "res://fonts/menu/VT323-Regular.ttf"

var letter = '': get = get_letter, set = set_letter
var speed = 100
var acceleration = 250
var time = 0
var mass = 20
const mode = {
	CHASE = 'chase',
	MOVE_STRAIGHT = 'move_straight',
	SPIRAL = 'spiral',
}
var cur_mode = mode.CHASE
var target
var direction = Vector2.LEFT


func _process(delta):
	match cur_mode:
		mode.CHASE:
			direction = chase()
			speed += delta * acceleration
			position += speed * delta * direction

		mode.MOVE_STRAIGHT:
			speed += delta * acceleration
			position += speed * delta * direction

		mode.SPIRAL:
			pass

func _ready():
	pass

func chase():
	return (target.global_position - global_position).normalized()

func get_letter():
	pass

func set_letter(letter):
	$RichTextLabel.append_bbcode("[code]" + letter + "[/code]")
