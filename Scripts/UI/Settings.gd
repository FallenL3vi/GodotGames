extends Panel


signal apply_button_pressed(settings)
signal escape_settings

onready var button := $AudioStreamPlayer
#Storing settings in dictionary
var _settings := {resolution = Vector2(640, 480), fullscreen = false, vsync = false}

var old_audio : float = 100.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	emit_signal("apply_button_pressed", _settings)
	button.play()


func _on_UIResolutionSelecter_resolution_changed(new_resolution : Vector2) -> void:
	_settings.resolution = new_resolution


func _on_UIFullscreenCheckbox_toggled(is_button_pressed):
	_settings.fullscreen = is_button_pressed


func _on_UIVsyncCheckbox_toggled(is_button_pressed):
	_settings.vsync = is_button_pressed


func _on_ButtonBack_pressed():
	button.play()
	yield(button, "finished")
	emit_signal("escape_settings")


func _on_SoundSettings_change_audio(value) -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	if value > $VBoxContainer/SoundSettings/HSlider.min_value:
		AudioServer.set_bus_mute(bus_idx, false)
		AudioServer.set_bus_volume_db(bus_idx, value)
	else:
		AudioServer.set_bus_mute(bus_idx, true)
