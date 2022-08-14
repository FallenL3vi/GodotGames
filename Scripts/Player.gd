extends KinematicBody2D

signal dead(player_number)

#After prototype move to global
export(String) var move_left_ac = "move_left"
export(String) var move_right_ac = "move_right"
export(String) var move_up_ac = "move_up"
export(String) var move_down_ac = "move_down"
export(String) var interact_ac = "interact"
export(int) var player_number = 1

onready var stats : Node2D = $Stats
onready var hand : Position2D = $Hand
onready var animPlayer : AnimationPlayer = $AnimationPlayer
onready var sprite : Sprite = $Sprite
onready var boom_sound = preload("res://Global/DeathAudio.tscn")

onready var sounds = {"pick" : $Sounds/Pick, "throw" : $Sounds/Throw}


var dir : Vector2 = Vector2.ZERO
var throw_dir : Vector2 = Vector2(1.0,0.0)
var velocity : Vector2 = Vector2.ZERO

var items = []
var hold_item = null

enum{
	IDLE,
	MOVE,
	THROW,
	DEAD
}

var state = IDLE


# Called when the node enters the scene tree for the first time.
func _ready():
	match player_number:
		1:
			sprite.texture = Global.texture_p1
		2:
			sprite.texture = Global.texture_p2
			sprite.flip_h = true

func go_idle() -> void:
	animPlayer.play("Idle")

func input() -> void:
	dir = Vector2.ZERO
	dir.x = Input.get_action_strength(move_right_ac) - Input.get_action_strength(move_left_ac)
	dir.y = Input.get_action_strength(move_down_ac) - Input.get_action_strength(move_up_ac)
	dir = dir.normalized()
	if dir.x != 0:
		throw_dir = dir
	if dir.x < 0:
		sprite.flip_h = true
	elif dir.x > 0:
		sprite.flip_h = false

func interaction() -> void:
	if Input.is_action_just_pressed(interact_ac):
		if hold_item == null:
			if items.size() > 0:
				hold_item = items[0]
				hold_item.get_parent().pick_up()
				sounds["pick"].play()
				items.remove(0)
		else:
			state = THROW

func throw_item() -> void:
	if is_instance_valid(hold_item):
		hold_item.get_parent().throw(Vector2(throw_dir.x,0.0))
		hold_item = null

func finish_throw() -> void:
	state = IDLE

func move() -> void:
	velocity = dir * Global.player_speed
	velocity = move_and_slide(velocity)

func dead() -> void:
	emit_signal("dead", player_number)
	var a = boom_sound.instance()
	a.global_position = global_position
	get_parent().add_child(a)
	self.call_deferred("queue_free")

func animation() -> void:
	if state != THROW and state != DEAD:
		if velocity != Vector2.ZERO:
			state = MOVE
		else:
			state = IDLE
	match state:
		IDLE:
			animPlayer.play("Idle")
		MOVE:
			animPlayer.play("Run")
		THROW:
			animPlayer.play("Throw")
		DEAD:
			animPlayer.play("Dead")

# warning-ignore:unused_argument
func _physics_process(delta):
	if !Global.pause:
		input()
		interaction()
		animation()
		if state != THROW and state != DEAD:
			move()
		if is_instance_valid(hold_item):
			if get_parent().has_node(hold_item.get_path()):
				hold_item.global_position = hand.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hurtbox_area_entered(area):
	if area.global_position.x < self.global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	stats.health -= area.damage


func _on_Detection_area_entered(area):
	items.append(area)


func _on_Detection_area_exited(area):
	items.erase(area)


func _on_Stats_no_health():
	state = DEAD
