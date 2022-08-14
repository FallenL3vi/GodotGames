extends Node2D

onready var body : PackedScene = preload("res://Scens/Elements/Body.tscn")
onready var sound = preload("res://Global/Spawn.tscn")
onready var win = preload("res://Global/WinSound.tscn")
onready var spawn : Position2D = $Position2D

onready var win_head : Sprite = $Sprite
onready var text : Label = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_pressed("reset"):
		get_parent().reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func spawn_bodies() -> void:
	for i in Global.score.size():
		for j in Global.score[i+1]:
			var b = body.instance()
			self.add_child(b)
			b.global_position = spawn.global_position
			b.change_player(i+1)
			b.apply_impulse(Vector2(20.0, 0.0), Vector2(0.0, 50.0))
			var a = sound.instance()
			add_child(a)
			yield(get_tree().create_timer(0.8),"timeout")
	if Global.score[1] > Global.score[2]:
		win_head.frame = 0
	else:
		win_head.frame = 1
	text.visible = true
	win_head.visible = true
	var c = win.instance()
	self.add_child(c)

func _on_Timer_timeout():
	spawn_bodies()
