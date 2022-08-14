extends HBoxContainer

signal resolution_changed(new_resolution)

onready var option_button : OptionButton = $OptionButton

func _update_selected_item(text: String) -> void:
	# The resolution options are written in the form "XRESxYRES".
	# Using `split_floats` we get an array with both values as floats.
	var values := text.split_floats("x")
	emit_signal("resolution_changed", Vector2(values[0],values[1]))


# warning-ignore:unused_argument
func _on_OptionButton_item_selected(index):
	_update_selected_item(option_button.text)
