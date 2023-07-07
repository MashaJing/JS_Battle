extends Node2D

var Letter = preload("res://Attacks/Phase2/CringeAttack/word_straight/Letters/Letter.tscn")
var word = '' setget set_word, get_word

var target
var acceleration
signal spawned_replica


func _ready():
	pass

func spawn_follow_path(path):
	var letterBullet
	var offset_delta = 1.0/len(word)
	for l in word:
		path.set_offset(path.get_offset() + offset_delta)
		letterBullet = Letter.instance()
		letterBullet.letter = l
		letterBullet.cur_mode = 'spiral'
		letterBullet.speed = 0
		letterBullet.global_position = path.global_position
		print(letterBullet.position)
		add_child(letterBullet)
		#yield(get_tree().create_timer(0.1), "timeout")


func spawn_on_point(path):
	var letterBullet
	print(len(word))
	for l in word:
		letterBullet = Letter.instance()
		letterBullet.letter = l
		letterBullet.acceleration = acceleration
		letterBullet.target = target
		#letterBullet.direction = (target_position - global_position).normalized()
		add_child(letterBullet)
		yield(get_tree().create_timer(0.1), "timeout")


func get_word():
	pass

func set_word(new_word):
	word = new_word
	print(word)

func blow_up():
	var letters = get_children()
	var angle = PI * 2 / len(letters)
	for i in range(len(letters)):
		letters[i].direction = Vector2(cos(angle * i), sin(angle * i))
		letters[i].cur_mode = 'explode'
		letters[i].speed = 10
