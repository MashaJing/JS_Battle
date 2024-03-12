extends Node
onready var attack_timer = $AttackTimer

signal finished_talking
signal new_turn

const State = {
	MENU = 'menu',
	ATTACK = 'attack',
	CRINGE_ATTACK = 'cringe_attack',
	GAME_OVER = 'game_over',
}
var state = State.ATTACK
var GAME_OVER_PATH = GlobalAttackSettings.GAME_OVER_PATH
var cur_attack

var attack_ended


# уменьшать связанность (между сценами), повышать связность (осмыслнность) наполнения самих сцен
func _ready():
	_init_signals()
	$CringeTimer.wait_time = GlobalCringeSettings.TIME_BEFORE_JOKE
	add_attack()


# ___________ menu management ___________
func open_menu():
	state = State.MENU
	$Menu.unhide()
	if GlobalAttackSettings.MADE_UP and GlobalAttackSettings.BOTH_ALIVE:
		$CringeTimer.start()


func _on_menu_ended():
	$CringeTimer.stop()
	$Menu.hide()
	var dialog = BattleInfoLogger.show_dialogue()
	if dialog != null:
		add_child(dialog)
		yield(dialog, 'dialogic_signal')
		BattleInfoLogger.clear()
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
	TeamStats.choose_target()
	state = State.ATTACK

	# иначе как-то организовать ретраи
	var cur_attack_path = GlobalAttackSettings.get_next()
	cur_attack = load(cur_attack_path).instance()
	cur_attack.connect("attack_ended", self, "_on_attack_ended")
	add_child(cur_attack)

func remove_attack():
	if cur_attack != null:
		remove_child(cur_attack)

# ___________ cringe management ___________

func add_cringe_attack():
	state = State.CRINGE_ATTACK
	GAME_OVER_PATH = GlobalAttackSettings.CRINGE_GAME_OVER_PATH
	cur_attack = load(GlobalAttackSettings.CRINGE_ATTACK_PATH).instance()
	add_child(cur_attack)
	return cur_attack

func remove_cringe_attack():
	remove_attack()
	state = State.MENU
	GAME_OVER_PATH = GlobalAttackSettings.GAME_OVER_PATH

func _on_CringeTimer_timeout():
	if state == State.MENU:
		$CringeTimer.stop()
		cur_attack = add_cringe_attack()
		yield(cur_attack, "cringe_attack_ended")
		remove_cringe_attack()

# _________________________________________

func _on_game_over():
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
