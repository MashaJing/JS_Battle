extends Control
var FIRST_PLAYER
var LAST_PLAYER


func _ready():
	_init_edge_players()
	_init_signals()
	FIRST_PLAYER.open()


func _on_ended_decisions_reading():
	var fighters = AttackController.attacks.keys()
	if len(fighters) > 0:
		$AttackPanel.start_attacks(fighters)
		yield($AttackPanel, "finished")
	
	# выход из меню
	emit_signal("menu_ended")


func _init_signals():
	pass


func _init_edge_players():
	FIRST_PLAYER = $VBoxContainer/HBoxContainer.get_node(TeamStats.heroes[0])


# X нужно слушать на уровне меню и слать сигнал canceled всем заинтересованным. Каждый слушатель реализует реакцию по-своему (возможна дефолтная реализация)
func _input(ev):
	if Input.is_key_pressed(KEY_X):
		emit_signal("canceled")
