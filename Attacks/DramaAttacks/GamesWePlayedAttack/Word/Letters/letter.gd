extends Node

onready var anim = $AnimationPlayer

var font_path = "res://fonts/menu/VT323-Regular.ttf"

var letter = '' setget set_letter, get_letter
var hor_speed = - 110
var time = 0
var freq = 10
var amplitude = 120


# что-то с коллизией - бьёт в лишних местах
func _process(delta):
	time += delta
	# движение вверх-вниз
	var movement = cos(time * freq) * amplitude + 20
	self.position.y += movement * delta
	# движение влево
	self.position.x += delta * hor_speed

func _ready():
	pass

func get_letter():
	pass

func set_letter(letter):
	$RichTextLabel.append_bbcode("[code]"+ letter + "[/code]")
