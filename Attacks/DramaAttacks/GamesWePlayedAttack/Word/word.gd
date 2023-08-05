extends Node

var Letter = preload("res://Attacks/DramaAttacks/GamesWePlayedAttack/Word/Letters/Letter.tscn")
var word = '' setget set_word, get_word

var target_position = Vector2.ZERO
signal spawned_replica


func _ready():
	var letterBullet
	for l in word:
		letterBullet = Letter.instance()
		letterBullet.letter = l
		add_child(letterBullet)
		yield(get_tree().create_timer(0.08), "timeout")
	emit_signal('spawned_replica')

func get_word():
	pass

func set_word(new_word):
	word = new_word
	print(word)
