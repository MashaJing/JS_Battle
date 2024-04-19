extends Node2D

var DECISIONS = []
onready var MAX_SIZE = len(TeamStats.all_heroes)

signal decision_canceled


func _ready():
	print('HERE IS HOW STACK SEES IT')
	print(TeamStats.heroes)


func add_decision(new_decision):
	if len(DECISIONS) < MAX_SIZE:
		DECISIONS.append(new_decision)


func pop_decision():
	if len(DECISIONS) > 0:
		return DECISIONS.pop_front()
		emit_signal("decision_canceled")
	else:
		print("[INFO] trying to get decision from empty stack")


# на всякий
func clear():
	DECISIONS.clear()
