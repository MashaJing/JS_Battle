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

	if Input.is_action_just_pressed("x"):
		speed = 100.0
	if Input.is_action_just_released("x"):
		speed = 200.0
		
		
	if direction.length() > 1:
		direction = direction.normalized()
	move_and_slide(direction * speed)


func disable():
	visible = false
	speed = 0
	$Heart/TP/TPCollisionShape.disabled = true
	$Heart/CollisionPolygon2D.disabled = true

func ensable():
	visible = true
	speed = 200.0
	$Heart/TP/TPCollisionShape.disabled = false
	$Heart/CollisionPolygon2D.disabled = false
