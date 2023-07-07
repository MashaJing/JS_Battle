extends Area2D

var time = 0
var speed = 0
var flipped = false
var rotation_speed = .01
export var direction = Vector2.LEFT
onready var sprite = $Sprite
onready var texture = $Sprite.texture

var collision_segments = 4
var EPS = 5


func _ready():
	if flipped:
		rotation_speed *= -1
		scale.x = -scale.x
		#set_collision_by_sprite()


func _process(delta):
	rotate(rotation_speed)


# todo: вынести в отдельный скрипт для спрайта
#func set_collision_by_sprite():
#	remove_child($CollisionPolygon2D)
#	var data = texture.get_data()
	
#	var bitmap = BitMap.new()
#	bitmap.create_from_image_alpha(data)

#	var segment_size = Vector2(texture.get_size()[0]/collision_segments, texture.get_size()[1])
#	var polys
	
#	for i in range(collision_segments):
#		polys = bitmap.opaque_to_polygons(Rect2(
#			Vector2(texture.get_size()[0] * i /collision_segments, 0),
#			segment_size), EPS)

#		for poly in polys:
#			var collision_polygon = CollisionPolygon2D.new()
#			collision_polygon.polygon = poly
#			$Sprite.add_child(collision_polygon)

#			if $Sprite.centered:
#				collision_polygon.position += -bitmap.get_size() / 2 + Vector2(segment_size[0] * i, 0)
