extends Node2D

onready var MusTheme = get_parent().get_node("Theme")
onready var ATTACK_TEMPLATE = "res://Attacks/DramaAttacks/{attack_name}/{attack_name}.tscn"
signal attack_ended


func _ready():
#	var dialog = Dialogic.start("spamton_monologue")
#	add_child(dialog)
#	yield(dialog, "dialogic_signal")
#	MusTheme.stop()
	GlobalAttackSettings.MADE_UP = true
	begin_confession()


func begin_confession():
	var dialog = Dialogic.start("test1")
	add_child(dialog)
	yield(dialog, "dialogic_signal")
	MusTheme.set_soundtrack('the_deals_revolving.mp3')
	print('started soundtrack!!!')
	emit_signal("attack_ended")


func begin_attack(attack_name):
	var Attack = (load(ATTACK_TEMPLATE.format({'attack_name': attack_name}))).instance()
#	print('Attack.target is ', Attack.target)
#	TeamStats.choose_target(Attack.target)

	call_deferred("add_child", Attack)
	yield(Attack, "sub_attack_ended")
	call_deferred("remove_child", Attack)
	
	
func speed_up_music():
	MusTheme.pitch_scale += 0.08

func stop_music():
	for _i in range(7):
		MusTheme.pitch_scale -= 0.15
		yield(get_tree().create_timer(0.15), "timeout")
	MusTheme.stop()
	MusTheme.pitch_scale = 1
