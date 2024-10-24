extends Node2D
@onready var Pipis = preload("res://Bullets/Pipis/Pipis.tscn")
signal card_attack_ended


func _ready():
	$AnimationPlayer.play("move_pan")

func _process(delta):
	if $Sprite2D/PipisSpawn.spawning:
		var pipis = Pipis.instantiate()
		pipis.G = 120
		pipis.speed = 2
		pipis.position = $Sprite2D/PipisSpawn.global_position
		pipis.position.x += randi() % 100 - 100
		add_child(pipis)

func _on_PipisTimer_timeout():
	var micropipis = Pipis.instantiate()
	micropipis.scale /= 3
	micropipis.speed = 1
	micropipis.ttl = 1.0
	micropipis.G = 20
	micropipis.position = $Sprite2D/PipisSpawn.global_position
	micropipis.position.x += randi() % 100 - 100
	micropipis.get_node("ExplosionTimer").wait_time = 0.01
	add_child(micropipis)

func _on_AttackTimer_timeout():
	emit_signal("card_attack_ended")
