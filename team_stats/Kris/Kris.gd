extends Node

var MAX_HP = 120
var HP = 120
signal KrisDown
signal KrisUp


func _ready():
	print('Kris ready')

func take_damage(damage):
	var new_HP = HP - damage
	print('Kris hp ', new_HP)
	$AnimatedSprite.play("damage")
	if HP > 0 and new_HP < 0:
		$AnimatedSprite.play("down")
		emit_signal("KrisDown")
	HP = new_HP

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.play("default")

# Обработка сигнала "take_damage":
#
# new_hp = HP - damage
# Если HP > 0 && new_hp < 0:
# - пускаем сигнал KrisDown
# - Спрайт KrisDown
# - больше не принимаем сигнал take_damage - Крис исключён из списка целей атак
# HP = new_hp

# Обработка сигнала "healed":
#
# Если HP < 0 && new_hp > 0:
# - пускаем сигнал KrisUp
# - Спрайт KrisDefault
# HP = new_hp


#func _process(delta):
#	pass
