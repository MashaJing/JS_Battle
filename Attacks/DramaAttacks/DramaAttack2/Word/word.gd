extends Node

var Letter = preload("res://Attacks/DramaAttacks/DramaAttack2/Word/Letters/Letter.tscn")
var word = '' setget set_word, get_word


# Called when the node enters the scene tree for the first time.
func _ready():
	var letterBullet
	for l in word:
		letterBullet = Letter.instance()
		letterBullet.letter = l
		add_child(letterBullet)
		yield(get_tree().create_timer(0.1), "timeout")


func get_word():
	pass

func set_word(new_word):
	word = new_word
	print(word)
