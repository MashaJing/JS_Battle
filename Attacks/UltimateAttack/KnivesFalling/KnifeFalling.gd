extends Node2D


func _ready():
	$KnifeOrigin/DevilsKnife.rotation_speed = 0

func _process(delta):
	$KnifeOrigin.rotation -= 8 * delta
	$KnifeOrigin.position += Vector2.DOWN * delta * 450

func _on_DestroyArea_area_entered(area):
	print('caught signal')
	
	print(area.is_in_group("bullets"))
	if area.is_in_group("knife"):
		print('aaaaaaaaaaaaaaaaaa')
		area.queue_free()
		$DestroyArea/WhaiteRaySpawn/AnimationPlayer.play("appear")
