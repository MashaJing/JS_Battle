extends Node2D

onready var WordScene = preload("res://Attacks/Phase2/CringeAttack/word_straight/Word.tscn")
var wordBullet 
const Mode = GlobalCringeSettings.Mode
export(Mode) var ATTACK_MODE
onready var cringeSpawner = $Jevil


func _ready():
	var cur_joke = GlobalCringeSettings.next_joke()
	ATTACK_MODE = cur_joke['mode']
	if cur_joke['dialogue']:
		# чтобы использовать функцию воспроизведения диалога, её лучше глобально объявить
		pass
	else:
		$Spamton/AnimatedSprite.play("default")
		$Jevil/AnimationPlayer.play("default")
		for replica in cur_joke['text']:
			cringeSpawner.speak(replica)
			yield(cringeSpawner, "stopped_talk")
		$Spamton/AnimatedSprite.play("laugh")
		$Jevil/AnimatedSprite.play("Facepalm")

	match ATTACK_MODE:
		Mode.EXPLODE:
			explode_scenario(cur_joke)
		Mode.CHASE:
			chase_scenario(cur_joke)
		Mode.SPIRAL:
			spiral_scenario(cur_joke)
		Mode.PUNCH:
			punch_scenario(cur_joke)

func explode_scenario(cur_joke):
	$JokeTarget/ExplosionArea.bullet_limit = len(cur_joke['main_word'])
	generate_text_bullet(cur_joke['main_word'])
	blow_up()

func chase_scenario(cur_joke):
	generate_text_bullet(cur_joke['main_word'], $KinematicHeart, 10, 140)
	yield(get_tree().create_timer(4.0), "timeout")
	get_node('Word').move_straight()

func punch_scenario(cur_joke):
	punch(cur_joke['main_word'], $PunchPath/PathFollow2D, -600)
	yield(get_tree().create_timer(2.0), "timeout")
	punch(cur_joke['main_word'], $PunchPath2/PathFollow2D, 600, Vector2.UP)

func spiral_scenario(cur_joke):
	var word_bullet = generate_text_on_path($Spiral/SpiralFollow, cur_joke['main_word'])
	word_bullet.move_from_path()

func generate_text_on_path(path, text):
	var wordBullet = WordScene.instance()
	wordBullet.word = text.replace(' ', '')
	wordBullet.spawn_follow_path(path)
	wordBullet.target = $JokeTarget
	add_child(wordBullet)
	return wordBullet

func generate_text_bullet(text, target_object=$JokeTarget, acceleration=250, speed=0):
	var wordBullet = WordScene.instance()
	wordBullet.word = text.replace(' ', '')
	wordBullet.speed = speed
	wordBullet.acceleration = acceleration
	wordBullet.position = $JokeSpawn.global_position
	wordBullet.target = target_object
	add_child(wordBullet)
	wordBullet.spawn_on_point()

func blow_up():
	yield($JokeTarget/ExplosionArea, 'full_house')
	yield(get_tree().create_timer(1.0), 'timeout')
	get_node('Word').blow_up()

func punch(text, path, acc=null, direction=null):
	var word_bullet = generate_text_on_path(text, path)
	word_bullet.move_straight(acc, direction)
