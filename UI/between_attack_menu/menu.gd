extends Node

signal attack_began
signal decided
signal canceled

# --------debug --------
signal heal
signal attack

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
# пора определиться с единым местом для их хранения
var characters = ['kris', 'susie', 'ralsei']


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
			

func _on_canceled(decision):
	# рассчитываю, что последнее затрется
	DecisionStack.pop_decision()

# вынести в отдельный обработчик, переиспользовать для каждой секции
func _on_Attack_button_down():
	print('Attack button pressed!')
	emit_signal("decided")
	var a = Decision.instance()
	a.TYPE = 'ATTACK'
	DecisionStack.add_decision(a)

func _on_Act_button_down():
	print('Act button pressed!')
	emit_signal("decided")
	var a = Decision.instance()
	a.TYPE = 'ACT'
	DecisionStack.add_decision(a)

func _on_Item_button_down():
	print('Item button pressed!')
	emit_signal("decided")

func _on_Spare_button_down():
	print('Spare button pressed!')
	emit_signal("decided")

func _on_Defense_button_down():
	print('Defense button pressed!')
	emit_signal("decided")


func hide():
	print("menu hidden")
	$AnimationPlayer.play("hide_all")
	$DebugButtons.visible = false

# должно вызываться 1 раз при открытии всего меню, а не отдельной панельки
func unhide():
	print("menu unhidden")
	GlobalDialogueSettings.get_next()
	display_battle_info()
	$AnimationPlayer.play("hide_all", -1, 1.0, true)
	$DebugButtons.visible = true


func display_battle_info():
	var dialogue = Dialogic.start("battle_info")
	add_child(dialogue)


# ___________DEBUG_____________

func _on_KillJevilButton_button_down():
	kill_ally('JEVIL')

func _on_KillSpamtonButton_button_down():
	kill_ally('SPAMTON')

func kill_ally(ally_name):
	CUR_DECISION = Decision.instance()
	CUR_DECISION.TYPE = 'ATTACK'
	CUR_DECISION.VICTIM = ally_name
	DecisionStack.add_decision(CUR_DECISION)


func _on_ItemButton_button_down():
	$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_item")	
	$ChoicePanel.visible = true
	$ChoicePanel.init(Inventorium.get_visible_items())


func use_item(index):
	CUR_DECISION = Decision.instance()
	CUR_DECISION.TYPE = 'ITEM'
	CUR_DECISION.ITEM = Inventorium.reserve_item(index) # но в случае возврата возвращать
	$ChoicePanel.exit()

	$ChoicePanel.get_node("ItemList").disconnect("item_activated", self, "use_item")

	$ChoicePanel.init(characters)
	$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_item_on_character")


func use_item_on_character(index):
	CUR_DECISION.VICTIM = characters[index]
	DecisionStack.add_decision(CUR_DECISION)
	$ChoicePanel.exit()
	$ChoicePanel.visible = false
	$ChoicePanel.get_node("ItemList").disconnect("item_activated", self, "use_item_on_character")


func _on_ended_decisions_reading():
	print('_________here comes dialogic!!!_________')
	var info = Dialogic.start('battle_info')
	add_child(info)
	yield(info, 'dialogic_signal')
	emit_signal("attack_began")

func _on_started_decisions_reading():
	$DebugButtons.visible = false

func _on_DefendButton_button_down():
	CUR_DECISION = Decision.instance()
	
	# тут заменить на cur_carracter, т.к. не всегда все будут доступны
	CUR_DECISION.DECIDER = characters[len(DecisionStack.DECISIONS)]
	CUR_DECISION.TYPE = 'DEFENSE'
	DecisionReader.emit_signal("defend_" + CUR_DECISION.DECIDER)
	DecisionStack.add_decision(CUR_DECISION)
