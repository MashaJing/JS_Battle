extends Node2D

onready var Border = $BorderField
onready var BorderFollow = $FerrisWheel/BorderFollow
onready var WheelCenter = $FerrisWheel/WheelCenter

# сделать рандомный знак
onready var Bullet = preload("res://Bullets/Club/Bullet.tscn")
signal card_attack_ended

var N_CLUBS = 10
var WHEEL_ACC = 0.07
var time = 0
var gravity = 700
var falling = false
var SPEED = 0


func _ready():
	for i in range(N_CLUBS):
		BorderFollow.unit_offset = float(i)/N_CLUBS
		var bullet = Bullet.instance()
		bullet.scale *= 2.0
		bullet.position = BorderFollow.global_position
		add_child(bullet)


func _process(delta):
	# нет я не хочу идти по грешному пути яндере дев нееет
	if falling:
		Border.global_position += gravity * delta * Vector2.DOWN
	else:
		SPEED += WHEEL_ACC * delta
		BorderFollow.unit_offset += delta * SPEED
		Border.position = BorderFollow.global_position


func _on_ClubTimer_timeout():
	$ClubTimer.stop()
	$ClubTimer.wait_time = randi() % 5 + 3
	SPEED = 0
	WHEEL_ACC *=- 1
	$ClubTimer.start()


func _on_HoldingTimer_timeout():
	SPEED = 0
	WHEEL_ACC = 0
	yield(get_tree().create_timer(0.5), "timeout")
	falling = true
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("card_attack_ended")
