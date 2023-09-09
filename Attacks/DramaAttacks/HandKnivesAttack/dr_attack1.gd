extends Node

signal sub_attack_ended

var target = ["Jevil"]
onready var bullet_scene = preload("res://Attacks/DramaAttacks/HandKnivesAttack/Knife/Knife.tscn")
onready var heart = $KinematicHeart
onready var knife_spawn_location = $KnifePath/KnifeSpawnLocation
onready var Border = preload('res://Border/Border.tscn')

var N_KNIVES = 80


func _ready():
	$KinematicHeart/Heart.connect("health_changed", self, "_on_Heart_health_changed")
	for i in range(N_KNIVES):
		knife_spawn_location.unit_offset = i * 1.0/N_KNIVES
		var bullet = bullet_scene.instance()
		bullet.scale *=0.35
		bullet.position = knife_spawn_location.global_position
		bullet.ROTATION_DIRECTION = heart
		add_child(bullet)
	yield(get_tree().create_timer(11.0), "timeout")
	emit_signal("sub_attack_ended")


func _on_Heart_health_changed():
	emit_signal("sub_attack_ended")
