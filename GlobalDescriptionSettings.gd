extends Node2D

var LINE_INDEX = -1

var PHASE_0 = [
	"The air crackles with tension",
	"The curtains are about to burn", # ?
	"Stage lights are flickering", # ?
]

var PHASE_1 = [
	'...'
]

var PHASE_2 = [
	"Smells like basement casino",
	"Jevil and Spamton are incomprehensibly laughing to the audience",
	"Spamton calculates potential profit from opening a circus",
	"Spamton decides to hire just one employee, who will do everything",
	"He pulls my leg and makes me laugh",
]

var PHASE_3 = [
	"Now’s your chance to [die]",
	"I may not cry anymore",
	"Smells like basement casino",
	"Jevil offers to call their team JS. Spamton doesn't support it",
	"Spamton whispers about some Christmas kid", # ?
	"Jevil calls a volunteer from the audience for a dangerous musical performance",
	"Jevil doesn't have a surgeon license to perform it", # ?
]

var PHASE_4 = [
	"Something really BAD is coming!"
]

var PHASE_ULTIMATE = [
	"Something really BAD is here!"
]

var MAD_SPAM = []

var BATTLE_INFO = [PHASE_0, PHASE_1, PHASE_2, PHASE_3, PHASE_4, PHASE_ULTIMATE] 


func _on_new_turn():
	LINE_INDEX += 1

func get_current_description():
	if LINE_INDEX >= len(BATTLE_INFO[GlobalAttackSettings.PHASE_INDEX - 1]):
		LINE_INDEX = 0
	return "* " + BATTLE_INFO[GlobalAttackSettings.PHASE_INDEX - 1][LINE_INDEX]

#func set_battle_info():
#	Dialogic.set_variable('info_line', BATTLE_INFO[GlobalAttackSettings.CUR_PHASE_IND][LINE_INDEX])

func reset():
	LINE_INDEX = 0
