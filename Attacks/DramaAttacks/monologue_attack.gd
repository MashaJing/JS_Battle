extends Node2D

onready var Jevil = get_parent().get_node("Jevil")
onready var Spamton = get_parent().get_node("Spamton")
onready var MusTheme = get_parent().get_node("Theme")

onready var ATTACK_TEMPLATE = "res://Attacks/DramaAttacks/{attack_name}/{attack_name}.tscn"

signal attack_ended


func _ready():
#	var dialog = Dialogic.start("spamton_monologue")
#	add_child(dialog)
#	yield(dialog, "dialogic_signal")
	MusTheme.stop()
#
	var dialog = Dialogic.start("confession")
	add_child(dialog)
	yield(dialog, "dialogic_signal")
	emit_signal("attack_ended")


func begin_attack(attack_name):
	var Attack = (load(ATTACK_TEMPLATE.format({'attack_name': attack_name}))).instance()
#	print('Attack.target is ', Attack.target)
#	TeamStats.choose_target(Attack.target)

	call_deferred("add_child", Attack)
	yield(Attack, "attack_ended")
	call_deferred("remove_child", Attack)
	
	
func speed_up_music():
	MusTheme.pitch_scale += 0.08

func stop_music():
	for _i in range(7):
		MusTheme.pitch_scale -= 0.15
		yield(get_tree().create_timer(0.15), "timeout")
	MusTheme.stop()
	MusTheme.pitch_scale = 1
