class_name Enemy
extends CharacterBody3D

@export var health: int = 6
@export var speed = 2
@export var hit_strength = 10
@export var waypoints: Array[Node3D]

var start_pos
var start_rot
var is_patroling: bool = false
var player
var is_attacking: bool = false
var waypoint: int = 0
var gravity: int = 200

func _ready():
	start_pos = self.position
	start_rot = self.rotation
	if !waypoints.is_empty():
		is_patroling = true

func _physics_process(delta):
	#enemy movement
	var enemy_pos = self.get_global_position()
	if is_attacking == true:
		var player_pos = player.get_global_position()
		#look at player
		look_at(player_pos,Vector3.UP)
		#move towards player
		velocity = Vector3.FORWARD * speed
		velocity = velocity.rotated(Vector3.UP, rotation.y)
		if $Mesh/RayCast3D.is_colliding():
			var collider = $Mesh/RayCast3D.get_collider()
			if collider is not Player:
				is_attacking = false
	else:
		if is_patroling:
			var next_pos = waypoints[waypoint].global_position
			if enemy_pos != next_pos:
				#back to guard post
				look_at(next_pos, Vector3.UP)
				velocity = Vector3.FORWARD * speed / 2.0
				velocity = velocity.rotated(Vector3.UP, rotation.y)
				if enemy_pos.distance_to(next_pos) < 0.2:
					velocity = Vector3()
					position = next_pos
					waypoint = (waypoint + 1) % waypoints.size()
		else:
			if enemy_pos != start_pos:
				#back to guard post
				if enemy_pos.distance_to(start_pos) < 0.2:
					velocity = Vector3()
					position = start_pos
					rotation = start_rot
				else:
					look_at(start_pos, Vector3.UP)
					velocity = Vector3.FORWARD * speed
					velocity = velocity.rotated(Vector3.UP, rotation.y)
	#gravity
	if not is_on_floor():
		velocity.y = velocity.y - (gravity * delta)
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
