extends NinePatchRect

export var character_color = Color(150, 0, 150, 1)
signal decided(decision)
var Decision = preload("res://team_stats/StatsEntities/DecisionMessage/DecisionMessage.tscn")

func _ready():
	# tmp: просто чтобы уже прокидывать цвет персонажа в UI, потом заменить на animated
	var custom_gradient = Gradient.new()
	custom_gradient.set_color(0, Color(0, 0, 0, 1))
	custom_gradient.set_color(1, character_color)
	texture = GradientTexture.new()
	texture.gradient = custom_gradient
	
	$Buttons/Attack.grab_focus()
	connect("decided", get_parent(), "_on_decided")


func return_to_common_menu(processing_method):
	$ChoicePanel.exit()
	if $ChoicePanel.get_node("ItemList").is_connected("item_activated", self, processing_method):
		$ChoicePanel.get_node("ItemList").disconnect("item_activated", self, processing_method)
	emit_signal("decided")


func use_attack_on_character(index):
	var VICTIM = ConStats.allies[index]
	release_focus()
	emit_signal("decided", "ATK", VICTIM)


func _on_Attack_button_down():
	release_focus()
	var decision = Decision.instance()
	decision.TYPE = 'ATK'
	emit_signal('decided', decision)


func _on_Act_button_down():
	release_focus()
	var decision = Decision.instance()
	decision.TYPE = 'ACT'
	emit_signal('decided', decision)


func _on_Item_button_down():
	release_focus()
	var decision = Decision.instance()
	decision.TYPE = 'ITEM'
	emit_signal('decided', decision)


func _on_Spare_button_down():
	release_focus()
	var decision = Decision.instance()
	decision.TYPE = 'SPARE'
	emit_signal('decided', decision)


func _on_Defense_button_down():
	release_focus()
	var decision = Decision.instance()
	decision.TYPE = 'DEFENSE'
	emit_signal('decided', decision)
