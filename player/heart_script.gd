extends Area2D

signal health_changed(damage)
export var speed : float = 200.0


func _ready():
	pass

func _process(delta):
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
	position += direction * speed * delta


func take_damage():
	$CollisionShape2D.set_deferred("disabled", true)
	print('took_damage')

	# анимация + звук дамага
	$AnimationPlayer.play("damage")
	$SoundDamage.play()

	# сигнал о получении дамага (принимает Attacktarget в сцене main)	
	# todo: переименовать в take_damage или типа того
	emit_signal("health_changed")

	# Даём 2 секунды неуязвимости
	yield(get_tree().create_timer(2.0), "timeout")
	$CollisionShape2D.set_deferred("disabled", false)

func _on_Heart_area_entered(area):
	print('ENTERED!')
	take_damage()
