extends Node
onready var attack_timer = $AttackTimer

signal finished_talking
signal new_turn
var Angel = preload("res://Characters/SpamtonAngel/SpamtonAngel.tscn")

const State = {
	MENU = 'menu',
	ATTACK = 'attack',
	DIALOGUE = 'dialogue',  # needed?
	CRINGE_ATTACK = 'cringe_attack',
	GAME_OVER = 'game_over',
}
var state = State.ATTACK
var cur_attack

var attack_ended


func set_global_state(_state):
	state = _state

# уменьшать связанность (между сценами), повышать связность (осмыслнность) наполнения самих сцен
func _ready():
	# FIXME: походу не вызывается ready вторым запуском игры
	if not GlobalPlotSettings.FIRST_LAUNCH:
		reset_previous_game_params()
	_init_signals()
	_init_variables()
	GlobalAttackSettings.init()
	add_attack()

# ___________ menu management ___________
func open_menu():
	set_global_state(State.MENU)
	$Menu.start()


func _on_menu_ended():
	print("_on_menu_ended()")
	set_global_state(State.DIALOGUE)
#
#	# Отображаем плашку с результатами нашего хода: "Крис применил трефдвич!"
#	var dialog = BattleInfoLogger.show_dialogue()
#	if dialog != null:
#		add_child(dialog)
#		yield(dialog, 'dialogic_signal')
#		BattleInfoLogger.clear()
#
#	# После этого переходим к атаке
	add_attack()
	
# ___________ attack management ___________

# сигнал поступает от атаки
func _on_attack_ended():
	if state in [State.ATTACK, State.CRINGE_ATTACK]:
		# не должен слаться тут
		emit_signal("new_turn")
		remove_attack()
		open_menu()
		if GlobalPlotSettings.CRINGE_ATTACKS_ON:
			$CringeTimer.start()
	else:
		print('ATTENTION: INVALID STATE!')
		print(state)
		print('=========================')
		print('_on_attack_ended')


func add_attack():
	set_global_state(State.ATTACK)

	if GlobalPlotSettings.MADE_UP:
		# озвучиваем реплику противников непосредственно перед атакой
		var pre_attack_line = Dialogic.start("pre_attack")
		add_child(pre_attack_line)
		yield(pre_attack_line, "dialogic_signal")


	# TODO: иначе как-то организовать ретраи
	var cur_attack_path = GlobalAttackSettings.get_next_attack()
	cur_attack = load(cur_attack_path).instance()
	cur_attack.connect("attack_ended", self, "_on_attack_ended")
	TeamStats.choose_target(cur_attack.get("targets"))
	add_child(cur_attack)


func remove_attack():
	if cur_attack != null:
		remove_child(cur_attack)

# ___________ cringe management ___________

func add_cringe_attack():
	set_global_state(State.CRINGE_ATTACK)

	cur_attack = load(GlobalPlotSettings.CRINGE_ATTACK_PATH).instance()
	add_child(cur_attack)
	return cur_attack


func remove_cringe_attack():
	remove_attack()
	set_global_state(State.MENU)


func _on_CringeTimer_timeout():
	# через рандомный промежуток времени Джевил начинает травить шутку (1 раз в ход)
	if state == State.MENU:
		$Menu.stop()
		cur_attack = add_cringe_attack()
		yield(cur_attack, "cringe_attack_ended")
		remove_cringe_attack()
		open_menu()

# _________________________________________

func _on_game_over():
	var game_over_path = GlobalPlotSettings.get_game_over(state)
	set_global_state(State.GAME_OVER)
	
	# остановить всё
	# послать сигнал game_over?

	get_tree().change_scene(game_over_path)


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

func reset_previous_game_params():
	GlobalAttackSettings.reset()
	GlobalDialogueSettings.reset()
	TeamStats.reset()
	GlobalCringeSettings.reset()

# specil event
func _input(ev):
	if Input.is_key_pressed(KEY_F1) and state in [State.MENU, State.DIALOGUE]:
		print('_____________KEY_F1_____________')

		if not GlobalPlotSettings.SUMMONED_ANGEL:
			GlobalPlotSettings.SUMMONED_ANGEL = true

			for hero in TeamStats.all_heroes:
				var hero_node = get_node(hero)
				spawn_angel_and_heal(hero_node)


func spawn_angel_and_heal(hero_node):
	var hero_position = hero_node.position

	# создаём уникальный animationPlayer, чтобы ангел долетел до указанного персонажа
	var angel_animation_player = AnimationPlayer.new()
	add_child(angel_animation_player)

	var position_1 = $AngelSpawn.position
	var position_2 = hero_position

	var angel = Angel.instance()
	angel.position = position_1
	add_child(angel)
	
	var angel_path: NodePath = get_path_to(angel)
	var sprite_frame_path: NodePath = "%s:position" % angel_path
		
	var anim_length: float = 0.7

	var anim := Animation.new()
	anim.length = anim_length
	anim.loop = false

	# трек, чтобы ангел долетел до указанного персонажа
	var frame_track_id: int = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(frame_track_id, sprite_frame_path)

	anim.track_insert_key(frame_track_id, 0, position_1)
	anim.track_insert_key(frame_track_id, anim_length, position_2)

	# трек, чтобы дёрнуть метод ангела, воспроизводяющий анимацию и уничтожающий объект
	var method_track_id: int = anim.add_track(Animation.TYPE_METHOD)
	anim.track_set_path(method_track_id, angel_path)
	anim.track_insert_key(method_track_id, anim_length, {"method" : "pet_head", "args" : []})
#
	angel_animation_player.add_animation("angel_flies", anim)
	angel_animation_player.play("angel_flies")

	# Хиляем, дождавшись воспроизведения мультика с ангелом
	yield(angel, "tree_exiting")

	var new_hp = int(hero_node.get_node("PlayerStats").MAX_HP/2)
	hero_node.get_node("PlayerStats").heal(new_hp)
