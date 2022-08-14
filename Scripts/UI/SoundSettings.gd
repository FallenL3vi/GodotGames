extends VBoxContainer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

signal change_audio(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_HSlider_value_changed(value: float) -> void:
	emit_signal("change_audio", value)
