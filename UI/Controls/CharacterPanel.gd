extends GridContainer

var NEXT_PLAYER
var PREVIOUS_PLAYER
var Decision = preload("res://team_stats/StatsEntities/DecisionMessage/DecisionMessage.tscn")

signal play(animation, blend, speed, from_back)
signal pass_turn()


func _ready():
	_init_neighbours()
	_init_signals()


func _init_neighbours():
	NEXT_PLAYER = TeamStats.get_next_hero(name)
	PREVIOUS_PLAYER = TeamStats.get_previous_hero(name)


func _init_signals():
	for hero in TeamStats.all_heroes:
		if hero != name:
			connect("pass_turn", get_parent().get_node(hero), "_on_passed_turn")
	connect("play", get_parent().get_node("AnimationPlayer"), "play")
	connect('canceled', DecisionStack, "pop_decision")	


func _on_decided(decision):
	print('CAUGHT DECIDED')
	decision.DECIDER = name
	
	match decision.TYPE: # предварительные действия при добавлении решения в стек
		'DEFENSE':
			DecisionReader.emit_signal("defend", decision.DECIDER)

	DecisionStack.add_decision(decision)
	print('closing...')

	_pass_turn()


func _pass_turn():
	close()
	if NEXT_PLAYER != null:
		emit_signal("pass_turn", NEXT_PLAYER)
	else:
		DecisionReader.start()


func _on_canceled():
	if PREVIOUS_PLAYER != null:
		DecisionStack.pop_decision()
		close()
		emit_signal("pass_turn", PREVIOUS_PLAYER)


func _on_passed_turn(player_name):
	if player_name == name:
		_init_neighbours()
		open()


func close():
	emit_signal("play", name + "_close", -1, 3.5)
	# деактивировать


func open():
	if get_parent().get_node("AnimationPlayer").is_playing():
		yield(get_parent().get_node("AnimationPlayer"), "animation_finished")
	emit_signal("play", name + "_close", -1, -1.5)
	# активировать
