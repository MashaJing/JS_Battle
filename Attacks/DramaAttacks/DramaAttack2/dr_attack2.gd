extends Node

signal attack_ended

onready var WordSpawn = $WordSpawn
onready var WordSpawnTimer = $WordSpawnTimer
onready var AnimPlayer = $WordSpawn/AnimationPlayer
onready var Spamton = $WordSpawn/Spamton/AnimatedSprite

onready var WordScene = preload("res://Attacks/DramaAttacks/DramaAttack2/Word/Word.tscn")


var words = [
	"$POKER$", "SHES$", "$Monopoly$", "$TRUTH_or_DARE", "$#@MINECRAP", "$CRACKASSON",
	"ALIAS", "CHECKERS$", "H1DE-&-SEEK", "_______"
]

func _ready():
	Spamton.connect("animation_finished", self, "_on_Spamton_animation_finished")
	Spamton.play("increase_head")
# нормально дождаться окончания анимации
	yield(get_tree().create_timer(1), "timeout")
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
	Spamton.play("default")
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
