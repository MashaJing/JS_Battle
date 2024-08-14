extends Node2D

signal sub_attack_ended

var pts=PackedVector2Array()
var target = ["Kris", "Susie", "Ralsei", "Jevil"]
@onready var upperPointSpawn = $UpperPointSpawn/UpperPointLocation
@onready var lowerPointSpawn = $LowerPointSpawn/LowerPointLocation
@onready var Graphic = preload("res://Attacks/DramaAttacks/GraphicsAttack/Graphics/Graphic.tscn")
@onready var Border = preload('res://Border/Border.tscn')
var heart_position = Vector2.ZERO
var rng = RandomNumberGenerator.new()


#func init_border():
#	var border = Border.instance()
#	border.global_position = $KinematicHeart.global_position
#	add_child(border)
#	yield(border.get_node("BoxSprite"), "animation_finished")
#	$BorderField/TextureRect.visible = true
	

func _ready():
	await $BorderField.get_node("BoxSprite").animation_finished
	$BorderField/TextureRect.visible = true
	
	await get_tree().create_timer(9.0).timeout
	emit_signal("sub_attack_ended")


func _on_GraphicAttackTimer_timeout():
	var graphic = Graphic.instantiate()
	graphic.heart_position = $KinematicHeart.position

	upperPointSpawn.progress_ratio = rng.randf_range(0.0, 0.5)
	lowerPointSpawn.progress_ratio = rng.randf_range(0.5, 1.0)

	graphic.upper_position = upperPointSpawn.global_position
	graphic.lower_position = lowerPointSpawn.global_position
	add_child(graphic)
	if $GraphicAttackTimer.wait_time > 0.8:
		$GraphicAttackTimer.wait_time -=0.1
