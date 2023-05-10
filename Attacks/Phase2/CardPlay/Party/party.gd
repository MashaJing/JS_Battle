extends Node2D

onready var cards = [
	"jevil_queen",
	"spam_tuz",
]
onready var attack = "res://Attacks/Attack2/Attack2.tscn"
onready var BulletCard = preload("res://Attacks/Phase2/CardPlay/Party/cards/card.tscn")
onready var CardSpawn = $CardSpawn/CardSpawnLocation


# Called when the node enters the scene tree for the first time.
func _ready():
	for card in cards:
		make_turn(card)
		yield($TurnTimer, "timeout")
	get_tree().change_scene(attack)

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
