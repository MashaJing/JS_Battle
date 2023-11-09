extends Control


func show():
	visible = true
	$ItemList.grab_focus()

# для хилок, имён и всего, отображающегося без особых условий
func init(options):
	for option in options:
		$ItemList.add_item(option)
	show()

func exit():
	$ItemList.clear()
	visible = false

func init_actions(actions):
	for action in actions:
		$ItemList.add_item(action.name, action.icon,
							bool(TeamStats.TP >= action.tp_required))
	show()
