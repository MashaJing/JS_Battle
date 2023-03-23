extends Node

onready var bullet_scene = preload("res://Attacks/DramaAttacks/DramaAttack1/Knife/Knife.tscn")
onready var heart = $Heart
onready var knife_spawn_location = $KnifePath/KnifeSpawnLocation


# Called when the node enters the scene tree for the first time.
func _ready():
	# timer = 2.2
	for i in range(80):
		knife_spawn_location.unit_offset = 0.0125 * i
		var bullet = bullet_scene.instance()
		bullet.scale *=0.35
		bullet.position = knife_spawn_location.global_position
		bullet.ROTATION_DIRECTION = heart
		add_child(bullet)


func _process(delta):
	pass

