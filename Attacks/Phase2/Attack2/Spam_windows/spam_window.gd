extends Area2D

var base_testure_dir = "res://Assets/Images/Bullets/SpamWindows/%s.png"
var textures = ["coolmix", "potassium", "cheapcars", "dolltheatre", "search"]


func _ready():
	$Sprite2D.texture = load(base_testure_dir % textures[randi() % len(textures)])
	$AnimationPlayer.play("window_open")
	set_random_z_index()

func set_random_z_index():
	var p = randf()
	if p < 0.3:
		$Sprite2D.z_index = 0
	else:
		$Sprite2D.z_index = 1
	
