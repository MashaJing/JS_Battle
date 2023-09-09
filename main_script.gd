extends Node
onready var attack_timer = $AttackTimer

const State = {
	MENU = 'menu',
	ATTACK = 'attack',
	CRINGE_ATTACK = 'cringe_attack',
	GAME_OVER = 'game_over',
}
var state = State.ATTACK
var GAME_OVER_PATH = GlobalAttackSettings.GAME_OVER_SCENE_PATH
signal finished_talking
var cur_attack


func _ready():
	TeamStats.heroes = [$Kris] #, $Susie, $Ralsei
	TeamStats.choose_target()
	$Menu.connect("attack_began", self, "_on_attack_began")
	TeamStats.connect("game_over", self, "_on_game_over")
	add_attack()

# ___________ menu management ___________

func close_menu():
	$Menu.hide()
	$CringeTimer.stop()

func open_menu():
	$Menu.unhide()
	if GlobalAttackSettings.CRINGE_ATTACKS_ON:
		$CringeTimer.start()

# ___________ attack management ___________

# сигнал поступает от атаки
func _on_attack_ended():
	remove_attack()
	open_menu()

# сигнал поступает от интерфейса
func _on_attack_began():
	close_menu()
	TeamStats.choose_target()
	add_attack()

func add_attack():
	var cur_attack_path = GlobalAttackSettings.get_next()
	cur_attack = load(cur_attack_path).instance()
	cur_attack.connect("attack_ended", self, "_on_attack_ended")
	add_child(cur_attack)
	
func remove_attack():
	if cur_attack != null:
		remove_child(cur_attack)

# ___________ cringe management ___________

func add_cringe_attack():
	GAME_OVER_PATH = GlobalAttackSettings.CRINGE_GAME_OVER_SCENE_PATH
	cur_attack = load(GlobalAttackSettings.CRINGE_ATTACK_PATH).instance()
	add_child(cur_attack)
	return cur_attack

func remove_cringe_attack():
	remove_attack()
	GAME_OVER_PATH = GlobalAttackSettings.GAME_OVER_SCENE_PATH

func _on_CringeTimer_timeout():
	$CringeTimer.stop()
	cur_attack = add_cringe_attack()
	yield(cur_attack, "cringe_attack_ended")
	remove_cringe_attack()

# _________________________________________

func _on_game_over():
	# остановить всё
	# послать сигнал game_over?
	get_tree().change_scene(GAME_OVER_PATH)
