extends Node2D

onready var Jevil = get_parent().get_node("Jevil")
onready var Spamton = get_parent().get_node("Spamton")
onready var MusTheme = get_parent().get_node("Theme")

var current_dialogue_n = 0
var dialoguePath = 'res://Assets/Texts/confession.json'
var sound_files = {
	"Jevil": "res://Assets/sounds/voice_jevil.mp3",
	"Spamton": "res://Assets/sounds/voice_spamton.mp3",
}

signal soundtrack_required
signal attack_ended


func _ready():
	yield(get_tree().create_timer(1.5), 'timeout')
	# приконнектить к аудио
#	connect("soundtrack_required", get_parent(), "_on_soundtrack_required")
	emit_signal("soundtrack_required", "sad_dialtone.mp3")
	var dialogue = getDialogue()
	Spamton.get_node("AnimationPlayer").play("black_glasses")
	Jevil.get_node("AnimationPlayer").play("Sad")
	
	get_parent().play_dialogue(dialogue, 0)
	yield(get_parent(), "finished_talking")
	yield(get_tree().create_timer(1.0), "timeout")
	Spamton.get_node("AnimationPlayer").play("hug")
	yield(Spamton.get_node("AnimationPlayer"), "animation_finished")
	Jevil.get_node("AnimationPlayer").play("Hug")
	yield(Jevil.get_node("AnimationPlayer"), "animation_finished")
	Jevil.get_node("AnimationPlayer").play("Sad")
	
	get_parent().play_dialogue(dialogue, 1)
	


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
