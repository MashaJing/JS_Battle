extends Node2D


class Action:
	var name
	var tp_required
	var icon
	var description
	var text_on_used
	var used_on

	func _init(name, tp_required, text_on_used, used_on=null):
		self.name = name
		self.tp_required = tp_required
		self.text_on_used = text_on_used
		self.used_on = used_on
		self.icon = null
		self.description = null

var AVAILABLE_ACTIONS


func _ready():
	AVAILABLE_ACTIONS = {
	"Kris":[ 
		Action.new("K_ACTION", 10, 'gazed strangely'),
		Action.new("PIRUETT", 20, 'spun around'),
		Action.new("X_SLASH", 50, 'used X-Slash'),
		Action.new("FRIED_PIPIS", 10, 'asked for fried pipis... but Jevil already ate it all!'),
		Action.new("OFFER_DEAL", 0, 'asked Spamton if he sells bath bombs') # тут замутить атаку с пиписами
],
	"Susie": [
		Action.new("S_ACTION", 10, 'spun something around'),
		Action.new("RUDE_BUSTER", 50, 'used RUDE BUSTER'),
		Action.new("ULTIMATE_HEAL", 99, 'casted ULTIMATE HEAL')  # Дни практики творят чудеса
],
	"Ralsei": [
		Action.new("R_ACTION", 10, 'chanted something'),
		Action.new("HEAL_PRAYER", 10, 'casted HEAL PRAYER', TeamStats.all_heroes),
		Action.new("PACIFY", 10, 'casted PACIFY', ConStats.allies)
]}
