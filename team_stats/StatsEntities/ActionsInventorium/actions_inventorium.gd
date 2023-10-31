extends Node2D


class Action:
	var name
	var tp_required
	var icon
	var description
	var text_on_used

	func _init(name, tp_required, text_on_used):
		self.name = name
		self.tp_required = tp_required
		self.icon = null
		self.description = null
		self.text_on_used = text_on_used

var AVAILABLE_ACTIONS


func _ready():
	AVAILABLE_ACTIONS = {
	"kris":[ 
		Action.new("K_ACTION", 100, 'gazed strangely'),
		Action.new("PIRUETT", 10, 'spun around'),
		Action.new("X_SLASH", 10, 'used X-Slash'),
		Action.new("FRIED_PIPIS", 10, 'asked for fried pipis... but Jevil already ate it all!')
],
	"susie": [
		Action.new("S_ACTION", 10, 'spun something around'),
		Action.new("RUDE_BUSTER", 50, 'used RUDE BUSTER'),
		Action.new("ULTIMATE_HEAL", 99, 'casted ULTIMATE HEAL')  # Дни практики творят чудеса
],
	"ralsei": [
		Action.new("R_ACTION", 100, 'chanted something'),
		Action.new("HEAL_PRAYER", 10, 'casted HEAL PRAYER'),
		Action.new("PACIFY", 10, 'casted PACIFY')
]}


#func get_action_tp(name):
