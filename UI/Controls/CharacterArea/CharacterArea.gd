extends Control

var character_stats
export (Texture) var NameTexture
export (Color) var HpColor
export (Texture) var PortraitTexture

var DEFAULT_THEME_PATH = preload("res://UI/themes/MenuTheme.tres")
var LOW_HP_THEME = preload("res://UI/themes/LowHpTheme.tres")

var DefaultTheme
var LowHpTheme


func _ready():
	_init_textures()


func _update_hp():
	print("LEEETS UPDATE HP IN MENU")
	print(character_stats.HP)
	$HpBarArea/Progress.value = character_stats.HP
	$HpBarArea/Digit.text = str(character_stats.HP)
	print("_____THEME_____")
	print($HpBarArea/Progress.theme)
	
	if character_stats.HP <= 0:
		$HpBarArea/Progress.theme = LowHpTheme
		print("SWITCHED THEME TO")
		print($HpBarArea/Progress.theme)
	else:
		$HpBarArea/Progress.theme = DefaultTheme


func _init_textures():
	DefaultTheme = Theme.new()
	LowHpTheme = Theme.new()
	DefaultTheme.copy_theme(DEFAULT_THEME_PATH)
	LowHpTheme.copy_theme(LOW_HP_THEME)
	$Name.texture = NameTexture
	$Portrait.texture = PortraitTexture
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = HpColor
	print('--------colors----------')
	print(DefaultTheme.get_stylebox('fg', 'ProgressBar'))
	print(DefaultTheme.get_stylebox('bg', 'ProgressBar'))

	DefaultTheme.set_stylebox('fg', 'ProgressBar', stylebox)
	$HpBarArea/Progress.theme = DefaultTheme
#	print($HpBarArea/Progress.theme)


func set_character_stats(stats):
	self.character_stats = stats
	$HpBarArea/Progress.max_value = character_stats.MAX_HP
	$HpBarArea/Progress.value = character_stats.HP
	$HpBarArea/Digit.text = str(character_stats.HP)
	$HpBarArea/Digit_max.text = str(character_stats.MAX_HP)
	character_stats.connect("UpdateHp", self, "_update_hp")
