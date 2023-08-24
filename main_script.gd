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

func close_menu():
	$Menu.hide()	

func open_menu():
	$Menu.unhide()

func _on_game_over():
	# остановить всё
	# послать сигнал game_over?
	print('GOT game over signal!')
	get_tree().change_scene(GAME_OVER_PATH)

# сигнал поступает от атаки
func _on_attack_ended():
	remove_attack()
	open_menu()

# сигнал поступает от интерфейса
func _on_attack_began():
	close_menu()
	TeamStats.choose_target()
	add_attack()


func remove_attack():
	if cur_attack != null:
		remove_child(cur_attack)


func add_cringe_attack():
	GAME_OVER_PATH = GlobalAttackSettings.CRINGE_GAME_OVER_SCENE_PATH
	var cur_attack_path = GlobalAttackSettings.CRINGE_ATTACK_PATH
	cur_attack = load(cur_attack_path).instance()
	add_child(cur_attack)


func add_attack():
	# не стоит передавать это каждый раз
	GAME_OVER_PATH = GlobalAttackSettings.GAME_OVER_SCENE_PATH
	var cur_attack_path = GlobalAttackSettings.get_next()
	cur_attack = load(cur_attack_path).instance()
	cur_attack.connect("attack_ended", self, "_on_attack_ended")
	add_child(cur_attack)


# не должно быть тут
func play_dialogue(dialogue, dialogue_n=0):
	for replica in dialogue[dialogue_n]:
		var speaker = get_node(replica['speaker'])
		speaker.speak(replica['text'])
		if 'animation' in replica.keys():
			speaker.get_node("AnimationPlayer").play(replica['animation'])
		yield(speaker, "stopped_talk")
	emit_signal("finished_talking")
