extends Node3D


func _ready() -> void:
	Bgm.fade_to(load("res://assets/audio/music/Ancient_Rite.ogg"), -20.0, 2.0)
