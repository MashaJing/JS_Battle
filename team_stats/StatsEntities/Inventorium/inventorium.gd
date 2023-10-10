extends Node2D

class HealItem:
	var name
	var hp_delta
	
	func _init(name, hp_delta):
		self.name = name
		self.hp_delta = hp_delta

# СКОЛЬКО?
var MAX_CONTENTS_LEN = 15

# На крайняк не буду выпендриваться и через словари
onready var CONTENTS = [
	 HealItem.new("top_cake", 120),
	 HealItem.new("top_cake2", 100000000),
]
signal full


func _ready():
	print(CONTENTS)


func pop_item(name):
	pass
	# реализовать быстрый get без перебора имен всех классов.


func add_item(item):
	if len(CONTENTS) + 1 <= MAX_CONTENTS_LEN:
		CONTENTS.append(item)
	else:
		emit_signal("full")
