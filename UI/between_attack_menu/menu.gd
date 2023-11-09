extends Node

signal attack_began

signal decided
signal canceled

# тоже типа стейт-машина?
enum State {
	CLOSED,
	KRIS_TURN,
	SUSIE_TURN,
	RALSEI_TURN,
}

var state = State.CLOSED
var Decision = preload("res://team_stats/StatsEntities/DecisionMessage/DecisionMessage.tscn")
var ChoicePanel = preload("res://UI/Controls/ChoicePanel.tscn")

var CUR_DECISION


# unused
func open_menu():
	$AnimationPlayer.play("kris_turn")
	state = State.KRIS_TURN
	$AnimationPlayer.handle_state(State.KRIS_TURN)

func switch_to_susie_from_kris():
	# лучше вынести, чтобы animationplayer не повторялся
	# внутри плеера сделать свитч, при вызове сметода делать update стейта
	# свитч внутри плеера ведет себя по стейту
	$AnimationPlayer.play("kris_turn", -1, 1.0, true)
	$AnimationPlayer.play("susie_turn")
	state = State.SUSIE_TURN

func switch_to_susie_from_ralsei():
	$AnimationPlayer.play("ralsei_turn", -1, 1.0, true)
	$AnimationPlayer.play("susie_turn")
	state = State.SUSIE_TURN

func switch_to_kris():
	$AnimationPlayer.play("susie_turn", -1, 1.0, true)
	$AnimationPlayer.play("kris_turn")
	state = State.KRIS_TURN

func switch_to_ralsei():
	$AnimationPlayer.play("susie_turn", -1, 1.0, true)
	$AnimationPlayer.play("ralsei_turn")
	state = State.RALSEI_TURN

func close_menu():
	$AnimationPlayer.play("ralsei_turn", -1, 1.0, true)
	state = State.CLOSED

# на ентер
func _on_made_turn():
	match state:
		State.CLOSED:
			pass
		State.KRIS_TURN:
			# передавать аргументом решение
			emit_signal("decided")
			switch_to_susie_from_kris()
		State.SUSIE_TURN:
			emit_signal("decided")
			switch_to_ralsei()
		State.RALSEI_TURN:
			emit_signal("decided")
			close_menu()

# на x
func _on_canceled_turn():
	match state:
		State.CLOSED:
			pass
		State.KRIS_TURN:
			pass
		State.SUSIE_TURN:
			switch_to_kris()
			emit_signal("canceled")
		State.RALSEI_TURN:
			switch_to_susie_from_ralsei()
			# важно помнить, что это отмена хода не Ральзея, а Сьюзи
			emit_signal("canceled")

func _ready():
	DecisionReader.connect("start_decisions_reading", self, "_on_started_decisions_reading")
	DecisionReader.connect("end_decisions_reading", self, "_on_ended_decisions_reading")
#	while len(DecisionStack.DECISIONS) < 3:
#		pass
#	print('that s all folks')
	# вызывать ридера
#	var team = ['kris', 'susie', 'ralsei']
#	$AnimationPlayer.play("hide_all", -1, 1.0, true)
#	# а как откатывать? -_- стейт-машина!!!
#	for member in team:
#		print(member)
#		yield(self, "decided")
#	call_deferred("emit_signal", "attack_began")

func _on_decided():
	# choice может собираться из глобальных переменных скрипта,
	# которые устанавливаются по нажатиям на кнопки
	var choice
	# choice обогатить, пихнуть в стек
	DecisionStack.add_decision(choice)

func _on_canceled():
	DecisionStack.pop_decision()

func hide():
	$AnimationPlayer.play("hide_all")
	$DebugButtons.visible = false

# должно вызываться 1 раз при открытии всего меню, а не отдельной панельки
func unhide():
	GlobalDialogueSettings.get_next()
	display_battle_info()
	
	$AnimationPlayer.play("hide_all", -1, 1.0, true)
	$DebugButtons.visible = true

func display_battle_info():
#	var dialogue = Dialogic.start("battle_info")
#	add_child(dialogue)
	$DebugButtons/KillJevilButton.grab_focus()

# _________________________DEBUG____________________________

