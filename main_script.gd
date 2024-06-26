extends Node
onready var attack_timer = $AttackTimer

signal finished_talking
signal new_turn

const State = {
	MENU = 'menu',
	ATTACK = 'attack',
	DIALOGUE = 'dialogue',  # needed?
	CRINGE_ATTACK = 'cringe_attack',
	GAME_OVER = 'game_over',
}
var state = State.ATTACK
var GAME_OVER_PATH = GlobalAttackSettings.GAME_OVER_PATH
var cur_attack

var attack_ended


func set_global_state(_state):
	state = _state

# уменьшать связанность (между сценами), повышать связность (осмыслнность) наполнения самих сцен
func _ready():
	_init_signals()
	_init_variables()
	add_attack()

# ___________ menu management ___________
func open_menu():
	set_global_state(State.MENU)
	$Menu.start()
	if GlobalAttackSettings.CRINGE_ATTACKS_ON:
		$CringeTimer.start()


func _on_menu_ended():
	print("_on_menu_ended()")
	set_global_state(State.DIALOGUE)

	# Отображаем плашку с результатами нашего хода: "Крис применил трефдвич!"
	var dialog = BattleInfoLogger.show_dialogue()
	if dialog != null:
		add_child(dialog)
		yield(dialog, 'dialogic_signal')
		BattleInfoLogger.clear()
	
	# После этого переходим к атаке
	add_attack()
	
# ___________ attack management ___________

# сигнал поступает от атаки
func _on_attack_ended():
	if state in [State.ATTACK, State.CRINGE_ATTACK]:
		# не должен слаться тут
		emit_signal("new_turn")
		remove_attack()
		open_menu()
	else:
		print('ATTENTION: INVALID STATE!')
		print(state)
		print('=========================')
		print('_on_attack_ended')


func add_attack():
	set_global_state(State.ATTACK)

	# озвучиваем реплику противников непосредственно перед атакой
	var pre_attack_line = Dialogic.start("pre_attack")
	add_child(pre_attack_line)
	yield(pre_attack_line, "dialogic_signal")

	TeamStats.choose_target()

	# TODO: иначе как-то организовать ретраи
	var cur_attack_path = GlobalAttackSettings.get_next_attack()
	cur_attack = load(cur_attack_path).instance()
	cur_attack.connect("attack_ended", self, "_on_attack_ended")
	add_child(cur_attack)


func remove_attack():
	if cur_attack != null:
		remove_child(cur_attack)

# ___________ cringe management ___________

func add_cringe_attack():
	set_global_state(State.CRINGE_ATTACK)

	GAME_OVER_PATH = GlobalAttackSettings.CRINGE_GAME_OVER_PATH
	cur_attack = load(GlobalAttackSettings.CRINGE_ATTACK_PATH).instance()
	add_child(cur_attack)
	return cur_attack

func remove_cringe_attack():
	remove_attack()
	set_global_state(State.MENU)
	GAME_OVER_PATH = GlobalAttackSettings.GAME_OVER_PATH


func _on_CringeTimer_timeout():
	# через рандомный промежуток времени Джевил начинает травить шутку (1 раз в ход)
	if state == State.MENU:
		cur_attack = add_cringe_attack()
		yield(cur_attack, "cringe_attack_ended")
		remove_cringe_attack()

# _________________________________________

func _on_game_over():
	set_global_state(State.GAME_OVER)
	# остановить всё
	# послать сигнал game_over?
	get_tree().change_scene(GAME_OVER_PATH)


func _init_signals():
	$Menu.connect("menu_ended", self, "_on_menu_ended")
	TeamStats.connect("game_over", self, "_on_game_over")

	connect("new_turn", GlobalDialogueSettings, "_on_new_turn")
	connect("new_turn", $Kris.get_node("AnimatedSpriteController"), "_on_new_turn")
	connect("new_turn", $Susie.get_node("AnimatedSpriteController"), "_on_new_turn")
	connect("new_turn", $Ralsei.get_node("AnimatedSpriteController"), "_on_new_turn")


func _init_variables():
	TeamStats.individual_stats = {
		"Kris": get_node("Kris").get_node("PlayerStats"),
		"Susie": get_node("Susie").get_node("PlayerStats"),
		"Ralsei": get_node("Ralsei").get_node("PlayerStats")
	}
	$Menu.init_characters()
	
	ConStats.individual_stats = {
		"Jevil": get_node("Jevil").get_node("PlayerStats"),
		"Spamton": get_node("Spamton").get_node("PlayerStats"),
	}

	$CringeTimer.wait_time = GlobalCringeSettings.TIME_BEFORE_JOKE
