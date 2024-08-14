# для хилок, имён и всего, отображающегося без особых условий
extends PopupMenu

signal play_pressed
signal play_changed


func _ready():
	pass
#	set_hide_on_window_lose_focus(true)


func init(options):
	clear()
	if len(options) > 0:
		for option in options:
			add_item(option)

func exit():
	visible = false

func open():
	popup()
	if item_count > 0:
		set_focused_item(0)

func _on_ChoicePanel_id_focused(id):
	emit_signal("play_changed")


func _on_ChoicePanel_id_pressed(id):
	emit_signal("play_pressed")
