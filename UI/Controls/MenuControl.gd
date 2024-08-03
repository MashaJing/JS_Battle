extends Control

var CURRENT_DECISION
var CURRENT_DECIDER
enum MENU_STATE {
	CHARACTER,
	CHOICE_PANEL,
	VICTIM_CHOICE_PANEL,
	CLOSED
}

signal menu_ended
signal exit_choice
signal confirmed 
var State
onready var DescriptionLabel = $VBoxContainer/HBoxContainer2/CommentField/RichTextLabel


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
			State = MENU_STATE.CHOICE_PANEL
			start_item()
		'SPARE':
			start_spare()
		'DEFENSE':
			start_defense()

func open_hero_tab(hero_name):
	State = MENU_STATE.CHARACTER
	$VBoxContainer/HBoxContainer.get_node(hero_name).open()

func close_hero_tab(hero_name):
	$VBoxContainer/HBoxContainer.get_node(hero_name).close()
	
func show_turn_description(text):
	show_letters(text)

# __________________DESCRIPTION STRING___________________________

func show_letters(text, timeout=null):
	DescriptionLabel.visible_characters = 0
	DescriptionLabel.text = text
	$LetterTimer.start()
	for i in range(len(text)):
		yield($LetterTimer, "timeout")
		DescriptionLabel.visible_characters += 1
	$LetterTimer.stop()
	DescriptionLabel.visible = true
	if timeout != null:
		yield(get_tree().create_timer(timeout), "timeout")
		DescriptionLabel.visible = false
		

# ================= SCENARIOS =================

func start_attack():
	State = MENU_STATE.CHOICE_PANEL
	if not $ChoicePanel.get_node("ItemList").is_connected("item_activated", self, "use_attack_on_character"):
		$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_attack_on_character")
		$ChoicePanel.init(ConStats.allies)

func start_action():
	State = MENU_STATE.CHOICE_PANEL
	if not $ChoicePanel.get_node("ItemList").is_connected("item_activated", self, "use_action"):
		$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_action")
		$ChoicePanel.init_actions(ActionsInventorium.AVAILABLE_ACTIONS[CURRENT_DECIDER])

func start_item():
	if State == MENU_STATE.CHOICE_PANEL:
#	if not $ChoicePanel.get_node("ItemList").is_connected("item_activated", self, "use_item"):
		$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_item")
		$ChoicePanel.init(Inventorium.get_visible_items())
		State = MENU_STATE.VICTIM_CHOICE_PANEL

func use_item(index):
	if State == MENU_STATE.VICTIM_CHOICE_PANEL:
		# Шаг 1. Отвязаться от предыдущего меню
		$ChoicePanel.get_node("ItemList").disconnect("item_activated", self, "use_item")
		$ChoicePanel.exit()
	
		# Шаг 2. Забрать выбранную хилку
		CURRENT_DECISION.ITEM = Inventorium.get_item(index)

#		if not $ChoicePanel.get_node("ItemList").is_connected("item_activated", self, "use_item"):
		# Шаг 3. Создать меню персонажей-жертв и ждать
		$ChoicePanel.init(TeamStats.all_heroes)
		$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_item_on_character")


func use_item_on_character(index):
	CURRENT_DECISION.VICTIM = TeamStats.all_heroes[index]
	DecisionStack.add_decision(CURRENT_DECISION)
	return_to_common_menu("use_item_on_character")

func start_spare():
	State = MENU_STATE.CHOICE_PANEL
	if not $ChoicePanel.get_node("ItemList").is_connected("item_activated", self, "use_spare_on_character"):
		$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_spare_on_character")
	$ChoicePanel.init(ConStats.allies)

func start_defense():
	DecisionReader.emit_signal("defend", CURRENT_DECIDER)
	DecisionStack.add_decision(CURRENT_DECISION)
	return_to_common_menu("use_action")


# ===================== HELPERS ========================

# ACTION
func use_action(index):
	CURRENT_DECISION.ACTION = ActionsInventorium.AVAILABLE_ACTIONS[CURRENT_DECIDER][index]
	ActionsController.start_action(CURRENT_DECISION.DECIDER, CURRENT_DECISION.ACTION)
	return_to_common_menu("use_action")

	if State == MENU_STATE.CHOICE_PANEL:
		if CURRENT_DECISION.ACTION.used_on != null:
			$ChoicePanel.get_node("ItemList").connect("item_activated", self, "use_action_on_character")
			connect("exit_choice", $ChoicePanel.get_node("ItemList"), "_on_exit_choice")
			$ChoicePanel.init(CURRENT_DECISION.ACTION.used_on)
		# TODO: если персонажа не выберем, а действие будет его подразумевать, можем словить применение rude buster в пустоту (пример)
		else:
			DecisionStack.add_decision(CURRENT_DECISION)
	else:
		print("Invalid State")
		print(State)

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

