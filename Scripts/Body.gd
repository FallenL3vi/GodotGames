extends RigidBody2D

onready var sprite : Sprite = $Sprite


func change_player(var player : int) -> void:
	sprite.frame = player - 1
