extends Node2D

signal attack_start
signal attack_end
signal canceled

signal attacked
signal damage_enemy(victim, damage)

# соответствия "нападающий-жертва" - нет смысла хранить упорядоченно
var attacks = {}


func _ready():
	connect("damage_enemy", Callable(ConStats, "_on_take_damage"))


# вызывается при выборе атаки
func start_attack(actor, victim):
	print("start_attack")
	print(actor)
	print(victim)
#	get_tree().
#	1. отправляет сигналы анимашкам, чтобы обозначить готовность
	emit_signal("attack_start", actor, 'start_attack')
#	2. добавляет союзника в список нападающих
	attacks[actor] = victim
	

# вызывается при отмене атаки (удалении из стека)
func cancel_attack(actor):
#	1. отправляет сигналы анимашкам, чтобы вернуть дефолтный вид
	emit_signal("canceled", actor)
#	2. убирает союзника из множества нападающих
	attacks.erase(actor)


# вызывается при остановке ползунка
func confirm_attack(ratio, actor):
	var victim = attacks[actor]
	var actor_atk = TeamStats.individual_stats[actor].ATK
	var victim_def = ConStats.individual_stats[victim].DEF

	# 1. отправляет сигнал анимашке, чтобы обозначить завершение атаки
	emit_signal("attack_end", actor, 'attack')
	# 2. отправляет сигнал анимашке противника, чтобы обозначить получение атаки
	emit_signal("attack_end", attacks[actor], 'damage')
	# 3. считает урон противнику и отправляет ему ~(ratio * наш ATK - его DEF)
	emit_signal("damage_enemy", attacks[actor], calculate_damage(ratio, actor_atk, victim_def))
	# 4. исключает союзника из множества нападающих
	attacks.erase(actor)


func calculate_damage(ratio, victim_def, fighter_atk):
	return abs(fighter_atk - victim_def - ratio)
