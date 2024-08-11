extends Control

signal finished
signal attack_by_character

# кто будет атаковать в данном ходу
var active_bars = []


func start_attacks(fighters):
	active_bars = fighters.duplicate()
	visible = true
	for bar in active_bars:
		get_node(bar).connect("bar_finished", Callable(self, "_on_bar_finished"))
		get_node(bar).initial_position = randi() % 3
		get_node(bar).start()
	
	
func _on_bar_finished(bar):
	if len(active_bars) == 0:
		visible = false
		emit_signal("finished")


func _input(ev):
	if (Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_Z)) and visible:
		var current_bars = get_bars_with_highest_priority()
		for bar in current_bars:
			get_node(bar).attack()
			active_bars.remove(active_bars.find(bar))


func get_bars_with_highest_priority():
	var min_position = 2
	var priority_bars = []

	for bar in active_bars:
		if get_node(bar).initial_position < min_position:
			min_position = get_node(bar).initial_position
			priority_bars.clear()

		if get_node(bar).initial_position == min_position:
			priority_bars.append(bar)
	
	return priority_bars
