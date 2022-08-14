extends Node2D

signal player_dead(player_number)
signal shake

onready var drop : PackedScene = preload("res://Scens/Drop.tscn")
onready var sort : YSort = $YSort
onready var timer : Timer = $Timer
onready var stopper = preload("res://Scens/Ui/Timer.tscn")
onready var muttator = $Mutator 
onready var mutator_timer := $Mutator_Timer

var camera : Camera2D = null

var drop_range : Vector2 = Vector2(1.0, 3.0)

var first_spawn : bool = true

var effect_number : int = 0

func _ready():
	camera = get_node("Camera")
# warning-ignore:return_value_discarded
	self.connect("shake", camera, "shake")
	#For testing
	#Global.pause = false

func spawn() -> void:
	if !Global.pause:
		randomize()
		var a = drop.instance()
		self.sort.add_child(a)
		a.global_position = Vector2(rand_range(-(Global.game_size.x/2), Global.game_size.x/2),
		rand_range(-(Global.game_size.y/2), Global.game_size.y/2))
		a.connect("landed", camera, "shake")
		a.drop_item()
		#first_spawn = false
	timer.start(rand_range(drop_range.x, drop_range.y))
	#for turn in range(2):
	#	var item = items[round(rand_range(0.0,items.size()-1))]
	#	drops[turn].item = item
	#	drops[turn].drop_item()
	#	first_spawn = false

# warning-ignore:unused_argument
func _process(delta):
	#if Input.is_action_just_pressed("debug"):
	#	var a = stopper.instance()
	#	self.add_child(a)
	#	a.connect("start", self, "start_draw")
	pass

func _on_Timer_timeout():
	spawn()


func _on_Player_dead(player_number):
	emit_signal("shake")
	emit_signal("player_dead", player_number)


func start_draw() -> void:
	Global.pause = true
	if is_instance_valid($YSort/Player) and is_instance_valid($YSort/Player2):
		$YSort/Player.go_idle()
		$YSort/Player2.go_idle()
	muttator.which = randi() % 2 + 1
	effect_number = randi() % 3 + 1
	muttator.effect = effect_number
	muttator.play()

func _on_Mutator_draw_finished():
	match effect_number:
		1:
			Global.player_speed += 40
		2:
			Global.item_speed += 240
		3:
			drop_range = Vector2(0.1, 0.3)
	print(effect_number)
	Global.pause = false


func _on_Mutator_Timer_timeout() -> void:
	start_draw()
