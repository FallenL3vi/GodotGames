extends ColorRect

export(String, FILE, "*.tscn") var next_scene_path

onready var _anim_player := $AnimationPlayer
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_anim_player.play_backwards("Fade")

func transition_to(_next_scene := next_scene_path) -> void:
	_anim_player.play("Fade")
	yield(_anim_player, "animation_finished")
# warning-ignore:return_value_discarded
	get_tree().change_scene(_next_scene)

func transition_to2(_next_scene := next_scene_path) -> void:
	_anim_player.play("Fade")
	yield(_anim_player, "animation_finished")
	get_parent().add_child(_next_scene)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
