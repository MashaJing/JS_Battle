extends Node2D

var CUR_LINE_IND = -1
var BATTLE_INFO = [
	"The air crackles with tension",
	"The curtains are burning", # ?
	"Stage lights are flickering", # ?

#	после примерения
	"Now Jevil is happy and he may not cry",  # ???
	"Smells like casino",
	"Now’s your chance to [die]",
	"Jevil and Spamton are incomprehensibly laughing to the audience. Someone aplouds",
	"Jevil offers to call their team JS. Spamton doesn't support it",
	"Smells like casino",
	"Spamton calculates potential profit from opening a circus",
	"Spamton decides to hire just one employee, who will do everything",
	"He pulls my leg and makes me laugh",
	"Spamton whispers about some Christmas kid",
]

func get_next():
	CUR_LINE_IND += 1
	# выкидывать первые две фазы, если они помирились
	if CUR_LINE_IND < len(BATTLE_INFO):
		Dialogic.set_variable('info_line', BATTLE_INFO[CUR_LINE_IND])
	else:
		print('а всё, а больше нет диалогов') # должны закончиться вместе с макс кол-вом атак
