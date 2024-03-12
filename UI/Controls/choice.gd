extends Control


func show():
	visible = true

func _ready():
	get_parent().connect("canceled", self, "_on_canceled")


# для хилок, имён и всего, отображающегося без особых условий
func init(options):
	print('_____________INITED CANCELED_____________')	
	for option in options:
		$ItemList.add_item(option)
	show()
	$ItemList.grab_focus()
	$ItemList.select(0)

func exit():
	$ItemList.clear()
	visible = false

func init_actions(actions):
	print('_____________INITED CANCELED_____________')	
	get_parent().connect("canceled", self, "_on_canceled")

	for action in actions:
		$ItemList.add_item(action.name, action.icon,
							bool(TeamStats.TP >= action.tp_required))
	show()
	$ItemList.grab_focus()
	$ItemList.select(0)

# вместо этого - глобальный эммитер
#func _input(ev):
#	if Input.is_key_pressed(KEY_X):
#		exit()
#		get_parent().unhide()

func _on_canceled():
		print('_____________CAUGHT CANCELED_____________')
		exit()
		get_parent().unhide()

