extends Node2D

var PARTY_ROOT_SCENE_PATH = "res://Attacks/Phase2/CardPlay/Party/Party.tscn"
var PARTIES = [
#	{
#		"winner": "Spamton",
#		"attack_path": "res://Attacks/Phase2/FerrisWheelAttack/FerrisWheelAttack.tscn",
#		"cards": [
#			"jevil_queen",
#			"spam_tuz",
#		]
#	},
#	{
#		"winner": "Jevil",
#		"attack_path": "res://Attacks/Phase2/CashAttack/CashAttack.tscn",
#		"cards": [
#			"spam_queen",
#			"jevil_joker"
#		]
#	},
	{
		"winner": "Jevil",
		"attack_path": "res://Attacks/Phase2/SpamLetter/SpamLetter.tscn",
		"cards": [
			"spam_queen",
			"jevil_joker"
		]
	},
#		{
#		"winner": "Jevil",
#		"attack_path": "res://Attacks/Phase2/FriedPipisAttack/FriedPipisAttack.tscn",
#		"cards": [
#			"spam_queen",
#			"jevil_joker"
#		]
#	}
]


func pick_random():
	if len(PARTIES) > 0:
		var pos = randi() % len(PARTIES)
		return PARTIES.pop_at(pos)
