extends Node2D


onready var BulletCard = preload("res://Attacks/Phase2/CardPlay/Party/cards/card.tscn")
onready var CardSpawn = $CardSpawn/CardSpawnLocation

signal attack_ended


func _ready():
	var cur_party = GlobalPartySettings.pick_random()

	while cur_party != null:
		for card in cur_party['cards']:
			make_turn(card)
			yield($TurnTimer, "timeout")
		var cur_attack = load(cur_party["attack_path"]).instance()
		$KinematicHeart.disable()
		add_child(cur_attack)
		yield(cur_attack, "card_attack_ended")
		remove_child(cur_attack)
		$KinematicHeart.ensable()
		cur_party = GlobalPartySettings.pick_random()

	var Dialog = Dialogic.start("card_play")
	add_child(Dialog)
	yield(Dialog, "dialogic_signal")
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
