extends Node2D

signal attack_ended

onready var bullet_spawn_timer = $BulletSpawnTimer
onready var Spamton = $Spamton
onready var SpamtonAnim = $Spamton/AnimatedSpriteController/AnimatedSprite
onready var SpamtonAnimPlayer = $Spamton/AnimationPlayer
onready var Jevil = $Jevil
onready var BulletSucker = $Spamton/BulletSucker
onready var mouth = $Spamton/mouth
onready var AttackMovePlayer = $Spamton/AttackMovePlayer

export (PackedScene) var dimond_scene
export (PackedScene) var dollar_scene

var all_bullets = []
var offset = Vector2(0, 0)
var time = 0


# неиграбельно, слишком сильное ускорение
func spawn_bullet(spawn_location, bullet_scene, direction, speed):
	spawn_location.unit_offset = randf()
	var bullet = bullet_scene.instance()
	bullet.direction = direction
	bullet.ttl = 4
	bullet.speed = speed
	add_child(bullet)
	bullet.add_to_group('bullets')
	bullet.position = spawn_location.position

func _on_BulletSpawnTimer_timeout():
	spawn_bullet($DimondPath/DimondSpawn, dimond_scene, Vector2.UP, 100)
	spawn_bullet($DollarPath/DollarSpawn, dollar_scene, Vector2.RIGHT, 20)

func _on_SpawnAllTimer_timeout():
	bullet_spawn_timer.stop()

func _on_AttackTimer_timeout():
	BulletSucker.deactivate()
	AttackMovePlayer.stop()
	SpamtonAnimPlayer.play("fall")
#	Jevil.facepalm()
	for bullet in get_tree().get_nodes_in_group("bullets"):
		bullet.queue_free()
	SpamtonAnim.play("increase_head", true)
	yield(SpamtonAnim, "animation_finished")
#	yield($Jevil/AnimationPlayer, "animation_finished")
	Spamton.visible = false
	Jevil.visible = false
	get_parent().get_node("Spamton").visible = true
	get_parent().get_node("Jevil").visible = true
	emit_signal("attack_ended")

func _ready():
	get_parent().get_node("Spamton").visible = false
	get_parent().get_node("Jevil").visible = false
	yield(get_tree().create_timer(1), "timeout")
	SpamtonAnim.play("increase_head")
	# нормально дождаться окончания анимации
	yield(get_tree().create_timer(1), "timeout")
	SpamtonAnim.play("head_attack")
	AttackMovePlayer.play("up_and_down")
	BulletSucker.activate()

func shorten_distance(bullet_sucker, bullet, delta, offset):
	var distance = ((bullet_sucker.global_position + offset) - bullet.global_position)
	return bullet_sucker.suck_speed * delta * distance/distance.length()

func _process(delta):
	offset = Vector2(0, 0)
	all_bullets = get_tree().get_nodes_in_group("bullets")
	for bullet in all_bullets:
		offset.y = 5 * (randi() % 10)
		offset.x = 5 * (randi() % 4)
		bullet.position += shorten_distance(BulletSucker, bullet, delta, offset)

func _on_mouth_area_entered(area):
	area.stop()
