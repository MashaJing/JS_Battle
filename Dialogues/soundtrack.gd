extends AudioStreamPlayer

var music_folder = "res://Assets/music/%s"


func _on_soundtrack_required(theme):
	if playing:
		stop()
	var audio_file = music_folder % theme
	if File.new().file_exists(audio_file):
		var sfx = load(audio_file)
		sfx.set_loop(false)
		stream = sfx
		play()
