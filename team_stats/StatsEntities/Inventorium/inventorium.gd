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

#func release_item(index):
#	var actual_index = get_item_index_with_reserved(index)
#	# возможно, тут тоже потребуется get_item_index_with_reserved
#	print('item ' + CONTENTS[actual_index].name + ' released')
#	CONTENTS[actual_index].reserved = false
#	return CONTENTS[actual_index]

#func clear_reserved():
#	var new_items = []
#	for item in CONTENTS:
#		if not item.reserved:
#			new_items.append(item)
#	CONTENTS = new_items

func get_visible_items():
	var all_items = []
	for item in CONTENTS:
		all_items.append(item.name)
	print(all_items)
	return all_items

#func get_item_index_with_reserved(index):
#	var i = 0
#	while index >= i:
#		if CONTENTS[i].reserved:
#			# мы корректируем индекс, учитывая невидимые пользователю зарезервированные предметы
#			index+=1
#		i+=1
#	return index

func add_item(item):
	if len(CONTENTS) + 1 <= MAX_CONTENTS_LEN:
		CONTENTS.append(item)
	else:
		emit_signal("full")

func init_contents():
	CONTENTS = [
	 HealItem.new("TOP_CAKE", 12000),
	 HealItem.new("BITTEN_BURRITO", 12000000),
	 HealItem.new("USELESS_DEBUG_BURRITO", 0),
	 HealItem.new("USELESS_DEBUG_BURRITO", 0),
	]
