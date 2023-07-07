extends Node

var target = ["Jevil"]
onready var bullet_scene = preload("res://Attacks/DramaAttacks/HandKnivesAttack/Knife/Knife.tscn")
onready var heart = $KinematicHeart
onready var knife_spawn_location = $KnifePath/KnifeSpawnLocation
onready var Border = preload('res://Border/Border.tscn')

signal attack_ended
var N_KNIVES = 80


func init_border():
	var border = Border.instance()
	border.global_position = $KinematicHeart.global_position
	add_child(border)	

func _ready():
	$KinematicHeart/Heart.connect("health_changed", self, "_on_Heart_health_changed")
	init_border()
	for i in range(N_KNIVES):
		knife_spawn_location.unit_offset = i * 1.0/N_KNIVES
		var bullet = bullet_scene.instance()
		bullet.scale *=0.35
		bullet.position = knife_spawn_location.global_position
		bullet.ROTATION_DIRECTION = heart
		add_child(bullet)
	yield(get_tree().create_timer(8.0), "timeout")
	emit_signal("attack_ended")


func _on_Heart_health_changed():
	emit_signal("attack_ended")
