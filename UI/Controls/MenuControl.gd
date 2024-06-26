extends Control

var CURRENT_DECISION
enum MENU_STATE {
	CHARACTER,
	CHOICE_PANEL,
	CLOSED
}

signal menu_ended
signal canceled()
var State


func _ready():
	_init_signals()


func _on_decided(decision):
	CURRENT_DECISION = decision
	match decision.TYPE:
		'ATK':
			start_attack()
		'ACT':
			start_action()
		'ITEM':
			start_item()
		'SPARE':
			start_spare()
		'DEFENSE':
			start_defense()

# ================= SCENARIOS =================

func start_attack():
	if not $ChoicePanel.get_node("ItemList").is_connected("item_activated", self, "use_attack_on_character"):
		$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_attack_on_character")
		$ChoicePanel.init(ConStats.allies)

func start_action():
	if not $ChoicePanel.get_node("ItemList").is_connected("item_activated", self, "use_action"):
		$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_action")
		$ChoicePanel.init_actions(ActionsInventorium.AVAILABLE_ACTIONS[CURRENT_DECISION.DECIDER])

func start_item():
	pass

func start_spare():
	pass

func start_defense():
	# тут заменить на cur_character, т.к. не всегда все будут доступны
	DecisionReader.emit_signal("defend", CURRENT_DECISION.DECIDER)
	DecisionStack.add_decision(CURRENT_DECISION)
	
	return_to_common_menu("use_action")


# ===================== HELPERS ========================

# ACTION

func use_action(index):
	CURRENT_DECISION.ACTION = ActionsInventorium.AVAILABLE_ACTIONS[CURRENT_DECISION.DECIDER][index]
	ActionsController.start_action(CURRENT_DECISION.DECIDER, CURRENT_DECISION.ACTION)
	return_to_common_menu("use_action")

	if CURRENT_DECISION.ACTION.used_on != null:
		$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_action_on_character")
		connect("cancel", $ChoicePanel.get_node("ItemList"), "_on_canceled")
		$ChoicePanel.init(CURRENT_DECISION.ACTION.used_on)
	# TODO: если персонажа не выберем, а действие будет его подразумевать, можем словить применение rude buster в пустоту (пример)
	else:
		DecisionStack.add_decision(CURRENT_DECISION)

func cancel_action():
	DecisionStack.DECISIONS
	ActionsController.cancel_action(CURRENT_DECISION.DECIDER, CURRENT_DECISION.ACTION)
	return_to_common_menu("use_action")

	if CURRENT_DECISION.ACTION.used_on != null:
		$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_action_on_character")
		$ChoicePanel.init(CURRENT_DECISION.ACTION.used_on)
# TODO: если персонажа не выберем, а действие будет его подразумевать, можем словить применение rude buster в пустоту (пример)
	else:
		DecisionStack.add_decision(CURRENT_DECISION)

func use_action_on_character(index):
	CURRENT_DECISION.VICTIM = CURRENT_DECISION.ACTION.used_on[index]
	return_to_common_menu("use_action_on_character")
	DecisionStack.add_decision(CURRENT_DECISION)

# ATTACK

func use_attack_on_character(index):
	CURRENT_DECISION.VICTIM = ConStats.allies[index]
	AttackController.start_attack(CURRENT_DECISION.DECIDER, CURRENT_DECISION.VICTIM)
	DecisionStack.add_decision(CURRENT_DECISION)
	return_to_common_menu("use_attack_on_character")

# ================== MENU_EVENTS =====================

func start():
	$VBoxContainer/HBoxContainer2/CommentField/RichTextLabel.text = GlobalDialogueSettings.get_current_description()
	# открываем панельку первого живого героя
	$VBoxContainer/HBoxContainer.get_node(TeamStats.heroes[0]).open()


func _pass_turn():
	$VBoxContainer/HBoxContainer.get_node(CURRENT_DECISION.DECIDER).close()
	var next_player = TeamStats.get_next_hero(CURRENT_DECISION.DECIDER)

	if next_player != null:
		$VBoxContainer/HBoxContainer.get_node(next_player).open()
	else:
		DecisionReader.start()


# X нужно слушать на уровне меню и слать сигнал canceled всем заинтересованным. Каждый слушатель реализует реакцию по-своему (возможна дефолтная реализация)
func _input(ev):
	if Input.is_key_pressed(KEY_X):
		if State == MENU_STATE.CHOICE_PANEL:
			emit_signal("canceled")
	if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_Z):
		if State == MENU_STATE.CHOICE_PANEL or State == MENU_STATE.CHARACTER:
			emit_signal("confirmed")


func _on_canceled():
	var previous_player = TeamStats.get_previous_hero(CURRENT_DECISION.DECIDER)
	if previous_player != null:
		DecisionStack.pop_decision()
		$VBoxContainer/HBoxContainer.get_node(CURRENT_DECISION.DECIDER).close()
		$VBoxContainer/HBoxContainer.get_node(previous_player).open()


func _on_ended_decisions_reading():
	var fighters = AttackController.attacks.keys()
	if len(fighters) > 0:
		$VBoxContainer/HBoxContainer2/CommentField/AttackPanel.start_attacks(fighters)
		yield($VBoxContainer/HBoxContainer2/CommentField/AttackPanel, "finished")
	print('..................................................................')
	print('ended decisions reading')
	print('..................................................................')
	# выход из меню
	emit_signal("menu_ended")


func init_characters():
	var node_path
	for hero in TeamStats.all_heroes:
		node_path = "VBoxContainer/HBoxContainer/" + hero + "/VBoxContainer/CharacterArea"
		get_node(node_path).set_character_stats(TeamStats.individual_stats[hero])

func return_to_common_menu(processing_method):
	$ChoicePanel.exit()
	if $ChoicePanel.get_node("ItemList").is_connected("item_activated", self, processing_method):
		$ChoicePanel.get_node("ItemList").disconnect("item_activated", self, processing_method)
		disconnect("cancel", $ChoicePanel.get_node("ItemList"), "_on_canceled")
	_pass_turn()


func _init_signals():
	var node_path
	for hero in TeamStats.all_heroes:
		node_path = "VBoxContainer/HBoxContainer/" + hero
		get_node(node_path).connect("decided", self, "_on_decided")
		get_node(node_path + "/Buttons").connect("play_changed", $ChangedSoundPlayer, "play")
		get_node(node_path + "/Buttons").connect("play_pressed", $PressedStreamPlayer, "play")

	DecisionReader.connect("end_decisions_reading", self, "_on_ended_decisions_reading")
	
	connect("canceled", $ChoicePanel, "_on_canceled")
	$ChoicePanel.connect("play_changed", $ChangedSoundPlayer, "play")
	$ChoicePanel.connect("play_pressed", $PressedStreamPlayer, "play")
