extends Node2D

onready var Dialogue = $Dialogue/Texture/DialogueBox
onready var Jevil = $Jevil
onready var JevilSprite = $Jevil/AnimatedSprite
onready var JevilAnim = $Jevil/AnimationPlayer
onready var Susie = $Susie
onready var SusieAnim = $Susie/AnimationPlayer
onready var Spamton = $Spamton
onready var SpamtonAnim = $Spamton/AnimationPlayer

onready var actors = {
	"Spamton": SpamtonAnim,
	"Jevil": JevilAnim,
	"Susie": SusieAnim,
}

func _ready():
	JevilSprite.hide()
	SpamtonAnim.play("default")
	SusieAnim.play("default")
	Dialogue.connect("action_required", self, "_on_action_required")

func _on_action_required(actor, action, from_end=false):
	actors[actor].play(action, -1, 1.0, from_end)
