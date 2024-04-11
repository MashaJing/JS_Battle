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

var CURRENT_DECISION


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
	CURRENT_DECISION = Decision.instance()
	CURRENT_DECISION.TYPE = 'ATTACK'
	CURRENT_DECISION.VICTIM = ally_name
	DecisionStack.add_decision(CURRENT_DECISION)

# ========================= ITEM ========================= 

func _on_ItemButton_button_down():
	# Шаг 1. Составить панель с выбором айтемов и дождаться выбора доступной хилки	
	$ChoicePanel.init(Inventorium.get_visible_items())
	$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_item")

func use_item(index):
	# current блеать
	CURRENT_DECISION = Decision.instance()
	CURRENT_DECISION.TYPE = 'ITEM'
	CURRENT_DECISION.DECIDER = TeamStats.heroes[len(DecisionStack.DECISIONS)]

	# Шаг 2. Зарезервировать выбранную хилку
	CURRENT_DECISION.ITEM = Inventorium.reserve_item(index)

	# Шаг 3. Вернуться в общее меню
	return_to_common_menu("use_item")

	# Шаг 4. Составить панель с выбором получателя хилки и дождаться выбора
	$ChoicePanel.init(TeamStats.all_heroes)
	$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_item_on_character")

func use_item_on_character(index):
	CURRENT_DECISION.VICTIM = TeamStats.all_heroes[index]
	DecisionStack.add_decision(CURRENT_DECISION)
	return_to_common_menu("use_item_on_character")

# ========================= DEFEND ========================= 

func _on_DefendButton_button_down():
	CURRENT_DECISION = Decision.instance()

	# тут заменить на cur_character, т.к. не всегда все будут доступны
	CURRENT_DECISION.DECIDER = TeamStats.heroes[len(DecisionStack.DECISIONS)]
	CURRENT_DECISION.TYPE = 'DEFENSE'
	DecisionReader.emit_signal("defend", CURRENT_DECISION.DECIDER)
	DecisionStack.add_decision(CURRENT_DECISION)

# ========================= ACTION ========================= 

func _on_ActButton_button_down():
	CURRENT_DECISION = Decision.instance()
	CURRENT_DECISION.TYPE = 'ACT'
	CURRENT_DECISION.DECIDER = TeamStats.heroes[len(DecisionStack.DECISIONS)]

	$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_action")
	$ChoicePanel.init_actions(ActionsInventorium.AVAILABLE_ACTIONS[CURRENT_DECISION.DECIDER])


func use_action(index):
	CURRENT_DECISION.ACTION = ActionsInventorium.AVAILABLE_ACTIONS[CURRENT_DECISION.DECIDER][index]
	ActionsController.start_action(CURRENT_DECISION.DECIDER, CURRENT_DECISION.ACTION)
	return_to_common_menu("use_action")

	if CURRENT_DECISION.ACTION.used_on != null:
		$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_action_on_character")
		$ChoicePanel.init(CURRENT_DECISION.ACTION.used_on)
	else:
		DecisionStack.add_decision(CURRENT_DECISION)

func use_action_on_character(index):
	CURRENT_DECISION.VICTIM = CURRENT_DECISION.ACTION.used_on[index]
	return_to_common_menu("use_action_on_character")
	DecisionStack.add_decision(CURRENT_DECISION)

# ========================= SPARE ========================= 

func _on_SpareButton_button_down():
	CURRENT_DECISION = Decision.instance()
	CURRENT_DECISION.TYPE = 'SPARE'
	CURRENT_DECISION.DECIDER = TeamStats.heroes[len(DecisionStack.DECISIONS)]

	$ChoicePanel.init(ConStats.allies)
	$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_spare_on_character")

func use_spare_on_character(index):
	CURRENT_DECISION.VICTIM = ConStats.allies[index]
	DecisionStack.add_decision(CURRENT_DECISION)
	return_to_common_menu("use_spare_on_character")

func return_to_common_menu(processing_method):
	$ChoicePanel.exit()
	if $ChoicePanel.get_node("ItemList").is_connected("item_activated", self, processing_method):
		$ChoicePanel.get_node("ItemList").disconnect("item_activated", self, processing_method)
	$DebugButtons/KillJevilButton.grab_focus()

# ========================= ATTACK ========================= 

func _on_AttackButton_button_down():
	CURRENT_DECISION = Decision.instance()
	CURRENT_DECISION.TYPE = 'ATK'
	CURRENT_DECISION.DECIDER = TeamStats.heroes[len(DecisionStack.DECISIONS)]

	$ChoicePanel.init(ConStats.allies)
	$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_attack_on_character")

func use_attack_on_character(index):
	CURRENT_DECISION.VICTIM = ConStats.allies[index]
	AttackController.start_attack(CURRENT_DECISION.DECIDER, CURRENT_DECISION.VICTIM)
	DecisionStack.add_decision(CURRENT_DECISION)
	return_to_common_menu("use_attack_on_character")
# ========================================================== 

func _on_ended_decisions_reading():
	var fighters = AttackController.attacks.keys()
	if len(fighters) > 0:
		$AttackPanel.start_attacks(fighters)
		yield($AttackPanel, "finished")
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
