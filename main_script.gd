extends Node
onready var attack_timer = $AttackTimer
var music_folder = "res://Assets/music/%s"

const State = {
	MENU = 'menu',
	ATTACK = 'attack',
	CRINGE_ATTACK = 'cringe_attack',
	GAME_OVER = 'game_over',
}
var state = State.ATTACK
onready var attacks = [
#	preload("res://Attacks/Phase1/Attack3/Attack3.tscn").instance(),	
#	preload("res://Attacks/Phase1/Attack1/Attack1.tscn").instance(),
#	preload("res://Attacks/Phase1/Attack1/Attack1.tscn").instance(),
	#preload("res://Attacks/Phase1/Attack2/Attack2.tscn").instance(),
	#preload("res://Attacks/DullAttacks/DullSpamton/DullSpamton.tscn").instance(),
#	preload("res://Attacks/DramaAttacks/MonologueAttack.tscn").instance(),
	preload("res://Cutscenes/ConfessionAttack/ConfessionAttack.tscn").instance(),
	#preload("res://Attacks/Phase2/FerrisWheelAttack/FerrisWheelAttack.tscn").instance(),
]
var cur_attack = 0
signal finished_talking


func _ready():
	# вынести в отдельный метод типа init? 
	open_menu_after_attack()
	$Theme.play()
#	print('main loaded!')
	add_child(attacks[cur_attack])
	attacks[cur_attack].connect("attack_ended", self, "_on_attack_ended")
	connect_heart(cur_attack)
	#attack_timer.start()
	$TeamStats.choose_target()


# мб в методах перехода и ловить сигналы? либо вызывать их в методах-обработчиках
# сигналов для большей гибкости (чтобы не было прямой связи "сигнал - переход")
# menu -> attack
func begin_attack_after_menu():
	print('__________attack begins__________')
	# предусмотреть кринж-атаки
	$Menu.hide()
	add_child(attacks[cur_attack])
	connect_heart(cur_attack)
	attacks[cur_attack].connect("attack_ended", self, "_on_attack_ended")
	$TeamStats.choose_target()

# attack -> menu
func open_menu_after_attack():
	# _on_attack_ended
	# открыть меню
	$Menu.unhide()

# attack -> game_over
func play_game_over():
	# остановить всё
	# послать сигнал game_over?
	# Экран GAME OVER
	pass

func _on_attack_ended():
	call_deferred("remove_child", attacks[cur_attack])
	open_menu_after_attack()

func _on_Menu_attck_begins():
	begin_attack_after_menu()


func connect_heart(cur_attack):
	var team_stats = $TeamStats
	var current_heart = attacks[cur_attack].get_node_or_null("KinematicHeart")
	if current_heart != null:
			current_heart.get_node("Heart").connect("health_changed", team_stats, "_on_take_damage")
			current_heart.get_node("Heart").connect("tp_increased", team_stats, "_on_tp_increased")
			current_heart.get_node("Heart").connect("tp_decreased", team_stats, "_on_tp_decreased")


func play_dialogue(dialogue, dialogue_n=0):
	for replica in dialogue[dialogue_n]:
		var speaker = $TeamStats.get_node(replica['speaker'])
		speaker.speak(replica['text'])
		if 'animation' in replica.keys():
			speaker.get_node("AnimationPlayer").play(replica['animation'])
		yield(speaker, "stopped_talk")
	emit_signal("finished_talking")


func _on_soundtrack_required(theme):
	var new_audio = open_audio(theme)
	if new_audio != null:
		if $Theme.playing:
			$Theme.stop()
		$Theme.stream = new_audio
		$Theme.play()


func open_audio(theme):
	var audio_file = music_folder % theme
	if File.new().file_exists(audio_file):
		print('found file!')
		var sfx = load(audio_file)
		sfx.set_loop(false)
		return sfx
