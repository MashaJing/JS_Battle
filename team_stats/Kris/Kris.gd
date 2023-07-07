extends Node2D

var MAX_HP = 120
var HP = 120


# вынести всё в общий узел AnimationController?

func _ready():
	$AnimatedSprite.play("default")
	$PlayerStats.connect("Down", self, "_on_Down")
	$PlayerStats.connect("Up", self, "_on_Up")
	$PlayerStats.connect("Healed", self, "_on_Healed")
	$PlayerStats.connect("TookDamage", self, "_on_Took_Damage")

func _on_Took_Damage():
	$AnimatedSprite.play("damage")
	yield($AnimatedSprite, "animation_finished")

# но если полечили, но не подняли, должно быть Down -_-
# есть ли способ задать дефолтную анимацию?
# (при смерти она down, иначе - т.н. idle)

# решение: для анимаций м.б. реализована машина состояний. Состояния 2: Down, Up

	$AnimatedSprite.play("default")

func _on_Healed():
	$AnimatedSprite.play("heal")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("default")

func _on_Down():
	print("playing down!")
	$AnimatedSprite.play("down")

func _on_Up():
	$AnimatedSprite.play("default")

