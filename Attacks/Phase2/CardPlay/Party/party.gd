extends Node2D


@onready var BulletCard = preload("res://Attacks/Phase2/CardPlay/Party/cards/card.tscn")
@onready var CardSpawn = $CardSpawn/CardSpawnLocation

signal attack_ended


func toggle_main(on=true):
	if on:
		get_parent().get_node("Spamton").visible = true
		$BorderField/FieldCollision.disabled = false
		$BorderField.z_index = 0
		$KinematicHeart.ensable()
	else:
		get_parent().get_node("Spamton").visible = false
		$BorderField/FieldCollision.disabled = true
		$BorderField.z_index = -5
		$KinematicHeart.disable()


func _ready():
	var cur_party = GlobalPartySettings.pick_random()

	while cur_party != null:
		for card in cur_party['cards']:
			make_turn(card)
			await $TurnTimer.timeout
		var cur_attack = load(cur_party["attack_path"]).instantiate()
		toggle_main(false)
		
		add_child(cur_attack)
		await cur_attack.card_attack_ended
		remove_child(cur_attack)
		toggle_main(true)
		
		cur_party = GlobalPartySettings.pick_random()

	var Dialog = Dialogic.start("card_play")
	add_child(Dialog)
	await Dialogic.timeline_ended
	emit_signal("attack_ended")


func make_turn(card_name):
	# выбрать рандомную точку, откуда полетит карта
	CardSpawn.progress_ratio = randf()
	var bullet_card = BulletCard.instantiate()

	# задаем в анимации только конечную 
	# позицию, начальную определили в главной сцене
	bullet_card.position = CardSpawn.position
	bullet_card.texture = card_name
	bullet_card.finish_point = $TableCenter.global_position
	add_child(bullet_card)
