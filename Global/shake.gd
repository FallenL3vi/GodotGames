extends Node

var camera_shake_intensity : float = 0.0
var camera_shake_duration : float = 0.0
var camera = null

enum Type {Random, Sine, Noise}
var camera_shake_type = Type.Random

var noise : OpenSimplexNoise

func _ready():
	#Generate noise
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20
	noise.persistence = 0.8

func shake(intensity, duration, type = Type.Random):
	#Set shake parameters
	#intensity = 0 if u don't want to shake
	
	if intensity > camera_shake_intensity and duration > camera_shake_duration:
		#if camera skae more intensif and longer duration then shake new
		camera_shake_duration = duration
		camera_shake_intensity = intensity
		camera_shake_type = type


func _process(delta):
	#var camera = get_tree().current_scene.get_node("Level").get_node("Camera")
	if camera != null:
			#Stop camera shaking if duration is down to zero
		if camera_shake_duration <= 0:
			camera.offset = Vector2.ZERO
			camera_shake_duration = 0.0
			camera_shake_intensity = 0.0
			return
		#Substract elapsed time from  shake duration
		camera_shake_duration -= delta
		var offset = Vector2.ZERO
		
		if camera_shake_type == Type.Random:
			offset = Vector2(randf(), randf()) * camera_shake_intensity
		
		if camera_shake_type == Type.Sine:
			#Sine wave based shake
			#Basing the sine wave off of get_ticks_msec ensures that the returned
			#value is continuous and smooth
			offset = Vector2(sin(OS.get_ticks_msec() * 0.03), sin(OS.get_ticks_msec() * 0.07)) * camera_shake_intensity * 0.5
		
		if camera_shake_type == Type.Noise:
			#Noise based shake
			#Same thing wit get_ticks_msec like above
			var noise_value_x = noise.get_noise_1d(OS.get_ticks_msec() * 0.1)
			var noise_value_y = noise.get_noise_1d(OS.get_ticks_msec() * 0.1 + 100.0)
			offset = Vector2(noise_value_x, noise_value_y) * camera_shake_intensity * 2.0
		
		camera.offset = offset
