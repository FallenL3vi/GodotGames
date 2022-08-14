tool
extends HBoxContainer

#emit singal when CheckBox is toggled
signal toggled(is_button_pressed)

export var title := "" setget set_title

onready var label := $Label


func set_title(value) -> void:
	title = value
	#Wait until the scen is ready if 'label' is null
	if not label:
		yield(self, "ready")
	label.text = title

func _on_CheckBox_toggled(button_pressed : bool) -> void:
	emit_signal("toggled", button_pressed)
