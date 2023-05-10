extends ColorRect

export var dialoguePath = ""

var dialogue

var phraseNum = 0
var finished = false
signal action_required
signal soundtrack_required


var sound_files = {
	"Jevil": "res://Assets/sounds/voice_jevil.mp3",
	"Ralsei": "res://Assets/sounds/voice_ralsei.mp3",
	"Spamton": "res://Assets/sounds/voice_spamton.mp3",
	"Susie": "res://Assets/sounds/voice_susie.mp3",
	"Lancer": "res://Assets/sounds/voice_lancer.mp3",
	"beep": "res://Assets/sounds/snd_beep.mp3",
}
var voices = {}


func init_audio():
	for speaker in sound_files.keys():
		var f = File.new()	
		var snd = sound_files[speaker]
		if f.file_exists(snd):
			voices[speaker] = load(snd)
		else: voices[speaker] = null

func _ready():
	init_audio()
	dialogue = getDialogue()
	assert(dialogue, "Dialogue not found!")
	nextPhrase()


func _process(delta):
	if Input.is_action_just_pressed("Enter"):
		if finished:
			nextPhrase()

	if Input.is_action_just_pressed("x"):
		$Text.visible_characters = len($Text.text)

	if Input.is_action_just_pressed("c"):
		$Text.visible_characters = len($Text.text)
		while phraseNum < len(dialogue) and dialogue[phraseNum]["main"] == false:
			phraseNum += 1
		nextPhrase()
		$Text.visible_characters = len($Text.text)
	

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

func setImage(path, portrait=$Portrait):
	var f = File.new()
	if f.file_exists(path):
		portrait.texture = load(path)
	else: portrait.texture = null

func nextPhrase():
	if phraseNum >= len(dialogue):
		queue_free()
		return
	finished = false
	
	$Text.bbcode_text = "[code]* " + dialogue[phraseNum]["text"] + "[/code]"
	$Timer.wait_time = (1/dialogue[phraseNum]["speed"]) / 100
	$Voice.stream = voices[dialogue[phraseNum]["speaker"]]
	setImage(dialogue[phraseNum]["image"])

	# делаем фразу невидимой, чтобы вывести побуквенно в цикле
	$Text.visible_characters = 0

	# делаем ответ невидимым, есть он или нет
	$ReplyText.bbcode_text = ''
	$ReplyPortrait.texture = null

	if "animation" in dialogue[phraseNum].keys():
		for animation in dialogue[phraseNum]["animation"]:
			var reversed = false
			if "reversed" in animation.keys():
				reversed = animation['reversed']
			emit_signal("action_required", animation["actor"], animation["action"], reversed)
	
	# выводим фразу побуквенно
	$Voice.play()	
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		$Timer.start()
		yield($Timer, "timeout")
	$Voice.stop()

	# если на фразу был ответ в углу, выводим его
	if "reply" in dialogue[phraseNum].keys():
		setImage(dialogue[phraseNum]["reply"]["image"], $ReplyPortrait)
		$ReplyText.bbcode_text = "[code]" + dialogue[phraseNum]["reply"]["text"] + "[/code]"
		if "sound" in dialogue[phraseNum]["reply"].keys():
			$ExtraSound.stream = voices[dialogue[phraseNum]["reply"]["sound"]]
			$ExtraSound.play()

	if "music" in dialogue[phraseNum].keys():
		emit_signal("soundtrack_required", dialogue[phraseNum]['music'])
	
	finished = true
	phraseNum += 1
	return
