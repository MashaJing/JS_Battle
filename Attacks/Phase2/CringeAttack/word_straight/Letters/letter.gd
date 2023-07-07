extends Area2D

onready var anim = $AnimationPlayer

var font_path = "res://fonts/menu/VT323-Regular.ttf"

var letter = '' setget set_letter, get_letter
var speed = 100
var acceleration = 250
var time = 0
const mode = {
	CHASE = 'chase',
	EXPLODE = 'explode',
	SPIRAL = 'spiral',
}
var cur_mode = mode.CHASE
var target
var direction = Vector2.LEFT


func _process(delta):
	speed += delta * acceleration
	match cur_mode:
		mode.CHASE:
			direction = chase()
			position += speed * delta * direction
		mode.EXPLODE:
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
