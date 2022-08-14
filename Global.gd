extends Node

var item_speed : int = 240

var player_speed : int = 90

var throw_mode : bool = true

var game_size : Vector2 = Vector2(208.0, 128.0)

var current_level : int = 1

onready var texture_p1 = preload("res://Sprites/playersprite2.png")
onready var texture_p2 = preload("res://Sprites/playersprite.png")

var pause = true

var score = {1 : 0, 2 : 0}
var all_score : int = 0
