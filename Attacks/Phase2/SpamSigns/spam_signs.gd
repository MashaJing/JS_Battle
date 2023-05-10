extends Node2D

export (PackedScene) var SpammedBullets
onready var parents = $Spawns.get_children()
var parents_ind = []
onready var Trail = preload("res://Attacks/Phase2/SpamSigns/Trail/Trail.tscn")
var speed = 0


func _ready():
	for _clone_phase in range(2):
		for i in range(len(parents)):
			yield($CloneTimer, "timeout")
			# переходим на уровень ниже
			var heart_bullet = SpammedBullets.instance()
			heart_bullet.speed = 1/float(i + 1)
			var trail = Trail.instance()
			trail.body = heart_bullet
			add_child(trail)
			parents[i].set_child_heart(heart_bullet)
			parents[i] = parents[i].get_child_heart()

func _process(delta):
	pass
