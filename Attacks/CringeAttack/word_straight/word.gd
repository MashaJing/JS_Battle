extends Node2D

var Letter = preload("res://Attacks/CringeAttack/word_straight/Letters/Letter.tscn")
@export var word = ''

var target
var speed = 100
var acceleration
signal spawned_replica
var bullets = []


func _ready():
	pass


func move_from_path():
	for bullet in bullets:
		bullet.cur_mode = 'move_straight'
		bullet.direction = (target.global_position - bullet.global_position).normalized()
		bullet.acceleration = 400
		await get_tree().create_timer(0.1).timeout


func spawn_follow_path(path):
	var letterBullet
	var offset_delta = 1.0/len(word)
	path.progress_ratio = 1.0
	for l in word:
		path.progress_ratio -= offset_delta
		letterBullet = Letter.instantiate()
		letterBullet.letter = l
		# переименовать в stay_still
		letterBullet.cur_mode = 'spiral'
		add_child(letterBullet)
		letterBullet.position = path.global_position
		bullets.append(letterBullet)
	

func spawn_on_point():
	var letterBullet
	for l in word:
		letterBullet = Letter.instantiate()
		letterBullet.letter = l
		letterBullet.target = target
		letterBullet.speed = speed
		letterBullet.acceleration = acceleration
		add_child(letterBullet)
		await get_tree().create_timer(0.1).timeout


func blow_up():
	var letters = get_children()
	var angle = PI * 2 / len(letters)
	for i in range(len(letters)):
		letters[i].direction = Vector2(cos(angle * i), sin(angle * i))
		letters[i].cur_mode = 'move_straight'
		letters[i].speed = 10

func move_straight(acceleration=null, direction=null):
	var letters = get_children()
	for l in letters:
		# переименовать в mode, а енам в Mode
		l.cur_mode = 'move_straight'
		if acceleration != null:
			l.acceleration = acceleration
		if direction != null:
			l.direction = direction
