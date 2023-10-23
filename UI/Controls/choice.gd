extends Control


func init(options):
	for option in options:
		$ItemList.add_item(option)

func exit():
	$ItemList.clear()
