extends Node

signal sub_attack_ended

@onready var StompArea1 = $Warning
@onready var StompArea2 = $Warning2
@onready var StompArea3 = $Warning3
@onready var Leg1 = $Leg
@onready var Leg2 = $Leg2
@onready var MikeLegs = $MikeLegs

var target = ["Jevil"]


func _ready():
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	emit_signal("sub_attack_ended")


func stomp(stomp_area, leg):
	stomp_area.visible = true
	await get_tree().create_timer(0.7).timeout
	stomp_area.visible = false
	leg.stomp()


func stomp_1():
	stomp(StompArea1, Leg1)

func stomp_2():
	stomp(StompArea2, Leg2)

func stomp_Mike():
	stomp(StompArea3, MikeLegs)
