extends Node

signal sub_attack_ended

# какого хрена оно тут делает
var target = ["Kris", "Susie", "Ralsei"]

@onready var WordSpawn = $WordSpawn
@onready var WordSpawnTimer = $WordSpawnTimer
@onready var AnimPlayer = $WordSpawn/AnimationPlayer
@onready var GlobalSpamton = get_parent().get_parent().get_node("Spamton")
@onready var Spamton = $WordSpawn/Spamton/AnimatedSpriteController/AnimatedSprite2D

@onready var WordScene = preload("res://Attacks/DramaAttacks/GamesWePlayedAttack/Word/Word.tscn")

var words = [
	"$POKER$", "$Monopoly$", "$TRUTH_or_DARE", "@MINECRAP@", "$CRACKASSON",
	"CHECKERS$", "H1DE-&-SEEK", "DUNGEONS_&_D3VILS", "_____________"
]


func _ready():
	GlobalSpamton.visible = false
	# заиспользовать своего локального Спамтона в этой сцене
	Spamton.connect("animation_finished", Callable(self, "_on_Spamton_animation_finished"))
	Spamton.play("increase_head")
	# нормально дождаться окончания анимации
	await Spamton.animation_finished
	Spamton.play("head_attack")
	AnimPlayer.play("spawn_wave")
	var word = ''
	for i in range(9):
		var wordBullet = WordScene.instantiate()
		wordBullet.word = words[i]
		add_child(wordBullet)
		wordBullet.position = WordSpawn.global_position
		await wordBullet.spawned_replica
	AnimPlayer.stop()
	Spamton.visible = false
	GlobalSpamton.visible = true
	emit_signal("sub_attack_ended")


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
