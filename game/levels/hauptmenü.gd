extends Node3D


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Bgm.fade_to(load("res://assets/audio/music/Dasklingttoll.ogg"), -16, 2.0)
