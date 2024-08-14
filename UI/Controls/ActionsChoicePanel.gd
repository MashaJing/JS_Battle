# для действий
extends PopupMenu

signal play_pressed
signal play_changed



func _ready():
	pass
#	set_hide_on_window_lose_focus(true)


func init(actions):
	clear()
	var id = 0
	for action in actions:
		add_icon_item(action.icon, action.name, id)
		set_item_disabled(id, bool(TeamStats.TP < action.tp_required))
		id += 1

func open():
	popup()
	if get_item_count() > 0:
		set_focused_item(0)

func exit():
	visible = false
	clear()

func _on_ChoicePanel_id_focused(id):
	emit_signal("play_changed")


func _on_ChoicePanel_id_pressed(id):
#	exit()
	emit_signal("play_pressed")
