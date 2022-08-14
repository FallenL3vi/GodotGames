extends CanvasLayer

onready var animation : AnimationPlayer = $AnimationPlayer

export(int) var time_left = 10

# warning-ignore:unused_signal
signal start

func _ready():
	play()

func play():
	animation.play("Round_Count")
