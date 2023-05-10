extends Area2D

var speed = 100
var direction = Vector2.LEFT


func _ready():
	for i in range (5):
		yield($DotTimer, "timeout")
		$RichTextLabel.text += ' .'


func _process(delta):
	global_position += delta * speed * Vector2(1, 1)
