extends Node2D

onready var bullet_spawn_timer = $BulletSpawnTimer
onready var Spamton = $Spamton
onready var SpamtonAnim = $Spamton/AnimatedSprite
onready var SpamtonAnimPlayer = $Spamton/AnimationPlayer
onready var knife_path = $KnifePath
onready var devils_knife = $KnifePath/DevilsKnife
onready	var paths_to_follow = [[$Down, false], [$Up, true]]
onready var miniton_path_scene = preload("res://Bullets/Miniton/PathFollow.tscn")
onready var DevilsKnifePath = preload("res://Bullets/DevilsKnife/KnifePath.tscn")


func spawn_bullet(path, flipped):
	var bullet = miniton_path_scene.instance()
	bullet.flipped = flipped
	path.add_child(bullet)
	bullet.add_to_group('bullets')
	if devils_knife:
		devils_knife.connect("area_entered", bullet, "_on_area_knife_entered")
	

func _on_BulletSpawnTimer_timeout():
	var args = paths_to_follow[randi() % 2]
	spawn_bullet(args[0], args[1])
	bullet_spawn_timer.wait_time = randf() / 2

func _ready():
	bullet_spawn_timer.start()
	bullet_spawn_timer.autostart = true
	yield(get_tree().create_timer(1), "timeout")
	SpamtonAnim.play("increase_head")
	# нормально дождаться окончания анимации
	yield(get_tree().create_timer(1), "timeout")
	spawn_knife()
	SpamtonAnim.play("head_attack")
	yield(get_tree().create_timer(2), "timeout")
	bullet_spawn_timer.stop()
	SpamtonAnim.play("increase_head", true)

func spawn_knife():
	var knife = DevilsKnifePath.instance()
	knife_path.add_child(knife)
	print(knife.get_children())
	var DevilsKnife = knife.get_node("DevilsKnife")
	for bullet in get_tree().get_nodes_in_group("bullets"):
		DevilsKnife.connect("area_entered", bullet, "_on_area_knife_entered")
