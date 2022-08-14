extends Node2D

onready var settingsUI = $CanvasLayer/UIVideoSettings
onready var menuUI = $CanvasLayer/Menu

onready var timer = preload("res://Scens/Ui/Timer.tscn")
onready var level1 = preload("res://Scens/Level.tscn")
onready var level2 = preload("res://Scens/Level2.tscn")
onready var score_screen = preload("res://Scens/Levels/ScoreScreen.tscn")
var current_level = null
var current_round = 0
var stopper = null 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_setting(settings : Dictionary) -> void:
	OS.window_fullscreen = settings.fullscreen
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_IGNORE, 
	Vector2(240.0, 160.0)) 
	#settings.resolution)
	
	OS.set_window_size(settings.resolution)
	OS.vsync_enabled = settings.vsync


func _on_UIVideoSettings_apply_button_pressed(settings):
	update_setting(settings)


func _on_Menu_quit_game():
	get_tree().quit()


func _on_Menu_open_settings():
	menuUI.visible = false
	settingsUI.visible = true


func _on_UIVideoSettings_escape_settings():
	menuUI.visible = true
	settingsUI.visible = false


func _on_Menu_start_game():
	current_round = 1
	Global.pause = true
	stopper = timer.instance()
	$CanvasLayer.add_child(stopper)
	stopper.connect("start", self, "unpause")
	var n_game = level1.instance()
	self.add_child(n_game)
	n_game.connect("player_dead", self, "new_level")
	menuUI.visible = false
	current_level = n_game

func reset() -> void:
	get_node("ScoreScreen").queue_free()
	Global.all_score = 0
	Global.score[1] = 0
	Global.score[2] = 0
	current_round = 1
	Global.current_level = 1
	Global.pause = true
	stopper = timer.instance()
	$CanvasLayer.add_child(stopper)
	stopper.connect("start", self, "unpause")
	var n_game = level1.instance()
	self.add_child(n_game)
	n_game.connect("player_dead", self, "new_level")
	menuUI.visible = false
	current_level = n_game

func unpause():
	Global.pause = false

func new_level(player_number):
	yield(get_tree().create_timer(1.0), "timeout")
	Global.pause = true
	Global.item_speed = 240
	Global.player_speed = 90
	Global.score[player_number] += 1
	Global.all_score += 1
	if Global.all_score == 4:
		if Global.current_level != 2 and Global.current_level < 2:
			Global.current_level += 1
			current_level.call_deferred("queue_free")
			var a = level2.instance()
			self.add_child(a)
			a.connect("player_dead", self, "new_level")
			current_level = a
			stopper.play()
	elif Global.all_score == 7:
		var s = score_screen.instance()
		self.add_child(s)
		current_level.call_deferred("queue_free")
	else:
		current_level.call_deferred("queue_free")
		var a = null
		match Global.current_level:
			1:
				a = level1.instance()
			2:
				a = level2.instance()
		self.add_child(a)
		a.connect("player_dead", self, "new_level")
		current_level = a
		stopper.play()
