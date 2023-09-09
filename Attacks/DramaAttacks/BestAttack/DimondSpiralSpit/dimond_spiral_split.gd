extends Node2D
var jevil_speed = 0
var spawn_on = false
onready var bullet_batch = preload('res://Bullets/WhiteDimond/WhiteDimond.tscn')
var bullets = []
signal ended_path


func _ready():
	$AnimationPlayer.play("Jevil_attack")


func start_movement():
	jevil_speed = 10
	spawn_on = true
	
func start_bullet_movement():
	$BulletMoveTimer.start()
	for bullet in bullets:
		bullet.speed = 300
		yield($BulletMoveTimer, "timeout")
	

func stop_movement():
	$AudioStreamPlayer2D.stop()
	jevil_speed = 0
	print('stopped!!')
	spawn_on = false
	$Path2D/PathFollow2D/Jevil.queue_free()


func _process(delta):
	$Path2D/PathFollow2D.unit_offset += jevil_speed * delta
	if spawn_on:
		spawn_bullet()
	if $Path2D/PathFollow2D.unit_offset > 0.95:
		emit_signal('ended_path')


func spawn_bullet():
	$AudioStreamPlayer2D.play()
	var batch = bullet_batch.instance()
	batch.heart_position = $BorderField.global_position
	batch.speed = 0
	batch.global_position = $Path2D/PathFollow2D/Jevil.global_position
	add_child(batch)
	bullets.append(batch)


func _on_DimondSpiralSplit_ended_path():
	stop_movement()
	start_bullet_movement()
