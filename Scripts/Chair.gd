extends StaticBody2D
onready var hitbox : Area2D = $Item/Hitbox
onready var dir : Vector2 = Vector2.ZERO
onready var animPlayer : AnimationPlayer = $Item/AnimationPlayer
onready var sprite : Sprite = $Item/Sprite
onready var shadow : Sprite = $Item/Shadow
onready var pick_area : Area2D = $Item
onready var collision : CollisionShape2D = $StaticCollision

var throwed : bool = false
var picked : bool = false

signal dead


func _ready():
	$Item/CollisionShape2D.set_deferred("disabled", true)
	$Item/CollisionShape2D.set_deferred("disabled", false)

# Declare member variables here. Examples:
func pick_up() -> void:
	pick_area.set_deferred("monitorable", false)
	shadow.visible = false
	z_index = 1
	collision.disabled = true
	picked = true

func throw(new_dir : Vector2) -> void:
	hitbox.set_deferred("monitorable", true)
	hitbox.set_deferred("monitoring", true)
	dir = new_dir
	throwed = true

func _physics_process(delta):
	if throwed:
		if Global.throw_mode:
			global_position += delta * Global.item_speed * dir
		else:
			global_position += delta * Global.item_speed * dir
		sprite.rotate(0.5)


func _on_Hitbox_area_entered(_area):
	hitbox.set_deferred("monitorable", false)
	hitbox.set_deferred("monitoring", false)
	throwed = false
	animPlayer.play("Destroy")
	emit_signal("dead")

func destroy() -> void:
	hitbox.set_deferred("monitorable", false)
	hitbox.set_deferred("monitoring", false)
	throwed = false
	animPlayer.play("Destroy")


func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("dead")
	#print("wolo")
	queue_free()
