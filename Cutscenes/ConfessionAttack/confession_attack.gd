extends Node2D

onready var Jevil = $Jevil/AnimationPlayer
onready var Spamton = $Spamton/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Spamton.play("hit")
	Jevil.play("sad")
	yield(get_tree().create_timer(1.0), "timeout")
	Spamton.play("hug")
	Jevil.play("Hug")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
