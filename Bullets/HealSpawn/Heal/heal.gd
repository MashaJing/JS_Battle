extends Area2D

var PATH = "res://Assets/BA/heals/heal_%s.png"
var HealSource = {
	'JEVIL': ["plus", "flower", "heart_donut", "choco", "choco2", "voice2", "note"],
	'SPAMTON': ["plus", "car2", "letter", "spam_tea", "voice", "phone"]
}
export var direction = Vector2.LEFT
export var speed = 60
export var healer = 'JEVIL'
export var rotation_speed = 0.01


func _ready():
	direction += Vector2(rand_range(-0.5, 0.5), rand_range(-0.5, 0.5)).normalized()
	$Sprite.texture = load(PATH % HealSource[healer][randi() % len(HealSource[healer])])


func _process(delta):
	rotate(rotation_speed)
	global_position += direction * delta * speed - Vector2(1, 0)


func _on_Heal_area_entered(heart):
	if heart.is_in_group('heart'):
		# послать сигнал хила
		queue_free()
