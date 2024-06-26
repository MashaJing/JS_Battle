extends Control

signal play_pressed
signal play_changed


func show():
	visible = true

func _ready():
	visible = true


# для хилок, имён и всего, отображающегося без особых условий
func init(options):
	if len(options) > 0:
		for option in options:
			$ItemList.add_item(option)
		$ItemList.grab_focus()
		$ItemList.select(0)
	show()


# для действий
func init_actions(actions):
	for action in actions:
		$ItemList.add_item(action.name, action.icon,
							bool(TeamStats.TP >= action.tp_required))
	if $ItemList.get_item_count() > 0:
		$ItemList.grab_focus()
		$ItemList.select(0)
	show()


func exit():
	$ItemList.clear()
	visible = false


func _on_canceled():
	exit()


func _on_ItemList_item_activated(index):
	emit_signal("play_pressed")


func _on_ItemList_item_selected(index):
	emit_signal("play_changed")
