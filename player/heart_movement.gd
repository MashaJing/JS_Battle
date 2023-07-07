extends KinematicBody2D

export var speed : float = 200.0


func _ready():
	pass

func _physics_process(_delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		
	if direction.length() > 1:
		direction = direction.normalized()
	move_and_slide(direction * speed)