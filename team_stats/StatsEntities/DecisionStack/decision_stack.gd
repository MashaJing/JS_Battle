extends Node2D

var DECISIONS = []
var MAX_SIZE = 3


func _ready():
	print('HERE IS HOW STACK SEES IT')
	print(TeamStats.heroes)


func add_decision(new_decision):
	if len(DECISIONS) < MAX_SIZE:
		DECISIONS.append(new_decision)
	if len(DECISIONS) == MAX_SIZE:
		DecisionReader.start()


func pop_decision():
	if len(DECISIONS) > 0:
		return DECISIONS.pop_front()
	else:
		print("trying to get decision from empty stack")


# на всякий
func clear():
	DECISIONS.clear()
