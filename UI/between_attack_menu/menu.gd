extends Node

signal menu_ended

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

func close_menu():
	$DebugButtons/DescriptionLabel.visible = false
	$AnimationPlayer.play("ralsei_turn", -1, 1.0, true)
	state = State.CLOSED

func _ready():
	_init_signals()

func _on_decided():
	# choice может собираться из глобальных переменных скрипта,
	# которые устанавливаются по нажатиям на кнопки
	var choice
	# choice обогатить, пихнуть в стек
	DecisionStack.add_decision(choice)

func hide():
	$AnimationPlayer.play("hide_all")
	$DebugButtons.visible = false

# должно вызываться 1 раз при открытии всего меню, а не отдельной панельки
func unhide():
	$DebugButtons/KillJevilButton.grab_focus()
	$AnimationPlayer.play("hide_all", -1, 1.0, true)
	$DebugButtons.visible = true
	var description = GlobalDialogueSettings.get_current_description()
	show_letters(description)

# __________________DESCRIPTION STRING___________________________

func show_letters(text):
	$DebugButtons/DescriptionLabel.visible_characters = 0
	$DebugButtons/DescriptionLabel.text = text
	$LetterTimer.start()
	for i in range(len(text)):
		yield($LetterTimer, "timeout")
		$DebugButtons/DescriptionLabel.visible_characters += 1
	$LetterTimer.stop()
	$DebugButtons/DescriptionLabel.visible = true

# _________________________DEBUG_________________________________

func _on_KillJevilButton_button_down():
	# по приколу оставить и скамить людей (на самом деле, кнопка повышает атаку джевила в 10000000 раз)
	# цель: ваншотнуть и позлить
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
	# Шаг 1. Составить панель с выбором айтемов и дождаться выбора доступной хилки	
	$ChoicePanel.init(Inventorium.get_visible_items())
	$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_item")

func use_item(index):
	# current блеать
	CUR_DECISION = Decision.instance()
	CUR_DECISION.TYPE = 'ITEM'
	CUR_DECISION.DECIDER = TeamStats.heroes[len(DecisionStack.DECISIONS)].to_lower()

	# Шаг 2. Зарезервировать выбранную хилку
	CUR_DECISION.ITEM = Inventorium.reserve_item(index)

	# Шаг 3. Вернуться в общее меню
	return_to_common_menu("use_item")

	# Шаг 4. Составить панель с выбором получателя хилки и дождаться выбора
	$ChoicePanel.init(TeamStats.all_heroes)
	$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_item_on_character")

func use_item_on_character(index):
	CUR_DECISION.VICTIM = TeamStats.all_heroes[index]
	DecisionStack.add_decision(CUR_DECISION)
	return_to_common_menu("use_item_on_character")

# ========================= DEFEND ========================= 

func _on_DefendButton_button_down():
	CUR_DECISION = Decision.instance()

	# тут заменить на cur_character, т.к. не всегда все будут доступны
	CUR_DECISION.DECIDER = TeamStats.heroes[len(DecisionStack.DECISIONS)].to_lower()
	CUR_DECISION.TYPE = 'DEFENSE'
	DecisionReader.emit_signal("defend", CUR_DECISION.DECIDER)
	DecisionStack.add_decision(CUR_DECISION)

# ========================= ACTION ========================= 

func _on_ActButton_button_down():
	CUR_DECISION = Decision.instance()
	CUR_DECISION.TYPE = 'ACT'
	CUR_DECISION.DECIDER = TeamStats.heroes[len(DecisionStack.DECISIONS)]

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
	# должен быть глобальный эммитер, который получает и отправляет сообщения подписчикам - так отвяжем всю-всю логику решений от меню
	emit_signal("menu_ended")


func _on_started_decisions_reading():
	hide()


# X нужно слушать на уровне меню и слать сигнал canceled всем заинтересованным. Каждый слушатель реализует реакцию по-своему (возможна дефолтная реализация)
func _input(ev):
	if Input.is_key_pressed(KEY_X):
		print('_____________EMITED CANCELED_____________')
		emit_signal("canceled")

func _init_signals():
	DecisionReader.connect("start_decisions_reading", self, "_on_started_decisions_reading")
	DecisionReader.connect("end_decisions_reading", self, "_on_ended_decisions_reading")

	connect('canceled', DecisionStack, "pop_decision")
