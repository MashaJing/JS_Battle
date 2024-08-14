extends Node2D

class HealItem:
	var name
	var hp_delta

	func _init(_name, _hp_delta):
		self.name = _name
		self.hp_delta = _hp_delta

# СКОЛЬКО?
var MAX_CONTENTS_LEN = 15

var CONTENTS = []
signal full


func _ready():
	# На крайняк не буду выпендриваться и через словари
	init_contents()

func reset():
	init_contents()
#
#func pop_item(name):
#	# реализовать быстрый get без перебора имен всех классов.
#	print('item name')
#	print(name)
#	for i in len(CONTENTS):
#		if CONTENTS[i].name == name:
#			return CONTENTS.pop_at(i)
#	print('item not found')

func get_item(index):
	print('item ' + CONTENTS[index].name + ' taken')
	return CONTENTS.pop_at(index)

func get_visible_items():
	var all_items = []
	for item in CONTENTS:
		all_items.append(item.name)
	print(all_items)
	return all_items

func add_item(item):
	if item == null:
		print("nothing to cancel")
		return
	if len(CONTENTS) + 1 <= MAX_CONTENTS_LEN:
		CONTENTS.append(item)
	else:
		emit_signal("full")
	CONTENTS.sort_custom(Callable(ItemSorter, "sort"))

func init_contents():
	CONTENTS = [
	 HealItem.new("BITTEN_BURRITO", 12000000),
	 HealItem.new("TOP_CAKE", 12000),
	 HealItem.new("USELESS_DEBUG_BURRITO", 0),
	 HealItem.new("USELESS_DEBUG_BURRITO", 0),
	]


class ItemSorter:
	static func sort(a, b):
		if a.name < b.name:
			return true
		return false

