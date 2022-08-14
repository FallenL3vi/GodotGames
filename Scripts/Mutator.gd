extends Node2D


# warning-ignore:unused_signal
signal draw_finished

onready var anim : AnimationPlayer = $AnimationPlayer
onready var effects = [$All/Food1/Effect, $All/Food2/Effect]
onready var textures = [preload("res://Sprites/shoe.png"), preload("res://Sprites/stength.png"),
 preload("res://Sprites/hell.png")]

var which : int = 0

var effect : int = 0

func play_pick() -> void:
	match which:
		1:
			anim.play("PickLeft")
		2:
			anim.play("PickRight")

func play_draw() -> void:
	for i in effects:
		i.texture = textures[effect-1]
	match which:
		1: 
			anim.play("Left")
		2:
			anim.play("Right")

func play() -> void:
	anim.play("Start")
