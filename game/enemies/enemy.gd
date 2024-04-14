class_name Enemy
extends CharacterBody3D

@export var health: int = 6
@export var speed = 2
@export var hit_strength = 10

var start_pos
var start_rot
var is_attacking: bool = false
var player

func _ready():
	start_pos = self.position
	start_rot = self.rotation

func _physics_process(_delta):
	#enemy movement
	var enemy_pos = self.get_global_position()
	if is_attacking == true:
		var player_pos = player.get_global_position()
		#look at player
		look_at_from_position(enemy_pos,player_pos,Vector3.UP)
		#move towards player
		velocity = Vector3.FORWARD * speed
		velocity = velocity.rotated(Vector3.UP, rotation.y)
		if $Mesh/RayCast3D.is_colliding():
			var collider = $Mesh/RayCast3D.get_collider()
			if collider is not Player:
				is_attacking = false
	if is_attacking == false and enemy_pos != start_pos:
		#back to guard post
		look_at_from_position(enemy_pos, start_pos, Vector3.UP)
		velocity = Vector3.FORWARD * speed
		velocity = velocity.rotated(Vector3.UP, rotation.y)
		if enemy_pos.distance_to(start_pos) < 0.2:
			velocity = Vector3()
			position = start_pos
			rotation = start_rot
	move_and_slide()

func _on_detection_zone_body_entered(body) -> void:
	if body is Player:
		player = body
		is_attacking = true

func _on_detection_zone_body_exited(body):
	if body is Player:
		is_attacking = false

func damage(amount):
	health -= amount
	if health <= 0:
		queue_free()

func _on_hit_zone_body_entered(body):
	if body is Player:
		body.damage(hit_strength)
