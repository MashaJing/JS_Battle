extends Control


func _ready():
	$Menu/Start.grab_focus()


func _on_Start_button_down():
	var err = get_tree().change_scene(GlobalPlotSettings.GAME_SCENE_PATH)
	if err != OK:
		print("Ouch! Game could not be loaded, contact the developer plz")


func _on_Flee_button_down():
	get_tree().quit()
