extends AudioStreamPlayer2D

var music_folder = "res://Assets/music/%s"


func _ready():
	pass

func set_soundtrack(theme):
	var new_audio = open_audio(theme)
	if new_audio != null:
		print('Theme: could not open audio')
		if playing:
			stop()
		stream = new_audio
		play()


func open_audio(theme):
	var audio_file = music_folder % theme
	if File.new().file_exists(audio_file):
		var sfx = load(audio_file)
		sfx.set_loop(true)
		return sfx
	print('Theme: didnt find music file!')
