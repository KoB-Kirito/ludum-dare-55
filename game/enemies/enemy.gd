class_name Enemy
extends CharacterBody3D

@export var health: int = 6
@export var speed = 3

func _physics_process(_delta):
	move_and_slide()

func _on_detection_zone_body_entered(body) -> void:
	if body is Player:
		var player_pos = body.get_global_position()
		var enemy_pos = self.get_global_position()
		#look at player
		look_at_from_position(enemy_pos,player_pos,Vector3.UP)
		#move towards player
		velocity = Vector3.FORWARD * speed
		velocity = velocity.rotated(Vector3.UP, rotation.y)
