extends Node2D

var DECISIONS = []
var MAX_SIZE = 3


func add_decision(new_decision):
	if len(DECISIONS) < MAX_SIZE:
		DECISIONS.append(new_decision)
	for i in DECISIONS:
		print(i.TYPE)


func pop_decision():
	if len(DECISIONS) > 0:
		return DECISIONS.pop_front()
	else:
		print("trying to get decision from empty stack")


# на всякий
func clear():
	DECISIONS.clear()
