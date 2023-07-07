extends Node2D

var dialoguePath = 'res://Assets/Texts/monologue.json'
var sound_files = {
	"Jevil": "res://Assets/sounds/voice_jevil.mp3",
	"Spamton": "res://Assets/sounds/voice_spamton.mp3",
}
onready var Jevil = get_parent().get_node("TeamStats/Jevil")
onready var Spamton = get_parent().get_node("TeamStats/Spamton")

onready var TeamStats = get_parent().get_node("TeamStats")

#onready var JevilAnim = get_parent().get_node("TeamStats/Jevil")
#onready var SpamtonAnim = get_parent().get_node("TeamStats/Spamton")
onready var MusTheme = get_parent().get_node("Theme")

onready var attacks = [
	preload("res://Attacks/DramaAttacks/GamesWePlayedAttack/GamesWePlayedAttack.tscn"),
	preload("res://Attacks/DramaAttacks/GraphicsAttack/GraphicsAttack.tscn"),
	preload("res://Attacks/DramaAttacks/HandKnivesAttack/HandKnivesAttack.tscn"),
	preload("res://Attacks/DramaAttacks/TheirLegsAttack/TheirLegsAttack.tscn")
]

# нормально обработать
onready var last_attack = preload("res://Attacks/DramaAttacks/PhoneAttack/PhoneAttack.tscn")

var current_dialogue_n = 0
signal attack_ended


func getDialogue():
	var f = File.new()
	assert(f.file_exists(dialoguePath), "File does not exist!")
 
	f.open(dialoguePath, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []


func _ready():
	print(get_parent().get_children())
	var dialogue = getDialogue()
	Spamton.get_node("AnimationPlayer").play("default")
	Jevil.get_node("AnimationPlayer").play("Surprised")
	for attack in attacks:
		get_parent().play_dialogue(dialogue, current_dialogue_n)
		var Attack = attack.instance()
		print('Attack.target is ', Attack.target)
		TeamStats.choose_target(Attack.target)
		yield(get_parent(), "finished_talking")
		call_deferred("add_child", Attack)
		yield(Attack, "attack_ended")
		call_deferred("remove_child", Attack)
		current_dialogue_n+=1
		MusTheme.pitch_scale += 0.08

	var Attack = last_attack.instance()
	call_deferred("add_child", Attack)
	get_parent().play_dialogue(dialogue, 5)
	yield(get_parent(), "finished_talking")
	for _i in range(7):
		MusTheme.pitch_scale -= 0.15
		yield(get_tree().create_timer(0.15), "timeout")
	MusTheme.stop()
	MusTheme.pitch_scale = 1
	call_deferred("remove_child", Attack)
	emit_signal("attack_ended")

