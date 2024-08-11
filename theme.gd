extends AudioStreamPlayer2D

var music_folder = "res://Assets/music/%s"
var default_theme


func _ready():
	get_parent().connect("reset_music", self, "_on_reset_music")
	ActionsController.connect("slow_down_music", self, "_on_slow_down")
	ActionsController.connect("soundtrack_required", self, "set_soundtrack")

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

func _on_slow_down():
	self.pitch_scale -= 0.3

func _on_reset_music():
	if GlobalAttackSettings.PHASE_INDEX >= 3:
		 default_theme = "the_deals_revolving.mp3"
	else:
		 default_theme = "battle.ogg"
	
	set_soundtrack(default_theme)
	self.pitch_scale = 1.0
