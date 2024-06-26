extends NinePatchRect

signal decided(decision)
signal play_pressed
signal play_changed

export var character_color = Color(150, 0, 150, 1)
var Decision = preload("res://team_stats/StatsEntities/DecisionMessage/DecisionMessage.tscn")
onready var character_panel = get_parent()


func _ready():
	# tmp: просто чтобы уже прокидывать цвет персонажа в UI, потом заменить на animated
	var custom_gradient = Gradient.new()
	custom_gradient.set_color(0, Color(0, 0, 0, 1))
	custom_gradient.set_color(1, character_color)
	texture = GradientTexture.new()
	texture.gradient = custom_gradient
	connect("decided", character_panel, "_on_decided")


func open():
	for button in $Buttons.get_children():
		button.disabled = false
		button.visible = true
	$Buttons/Attack.grab_focus()


func close():
	for button in $Buttons.get_children():
		button.disabled = true
		button.visible = false
	$Buttons.release_focus()


func _on_Attack_button_down():
	emit_signal("play_pressed")
	$Buttons/Attack.release_focus()
	var decision = Decision.instance()
	decision.TYPE = 'ATK'
	emit_signal('decided', decision)


func _on_Act_button_down():
	emit_signal("play_pressed")
	$Buttons/Act.release_focus()
	var decision = Decision.instance()
	decision.TYPE = 'ACT'
	emit_signal('decided', decision)


func _on_Item_button_down():
	emit_signal("play_pressed")
	$Buttons/Item.release_focus()
	var decision = Decision.instance()
	decision.TYPE = 'ITEM'
	emit_signal('decided', decision)


func _on_Spare_button_down():
	emit_signal("play_pressed")
	$Buttons/Spare.release_focus()
	var decision = Decision.instance()
	decision.TYPE = 'SPARE'
	emit_signal('decided', decision)


func _on_Defense_button_down():
	emit_signal("play_pressed")
	$Buttons/Defense.release_focus()
	var decision = Decision.instance()
	decision.TYPE = 'DEFENSE'
	emit_signal('decided', decision)


func _on_Button_changed():
	emit_signal("play_changed")