func use_spare_on_character(index):
	CURRENT_DECISION.VICTIM = ConStats.allies[index]
	DecisionStack.add_decision(CURRENT_DECISION)
	return_to_common_menu("use_attack_on_character")


# ================== MENU_EVENTS =====================

func start():
	State = MENU_STATE.CHARACTER
	show_turn_description(GlobalDialogueSettings.get_current_description())
	# открываем панельку первого живого героя
	CURRENT_DECIDER = TeamStats.heroes[0]
	open_hero_tab(CURRENT_DECIDER)

func stop():
	print("CURRENT_DECISION.DECIDER")
	print(CURRENT_DECISION.DECIDER)
	
	print("CURRENT_DECIDER")
	print(CURRENT_DECIDER)
	close_hero_tab(CURRENT_DECIDER)
	State = MENU_STATE.CLOSED

func _pass_turn():
	close_hero_tab(CURRENT_DECIDER)
	CURRENT_DECIDER = TeamStats.get_next_hero(CURRENT_DECIDER)

	if CURRENT_DECIDER != null:
		State = MENU_STATE.CHARACTER
		open_hero_tab(CURRENT_DECIDER)
	else:
		State = MENU_STATE.CLOSED
		DecisionReader.start()

# X нужно слушать на уровне меню и слать сигнал canceled всем заинтересованным. Каждый слушатель реализует реакцию по-своему (возможна дефолтная реализация)
func _input(ev):
	if Input.is_key_pressed(KEY_X):
		cancel()
	if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_Z):
		if State == MENU_STATE.CHOICE_PANEL or State == MENU_STATE.CHARACTER:
			emit_signal("confirmed")

# ... cancel what?
func cancel():
	match State:
		MENU_STATE.CHOICE_PANEL:
			emit_signal("exit_choice")
#			emit_signal("canceled") ???
	
		MENU_STATE.CHARACTER:
			if CURRENT_DECIDER != null:
				var previous_player = TeamStats.get_previous_hero(CURRENT_DECIDER)
				
				if previous_player != null:
					close_hero_tab(CURRENT_DECIDER)
					CURRENT_DECIDER = previous_player
					open_hero_tab(CURRENT_DECIDER)
					cancel_decision()

func cancel_decision():
	CURRENT_DECISION = DecisionStack.pop_decision()
	match CURRENT_DECISION.TYPE:
		'ATK':
			cancel_attack()
		'ACT':
			cancel_action()
		'ITEM':
			cancel_item()
		'SPARE':
			cancel_spare()
		'DEFENSE':
			cancel_defense()


func cancel_attack():
	AttackController.cancel_attack(CURRENT_DECIDER)

func cancel_action():
	ActionsController.cancel_action(CURRENT_DECIDER, CURRENT_DECISION.ACTION)

func cancel_defense():
	ActionsController.emit_signal("canceled", CURRENT_DECIDER)
	
func cancel_item():
	Inventorium.add_item(CURRENT_DECISION.ITEM)

func cancel_spare():
	SpareController.cancel_spare(CURRENT_DECIDER)

func _on_ended_decisions_reading():
	# Отображаем плашку с результатами нашего хода: "Крис применил трефдвич!"
	var text = BattleInfoLogger.get_lines()
	if len(text) > 0:
		yield(show_letters(text, 1.0), "completed")
		BattleInfoLogger.clear()
	
	var fighters = AttackController.attacks.keys()
	if len(fighters) > 0:
		$VBoxContainer/HBoxContainer2/CommentField/AttackPanel.start_attacks(fighters)
		yield($VBoxContainer/HBoxContainer2/CommentField/AttackPanel, "finished")
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
		disconnect("exit_choice", $ChoicePanel.get_node("ItemList"), "_on_exit_choice")
	State = MENU_STATE.CHARACTER
	_pass_turn()


func _init_signals():
	var node_path
	for hero in TeamStats.all_heroes:
		node_path = "VBoxContainer/HBoxContainer/" + hero
		get_node(node_path).connect("decided", self, "_on_decided")
		get_node(node_path + "/Buttons").connect("play_changed", $ChangedSoundPlayer, "play")
		get_node(node_path + "/Buttons").connect("play_pressed", $PressedStreamPlayer, "play")

	DecisionReader.connect("end_decisions_reading", self, "_on_ended_decisions_reading")
	
	connect("exit_choice", $ChoicePanel, "_on_exit_choice")
	$ChoicePanel.connect("play_changed", $ChangedSoundPlayer, "play")
	$ChoicePanel.connect("play_pressed", $PressedStreamPlayer, "play")
