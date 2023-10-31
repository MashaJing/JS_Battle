extends Control


# для хилок, имён и всего, отображающегося без особых условий
func init(options):
	for option in options:
		$ItemList.add_item(option)

func exit():
	$ItemList.clear()

func init_actions(actions):
	for action in actions:
		$ItemList.add_item(action.name, action.icon,
							bool(TeamStats.TP >= action.tp_required))
		print(action.name)
		print(bool(TeamStats.TP >= action.tp_required))
