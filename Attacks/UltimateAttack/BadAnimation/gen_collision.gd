extends Node2D

var time = 0
var collision_segments = 20
var EPS = 2
signal attack_ended


func _ready():
	$AnimationPlayer.play("play_movie")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("attack_ended")
	print('emmited')

func _process(delta):
	pass


func set_collision_by_sprite():
	# Извлекаем из анимации текущий кадр (да, это делается через одно место)
	var texture = $Screen.frames.get_frame("default", $Screen.frame)
	var children = $BadArea.get_children()

	
	# сохраняем в будущий кадр с коллизией текстуру текущего кадра
#	var sprite = Sprite.new()
#	sprite.texture = texture
#	sprite.scale = $Screen.scale
#	$BadArea.add_child(sprite)
#	sprite.owner = $BadArea

	var time_start = OS.get_ticks_msec()
	# удаляем полигоны из предыдущего кадра, распознавая по группе col_polys
	for child in children:
		if child.is_in_group('col_polys'):
			$BadArea.remove_child(child)

	var time_now = OS.get_ticks_msec()
	var time_elapsed = time_now - time_start
	print('deleting old polys')
	print(time_elapsed)
	
	time_start = OS.get_ticks_msec()
	
	# формируем битмапу на основе текстуры кадра
	var bitmap = BitMap.new()
	var data = texture.get_data()
	bitmap.create_from_image_alpha(data)

	time_now = OS.get_ticks_msec()
	time_elapsed = time_now - time_start
	print('formed bitmap')
	print(time_elapsed)
	
	# масштабируем в соответствии с нодой в сцене
	var curr_size = bitmap.get_size()
	bitmap.resize(curr_size)

	# Чтобы учесть вогнутые фигуры в полигоне, разбиваем его
	# на вертикальные сегменты в количестве {collision_segments}
	var segment_size = Vector2(curr_size[0]/collision_segments, curr_size[1])
	var polys

	var cycle_time_start = OS.get_ticks_msec()
	# Итерируемся по всем сегментам
	for i in range(collision_segments):
		# Создаём полигоны сегмента по битмапе
		# скорее всего, где-то здесь вырезаем только часть изображения, а не делим всё на 20 частей
		
		polys = bitmap.opaque_to_polygons(
			Rect2(Vector2(curr_size[0] * i /collision_segments, 0),
			segment_size), EPS)

		time_start = OS.get_ticks_msec()
		# Добавляем полигоны сегмента в сцену, присваивая им группу col_polys
		for poly in polys:
			var collision_polygon = CollisionPolygon2D.new()
			collision_polygon.polygon = poly
			$BadArea.add_child(collision_polygon)
			collision_polygon.add_to_group('col_polys')
			collision_polygon.owner = $BadArea
			collision_polygon.scale *= $Screen.scale
			if $Screen.centered:
				collision_polygon.position += Vector2(segment_size[0] * collision_polygon.scale.x * i, 0)

	# Сохраняем area (коллизию + спрайт) в файл
	var scene = PackedScene.new()
	scene.pack($BadArea)
	ResourceSaver.save("res://Attacks/UltimateAttack/Assets/CollisionFrames/jevils_gift/cframe{frame}.tscn".format({'frame': $Screen.frame}), scene)
#	$BadArea.remove_child(sprite)

	time_now = OS.get_ticks_msec()
	print('bitmap to polygons')
	print(time_now - cycle_time_start - time_elapsed * collision_segments)


func _on_Screen_frame_changed():
	pass
	#set_collision_by_sprite()
