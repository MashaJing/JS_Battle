extends Node2D

onready var cards = [
	"jevil_queen",
	"spam_tuz",
]

# нужно подумать над смыслом исхода игры - проиграл - и почему такая атака?
onready var spam_attack = "res://Attacks/Phase1/Attack2/Attack2.tscn"
onready var jevil_attack1 = "res://Attacks/Phase2/FerrisWheelAttack/FerrisWheelAttack.tscn"
onready var jevil_attack2 = "res://Attacks/Phase2/CashAttack/CashAttack.tscn"
onready var jevil_attack3 = "res://Attacks/Phase1/Attack3/Attack3.tscn"
onready var BulletCard = preload("res://Attacks/Phase2/CardPlay/Party/cards/card.tscn")
onready var CardSpawn = $CardSpawn/CardSpawnLocation
onready var Border = preload('res://Border/Border.tscn')
onready var PartyWinner = {
	"Spamton": [spam_attack],
	"Jevil": [jevil_attack1, jevil_attack2, jevil_attack3],
}


func init_border():
	var border = Border.instance()
	border.global_position = $KinematicHeart.global_position
	add_child(border)

func _ready():
	var winner = "Spamton"
	init_border()
	for card in cards:
		make_turn(card)
		yield($TurnTimer, "timeout")
		
	print(randi() % len(PartyWinner[winner]))
	print(randi() % len(PartyWinner[winner]))
	get_tree().change_scene(PartyWinner[winner][randi() % len(PartyWinner[winner])])

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
