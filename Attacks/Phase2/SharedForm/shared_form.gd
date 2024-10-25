extends Node2D
@onready var DevilsKnife = preload("res://Bullets/DevilsKnife/DevilsKnife.tscn")
signal attack_ended


func _ready():
	pass


func _on_Form_area_entered(_area):
	open_form()
	$FormMessage.modulate = Color.YELLOW
	await get_tree().create_timer(0.2).timeout
	$FormMessage.visible = false


func open_form():
	$AnimationPlayer.play("open_knives")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("form_attack")
	await $AnimationPlayer.animation_finished
	finish_attack()

func take_knife_1():
	var DevilsKnife1 = DevilsKnife.instantiate()
	DevilsKnife1.scale *= 0.6
	DevilsKnife1.rotation_speed = 0
	$Spamton/r_hand.add_child(DevilsKnife1)
	print($Spamton/r_hand.get_children())

func take_knife_2():
	var DevilsKnife2 = DevilsKnife.instantiate()
	DevilsKnife2.scale *= 0.5
	DevilsKnife2.rotation_speed = 0
	$Spamton/l_hand.add_child(DevilsKnife2)
	print($Spamton/l_hand.get_children())

func start_spin():
	$Spamton/AnimatedSpriteController/AnimatedSprite2D.play("laugh")
	$Spamton/l_hand.get_children()[0].rotation_speed = 0.5
	$Spamton/r_hand.get_children()[0].rotation_speed = 0.5

func finish_attack():
	emit_signal("attack_ended")
