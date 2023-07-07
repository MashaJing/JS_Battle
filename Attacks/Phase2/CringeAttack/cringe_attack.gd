extends Node2D

onready var WordScene = preload("res://Attacks/Phase2/CringeAttack/word_straight/Word.tscn")
var wordBullet 
var JOKE_TEXT = ['once I met a person, but I...']
var PUNCH_TEXT = "didn't rEGGognize them!"
enum Mode {
	EXPLODE = 0,
	CHASE,
	SPIRAL,
	PUNCH,
}
export(Mode) var ATTACK_MODE = Mode.CHASE
onready var cringeSpawner = $Jevil


func _ready():
	$Jevil/AnimationPlayer.play("default")
	$Spamton/AnimatedSprite.play("laugh")
	for replica in JOKE_TEXT:
		cringeSpawner.speak(replica)
		yield(cringeSpawner, "stopped_talk")
	cringeSpawner.speak(PUNCH_TEXT)
	yield(cringeSpawner, "stopped_talk")

	match ATTACK_MODE:
		Mode.EXPLODE:
			explode_scenario()
		Mode.CHASE:
			chase_scenario()
		Mode.SPIRAL:
			spiral_scenario()
		Mode.PUNCH:
			punch_scenario()

func explode_scenario():
	$JokeTarget/ExplosionArea.bullet_limit = len(PUNCH_TEXT.replace(' ', ''))
	generate_text_bullet()
	blow_up()

func chase_scenario():
	generate_text_bullet($KinematicHeart, 1)

func punch_scenario():
	pass

func spiral_scenario():
	generate_text_on_path()
	print('и тут я начинаю крутить')


func generate_text_on_path():
	# вот тут вызываем функцию spread_on_path
	var wordBullet = WordScene.instance()
	wordBullet.word = PUNCH_TEXT.replace(' ', '')
	wordBullet.spawn_follow_path($Spiral/SpiralFollow)
	add_child(wordBullet)


func generate_text_bullet(target_object=$JokeTarget, acceleration=250):
	var wordBullet = WordScene.instance()
	wordBullet.word = PUNCH_TEXT.replace(' ', '')
	wordBullet.acceleration = acceleration
	wordBullet.position = $JokeSpawn.global_position
	wordBullet.target = target_object
	add_child(wordBullet)

func blow_up():
	yield($JokeTarget/ExplosionArea, 'full_house')
	yield(get_tree().create_timer(1.0), 'timeout')
	print('и тут я начинаю шмалять!')
	get_node('Word').blow_up()
