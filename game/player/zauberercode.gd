extends Node3D

func run():
	%AnimationPlayer.play("run")
	
func idle():
	%AnimationPlayer.play("idle")
