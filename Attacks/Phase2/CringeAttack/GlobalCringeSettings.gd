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
#		"dialogue": false,
#		"text": ["Attention, Attention!", "A joke!", 'Why I was in favour of the kings?',
#		'because I was very...', 'CHAOSMATIC, CHAOSMATIC!'],
#		"main_word": "CHAOSMATIC",
#		"mode": Mode.EXPLODE,
#	},
#	{
#		"dialogue": false,
#		"text": [ "Listen, listen!", "Once I met a person, but I...", "didn't rEGGognize them!"],
#		"main_word": "rEGGognize",
#		"mode": Mode.SPIRAL,
#	}
	{
		"dialogue": false,
		"text": ['Though I don’t use sign language...', 'I know a lot of JESTERs!'],
		"main_word": "JESTERS",
		"mode": Mode.CHASE,
	}
]

var DIALOGUES = [
	{
		"dialogue": true,
		"text": "res://Assets/Texts/cringe_dialogues/d1.json",
		"main_word": "BADISON",
		"mode": Mode.PUNCH,
	},
	{
		"dialogue": true,
		"begins": "Spamton",
		"text": "res://Assets/Texts/cringe_dialogues/d2.json",
		"main_word": "CLOWNSTROPHOBIA",
		"mode": Mode.PUNCH,
	}

]


func next_joke():
	JOKE_IND += 1
	if JOKE_IND < len(JOKES):
		return JOKES[JOKE_IND]