func _on_KillJevilButton_button_down():
	kill_ally('JEVIL')

func _on_KillSpamtonButton_button_down():
	kill_ally('SPAMTON')

func kill_ally(ally_name):
	CUR_DECISION = Decision.instance()
	CUR_DECISION.TYPE = 'ATTACK'
	CUR_DECISION.VICTIM = ally_name
	DecisionStack.add_decision(CUR_DECISION)

# ========================= ITEM ========================= 

func _on_ItemButton_button_down():
	$ChoicePanel.init(Inventorium.get_visible_items())
	$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_item")

func use_item(index):
	CUR_DECISION = Decision.instance()
	CUR_DECISION.TYPE = 'ITEM'
	CUR_DECISION.DECIDER = TeamStats.heroes[len(DecisionStack.DECISIONS)].to_lower()
	CUR_DECISION.ITEM = Inventorium.reserve_item(index)
	return_to_common_menu("use_item")

	$ChoicePanel.init(TeamStats.all_heroes)
	$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_item_on_character")

func use_item_on_character(index):
	CUR_DECISION.VICTIM = TeamStats.all_heroes[index]
	DecisionStack.add_decision(CUR_DECISION)
	return_to_common_menu("use_item_on_character")

# ========================= DEFEND ========================= 

func _on_DefendButton_button_down():
	CUR_DECISION = Decision.instance()
	
	# тут заменить на cur_carracter, т.к. не всегда все будут доступны
	CUR_DECISION.DECIDER = TeamStats.heroes[len(DecisionStack.DECISIONS)].to_lower()
	CUR_DECISION.TYPE = 'DEFENSE'
	DecisionReader.emit_signal("defend_" + CUR_DECISION.DECIDER)
	DecisionStack.add_decision(CUR_DECISION)

# ========================= ACTION ========================= 

func _on_ActButton_button_down():
	CUR_DECISION = Decision.instance()
	CUR_DECISION.TYPE = 'ACT'
	CUR_DECISION.DECIDER = TeamStats.heroes[len(DecisionStack.DECISIONS)].to_lower()

	$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_action")
	$ChoicePanel.init_actions(ActionsInventorium.AVAILABLE_ACTIONS[CUR_DECISION.DECIDER])
	

func use_action(index):
	CUR_DECISION.ACTION = ActionsInventorium.AVAILABLE_ACTIONS[CUR_DECISION.DECIDER][index]
	ActionsController.start_action(CUR_DECISION.DECIDER, CUR_DECISION.ACTION)
	return_to_common_menu("use_action")

	if CUR_DECISION.ACTION.used_on != null:
		$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_action_on_character")
		$ChoicePanel.init(CUR_DECISION.ACTION.used_on)
	else:
		DecisionStack.add_decision(CUR_DECISION)	

func use_action_on_character(index):
	CUR_DECISION.VICTIM = CUR_DECISION.ACTION.used_on[index]
	return_to_common_menu("use_action_on_character")
	DecisionStack.add_decision(CUR_DECISION)	

# ========================= SPARE ========================= 

func _on_SpareButton_button_down():
	CUR_DECISION = Decision.instance()
	CUR_DECISION.TYPE = 'SPARE'
	CUR_DECISION.DECIDER = TeamStats.heroes[len(DecisionStack.DECISIONS)].to_lower()

	$ChoicePanel.init(ConStats.allies)
	$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_spare_on_character")

func use_spare_on_character(index):
	CUR_DECISION.VICTIM = ConStats.allies[index]
	DecisionStack.add_decision(CUR_DECISION)
	return_to_common_menu("use_spare_on_character")

func return_to_common_menu(processing_method):
	$ChoicePanel.exit()
	if $ChoicePanel.get_node("ItemList").is_connected("item_activated", self, processing_method):
		$ChoicePanel.get_node("ItemList").disconnect("item_activated", self, processing_method)
	$DebugButtons/KillJevilButton.grab_focus()

# ========================================================== 

func _on_ended_decisions_reading():
	var info = Dialogic.start('battle_info')
	add_child(info)
	yield(info, 'dialogic_signal')
	emit_signal("attack_began")


func _on_started_decisions_reading():
	hide()
