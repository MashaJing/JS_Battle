extends Node2D
onready var Pipis = preload("res://Bullets/Pipis/Pipis.tscn")


func _ready():
	$AnimationPlayer.play("move_pan")

func _process(delta):
	if $Sprite/PipisSpawn.spawning:
		var pipis = Pipis.instance()
		pipis.G = 120
		pipis.speed = 2
		pipis.position = $Sprite/PipisSpawn.global_position
		pipis.position.x += randi() % 100 - 100
		add_child(pipis)

func _on_PipisTimer_timeout():
	var micropipis = Pipis.instance()
	micropipis.scale /= 3
	micropipis.speed = 1
	micropipis.ttl = 1.0
	micropipis.G = 20
	micropipis.position = $Sprite/PipisSpawn.global_position
	micropipis.position.x += randi() % 100 - 100
	micropipis.get_node("ExplosionTimer").wait_time = 0.01
	add_child(micropipis)

func _on_AttackTimer_timeout():
	get_tree().change_scene(GlobalPartySettings.PARTY_ROOT_SCENE_PATH)
