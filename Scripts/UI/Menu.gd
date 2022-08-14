extends Panel

signal quit_game
signal start_game
signal open_settings

onready var b_sound : AudioStreamPlayer = $ButtonSound
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_QuitButton_pressed():
	b_sound.play()
	yield(b_sound, "finished")
	emit_signal("quit_game")


func _on_SettingsButton_pressed():
	b_sound.play()
	yield(b_sound, "finished")
	emit_signal("open_settings")


func _on_PlayButton_pressed():
	b_sound.play()
	yield(b_sound, "finished")
	emit_signal("start_game")
