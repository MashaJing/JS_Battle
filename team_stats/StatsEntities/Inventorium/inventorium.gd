extends Node2D

class HealItem:
	var name
	var hp_delta
	var reserved = false
	
	func _init(name, hp_delta):
		self.name = name
		self.hp_delta = hp_delta

# СКОЛЬКО?
var MAX_CONTENTS_LEN = 15

var CONTENTS = []
signal full


func _ready():
	# На крайняк не буду выпендриваться и через словари
	CONTENTS = [
	 HealItem.new("TOP_CAKE", 12000),
	 HealItem.new("BITTEN_BURRITO", 12000000),
	 HealItem.new("USELESS_DEBUG_BURRITO", 0),
	 HealItem.new("USELESS_DEBUG_BURRITO", 0),
	]

#
#func pop_item(name):
#	# реализовать быстрый get без перебора имен всех классов.
#	print('item name')
#	print(name)
#	for i in len(CONTENTS):
#		if CONTENTS[i].name == name:
#			return CONTENTS.pop_at(i)
#	print('item not found')

func reserve_item(index):
	var actual_index = get_item_index_with_reserved(index)
	print('item ' + CONTENTS[actual_index].name + ' reserved')
	CONTENTS[actual_index].reserved = true
	return CONTENTS[actual_index]

func release_item(index):
	# возможно, тут тоже потребуется get_item_index_with_reserved
	print('item ' + name + ' released')
	CONTENTS[index].reserved = false
	return CONTENTS[index]

func clear_reserved():
	var new_items = []
	for item in CONTENTS:
		if not item.reserved:
			new_items.append(item)
	CONTENTS = new_items
	print(CONTENTS)

func get_visible_items():
	var all_items = []
	for item in CONTENTS:
		if not item.reserved:
			all_items.append(item.name)
	return all_items

func get_item_index_with_reserved(index):
	var i = 0
	while index >= i:
		if CONTENTS[i].reserved:
			# мы корректируем индекс, учитывая невидимые пользователю зарезервированные предметы
			index+=1
		i+=1
	return index

func add_item(item):
	if len(CONTENTS) + 1 <= MAX_CONTENTS_LEN:
		CONTENTS.append(item)
	else:
		emit_signal("full")
