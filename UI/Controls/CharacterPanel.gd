extends Panel

var NEXT_PLAYER
var PREVIOUS_PLAYER

signal play(animation, blend, speed, from_back)
signal canceled
signal decided(decision)


func _ready():
	connect("play", get_parent().get_node("AnimationPlayer"), "play")


func _on_decided(decision):
	decision.DECIDER = name
	# обогощаем и продолжаем передавать
	emit_signal("decided", decision)


func close():
	$Buttons.close()
	emit_signal("play", name + "_close", -1, 3.5)
	# TODO: деактивировать


func open():
	print(name + ' Buttons will be opened!')
	$Buttons.open()
	if get_parent().get_node("AnimationPlayer").is_playing():
		yield(get_parent().get_node("AnimationPlayer"), "animation_finished")
	emit_signal("play", name + "_close", -1, -1.5)
	# TODO: активировать
