extends Node2D

signal action_start
signal canceled
signal spared
signal play_spare


func _ready():
	_init_signals()

# вызывается при выборе пощады
func start_spare(actor):
#	1. отправляет сигналы анимашкам, чтобы обозначить готовность
	emit_signal("action_start", actor)


# вызывается при отмене пощады (удалении из стека?)
func cancel_spare(actor):
#	1. отправляет сигналы анимашкам, чтобы вернуть дефолтный вид
	emit_signal("canceled", actor)


func confirm_spare(decider, decision_victim):
	emit_signal("spared", decision_victim)
	emit_signal("play_spare", decider)


func _init_signals():
	connect("spared", Callable(ConStats, "_on_take_spare"))
