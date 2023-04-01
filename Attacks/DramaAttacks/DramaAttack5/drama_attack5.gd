extends Node2D

var pts=PoolVector2Array()

onready var upperPointSpawn = $UpperPointSpawn/UpperPointLocation
onready var lowerPointSpawn = $LowerPointSpawn/LowerPointLocation
onready var Graphic = preload("res://Attacks/DramaAttacks/DramaAttack5/Graphics/Graphic.tscn")
var heart_position = Vector2.ZERO

var rng = RandomNumberGenerator.new()


func _ready():
	pass

func _on_GraphicAttackTimer_timeout():
	var graphic = Graphic.instance()
	graphic.heart_position = $Heart.position

	# заменить 0.5 на сердечко
	upperPointSpawn.unit_offset = rng.randf_range(0.0, 0.5)
	lowerPointSpawn.unit_offset = rng.randf_range(0.5, 1.0)

	graphic.upper_position = upperPointSpawn.global_position
	graphic.lower_position = lowerPointSpawn.global_position
	add_child(graphic)
	if $GraphicAttackTimer.wait_time > 0.6:
		$GraphicAttackTimer.wait_time -=0.4
