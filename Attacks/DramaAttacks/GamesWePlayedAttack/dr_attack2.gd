extends Node

signal attack_ended

# какого хрена оно тут делает
var target = ["Kris", "Susie", "Ralsei"]

onready var WordSpawn = $WordSpawn
onready var WordSpawnTimer = $WordSpawnTimer
onready var AnimPlayer = $WordSpawn/AnimationPlayer
onready var Spamton = $WordSpawn/Spamton/AnimatedSprite

onready var WordScene = preload("res://Attacks/DramaAttacks/GamesWePlayedAttack/Word/Word.tscn")
onready var Border = preload('res://Border/Border.tscn')

var words = [
	"$POKER$", "SHES$", "$Monopoly$", "$TRUTH_or_DARE", "$#@MINECRAP", "$CRACKASSON",
	"ALIAS", "CHECKERS$", "H1DE-&-SEEK", "_______"
]


func init_border():
	var border = Border.instance()
	border.global_position = $KinematicHeart.global_position
	add_child(border)

func _ready():
	init_border()
	# todo: да это жоско
	var Spamton_from_parent = get_parent().get_parent().get_node("TeamStats/Spamton")
	Spamton_from_parent.visible = false
	Spamton.connect("animation_finished", self, "_on_Spamton_animation_finished")
	Spamton.play("increase_head")
	# нормально дождаться окончания анимации
	yield(Spamton, "animation_finished")
	Spamton.play("head_attack")
	AnimPlayer.play("spawn_wave")
	var word = ''
	for i in range(10):
		var wordBullet = WordScene.instance()
		wordBullet.word = words[i]
		add_child(wordBullet)
		wordBullet.position = WordSpawn.global_position
		yield(WordSpawnTimer, "timeout")
	AnimPlayer.stop()
	Spamton.visible = false
	Spamton_from_parent.visible = true
	emit_signal("attack_ended")


func _on_Spamton_animation_finished():
	pass
	#Spamton.play("head_attack")
	#AnimPlayer.play("spawn_wave")	
	#var word = ''
	#for i in range(10):
#		var wordBullet = WordScene.instance()
#		wordBullet.word = words[randi() % len(words)]
#		add_child(wordBullet)
#		wordBullet.position = WordSpawn.global_position		
#		yield(WordSpawnTimer, "timeout")
