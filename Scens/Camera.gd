extends Camera2D

onready var shaker = $Shake

func _ready():
	shaker.camera = self

func shake() -> void:
	shaker.shake(rand_range(0.2,0.4),rand_range(0.2,0.4))
