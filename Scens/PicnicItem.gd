extends StaticBody2D

onready var hitbox : Area2D = $Item/Hitbox
onready var dir : Vector2 = Vector2.ZERO
onready var sprite : Sprite = $Item/Sprite
onready var shadow : Sprite = $Item/Shadow
onready var pick_area : Area2D = $Item
onready var collision : CollisionShape2D = $StaticCollision

var throwed : bool = false
var picked : bool = false

var can_bounce : bool = false

enum item_type {
	BURGER,
	SANDWICH,
	MEAT,
	BUCKET,
	CHICKEN,
	WATER,
}


export(bool) var random = true
export(item_type) var item = item_type.BURGER;

signal dead

func _ready():
	$Item/CollisionShape2D.set_deferred("disabled", true)
	$Item/CollisionShape2D.set_deferred("disabled", false)
	
	if random:
		randomize()
		sprite.frame = int(round(rand_range(0, 5)))
	else:
		print(item)
		match item:
			item_type.BURGER:
				sprite.frame = 2
			item_type.MEAT:
				sprite.frame = 3
			item_type.SANDWICH:
				sprite.frame = 4
			item_type.CHICKEN:
				sprite.frame = 1
			item_type.WATER:
				sprite.frame = 0
			item_type.BUCKET:
				sprite.frame = 5

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
	emit_signal("dead")
	self.call_deferred("queue_free")

func destroy() -> void:
	hitbox.set_deferred("monitorable", false)
	hitbox.set_deferred("monitoring", false)
	throwed = false

func _on_VisibilityNotifier2D_screen_exited():
	#dir = -dir
	pass
	#emit_signal("dead")
	#queue_free()


func _on_VisibilityNotifier2D_viewport_exited(_viewport: Viewport) -> void:
	if !can_bounce:
		can_bounce = true
		dir = -dir
	else:
		emit_signal("dead")
		queue_free()
