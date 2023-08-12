extends AudioStreamPlayer2D

var music_folder = "res://Assets/music/%s"


func _ready():
	play()

func _on_soundtrack_required(theme):
	var new_audio = open_audio(theme)
	if new_audio != null:
		if playing:
			stop()
		stream = new_audio
		play()


func open_audio(theme):
	var audio_file = music_folder % theme
	if File.new().file_exists(audio_file):
		print('found file!')
		var sfx = load(audio_file)
		sfx.set_loop(false)
		return sfx
