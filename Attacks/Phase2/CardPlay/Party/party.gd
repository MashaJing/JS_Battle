extends Node2D


onready var BulletCard = preload("res://Attacks/Phase2/CardPlay/Party/cards/card.tscn")
onready var CardSpawn = $CardSpawn/CardSpawnLocation

signal attack_ended


func _ready():
	var cur_party = GlobalPartySettings.pick_random()
	if cur_party != null:
		for card in cur_party['cards']:
			make_turn(card)
			yield($TurnTimer, "timeout")
		
		# todo: тут тоже add_child
		get_tree().change_scene(cur_party["attack_path"])
	else:
		emit_signal("attack_ended")
		$Spamton.speak("OK OK OK")
		yield($Spamton, "stopped_talk")
		$Spamton.speak("I GUESS U [win]")
		yield($Spamton, "stopped_talk")
		emit_signal("attack_ended")

func make_turn(card_name):
	# выбрать рандомную точку, откуда полетит карта
	CardSpawn.unit_offset = randf()
	var bullet_card = BulletCard.instance()

	# задаем в анимации только конечную 
	# позицию, начальную определили в главной сцене
	bullet_card.position = CardSpawn.position
	bullet_card.texture = card_name
	bullet_card.finish_point = $TableCenter.global_position
	add_child(bullet_card)
