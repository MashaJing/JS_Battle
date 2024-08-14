extends Node2D

signal cringe_attack_ended

@onready var WordScene = preload("res://Attacks/CringeAttack/word_straight/Word.tscn")
var Border = preload("res://Border/Border.tscn")
var Heart = preload("res://player/KinematicHeart.tscn")
var wordBullet
const Mode = GlobalCringeSettings.Mode
@export var ATTACK_MODE: Mode


func add_border_and_heart():
	var scene_border = Border.instantiate()
	var scene_heart = Heart.instantiate()

	scene_border.global_position = $JokeTarget.global_position
	scene_heart.global_position = $JokeTarget.global_position
	add_child(scene_border)
	add_child(scene_heart)


func _ready():
	var cur_joke = GlobalCringeSettings.next_joke()
	ATTACK_MODE = cur_joke['mode']
	var joke = Dialogic.start(cur_joke['text'])
	add_child(joke)
	await joke.timeline_ended
	add_border_and_heart()
	
	match cur_joke['mode']:
		Mode.EXPLODE:
			explode_scenario(cur_joke)
		Mode.CHASE:
			chase_scenario(cur_joke)
		Mode.SPIRAL:
			spiral_scenario(cur_joke)
		Mode.PUNCH:
			punch_scenario(cur_joke)
	await get_tree().create_timer(5.5).timeout
	emit_signal("cringe_attack_ended")

func explode_scenario(cur_joke):
	$JokeTarget/ExplosionArea.bullet_limit = len(cur_joke['main_word'])
	generate_text_bullet(cur_joke['main_word'])
	blow_up()

func chase_scenario(cur_joke):
	generate_text_bullet(cur_joke['main_word'], $KinematicHeart, 10, 140)
	await get_tree().create_timer(4.0).timeout
	get_node('Word').move_straight()

func punch_scenario(cur_joke):
	punch(cur_joke['main_word'], $PunchPath/PathFollow2D, -600)
	await get_tree().create_timer(2.0).timeout
	punch(cur_joke['main_word'], $PunchPath2/PathFollow2D, 600, Vector2.UP)

func spiral_scenario(cur_joke):
	var word_bullet = generate_text_on_path($Spiral/SpiralFollow, cur_joke['main_word'])
	word_bullet.move_from_path()

func generate_text_on_path(path, text):
	var wordBullet = WordScene.instantiate()
	wordBullet.word = text
	wordBullet.spawn_follow_path(path)
	wordBullet.target = $JokeTarget
	add_child(wordBullet)
	return wordBullet

func generate_text_bullet(text, target_object=$JokeTarget, acceleration=250, speed=0):
	var wordBullet = WordScene.instantiate()
	wordBullet.word = text
	wordBullet.speed = speed
	wordBullet.acceleration = acceleration
	wordBullet.position = $JokeSpawn.global_position
	wordBullet.target = target_object
	add_child(wordBullet)
	wordBullet.spawn_on_point()

func blow_up():
	await $JokeTarget/ExplosionArea.full_house
	await get_tree().create_timer(1.0).timeout
	get_node('Word').blow_up()
	

func punch(text, path, acc=null, direction=null):
	var word_bullet = generate_text_on_path(path, text)
	word_bullet.move_straight(acc, direction)
