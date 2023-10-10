extends Node2D
var ind = 0

onready var Shard = preload("res://Bullets/Rock/Rock.tscn")
signal attack_ended


func _ready():
	$AnimationPlayer.play("falling_down")
	yield($AnimationPlayer, "animation_finished")

	for i in range(30):
		$PiecesSpawn/PathSpawnFollow.unit_offset = randf()
		var shard = Shard.instance()
		shard.position = $PiecesSpawn/PathSpawnFollow.position
		add_child(shard)
		yield(get_tree().create_timer(0.1), "timeout")
	emit_signal("attack_ended")	
	
