extends Control

var character_stats
export (Texture) var NameTexture
export (Texture) var HpTexture
export (Texture) var PortraitTexture

var DefaultTheme = preload("res://UI/themes/MenuTheme.tres")
var LowHpTheme = preload("res://UI/themes/LowHpTheme.tres")


func _ready():
	_init_textures()


func _update_hp():
	$HpBar/Progress.value = character_stats.HP
	$HpBar/Digit.text = str(character_stats.HP)
	print("_____THEME_____")
	print($HpBar.theme)
	
	if character_stats.HP <= 0:
		$HpBar.theme = LowHpTheme
		print("SWITCHED THEME TO")
		print($HpBar.theme)
	else:
		$HpBar.theme = DefaultTheme


func _init_textures():
	$Name.texture = NameTexture
	$HpBar.texture = HpTexture
	$Portrait.texture = PortraitTexture


func set_character_stats(stats):
	self.character_stats = stats
	$HpBar/Progress.max_value = character_stats.MAX_HP
	$HpBar/Progress.value = character_stats.HP
	$HpBar/Digit.text = str(character_stats.HP)
	$HpBar/Digit_max.text = str(character_stats.MAX_HP)
	character_stats.connect("TookDamage", self, "_update_hp")
	character_stats.connect("Healed", self, "_update_hp")
