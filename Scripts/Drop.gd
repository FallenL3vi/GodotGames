extends Area2D

onready var anim : AnimationPlayer = $AnimationPlayer
onready var timer : Timer = $Timer

var item : PackedScene = null

var items = [preload("res://Scens/Chair.tscn"), preload("res://Scens/ChairBack.tscn"),
preload("res://Scens/ChairLeft.tscn"), preload("res://Scens/ChairRight.tscn"), preload("res://Scens/Table.tscn"),
preload("res://Scens/FoodTable.tscn"), preload("res://Scens/FoodTable2.tscn"), preload("res://Scens/FoodTable3.tscn"),
preload("res://Scens/FoodTable4.tscn")]

var sound = preload("res://Global/Audio.tscn")

var burger = preload("res://Scens/Burger.tscn")

var item_ref = null

# warning-ignore:unused_signal
signal landed

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func drop_item() -> void:
	anim.play("Drop")
	#timer.start(5.0)

func spawn_item() -> void:
	match Global.current_level:
		1:
			
			var a = items[round(rand_range(0, items.size()-1))].instance()
			self.get_parent().add_child(a)
			#a.connect("tree_exiting", self, "remove_ref")
			#a.connect("dead", self, "drop_item")
			#item_ref = a
			a.global_position = global_position
		2:
			randomize()
			var a = burger.instance()
			self.get_parent().add_child(a)
			a.global_position = global_position

	self.call_deferred("queue_free")

func _on_Timer_timeout():
	drop_item()
	#timer.start(rand_range(5.0,8.0))

func sound_add() -> void:
	var a = sound.instance()
	get_parent().add_child(a)
	a.global_position = global_position

func _on_Hitbox_body_entered(body):
	if body.has_method("destroy"):
		body.destroy()

func use_shake() -> void:
	pass
