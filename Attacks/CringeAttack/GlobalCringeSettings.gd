extends Node2D

enum Mode {
	EXPLODE = 0,
	CHASE,
	SPIRAL,
	PUNCH,
}
var JOKE_IND = -1

# Идут по порядку, чтоб звучало органичнее
var JOKES = [
#	{
#		"text": "joke_chaosmatic",
#		"main_word": "CHAOSMATIC",
#		"mode": Mode.EXPLODE,
#	},
#	{
#		"text": "joke_egg",
#		"main_word": "REGGOGNIZE",
#		"mode": Mode.SPIRAL,
#	},
#	{
#		"text": "joke_jesters",
#		"main_word": "JESTURES",
#		"mode": Mode.CHASE,
#	},
	{
		"text": "joke_baddison",
		"main_word": "BADISON_BADISON_BADISON_BADISON",
		"mode": Mode.PUNCH,
	},
	{
		"text": "joke_clownstrophobia",
		"main_word": "CLOWNSTROPHOBIA_CLOWNSTROPHOBIA",
		"mode": Mode.PUNCH,
	}

]


func next_joke():
	JOKE_IND += 1
	if JOKE_IND < len(JOKES):
		return JOKES[JOKE_IND]
