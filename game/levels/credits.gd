extends Node3D


func _ready() -> void:
	Bgm.fade_to(load("res://assets/audio/music/end-angelic.ogg"), -8, 3.0)
