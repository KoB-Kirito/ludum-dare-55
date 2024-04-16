extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$ZaubererClean2.run()
	Bgm.fade_to(load("res://assets/audio/music/Dawn_of_the_Apocalypse.ogg"), -8, 2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
