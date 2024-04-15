class_name Enemy
extends CharacterBody3D


const GRAVITY: int = 200

@export var health: int = 6
@export var speed = 2
@export var hit_strength = 5
@export var waypoints: Array[Node3D]
## Time enemy follows player after losing them
@export var follow_time: float = 3.0

var start_pos
var start_rot

var player_in_range: bool = false
var seeing_player: bool = false:
	set(value):
		seeing_player = value
		if seeing_player:
			%LoseInterestTimer.stop()
		else:
			%LoseInterestTimer.start(follow_time)
var is_attacking: bool = false

var is_patroling: bool = false
var waypoint: int = 0

@onready var player: Player = get_tree().get_first_node_in_group("player")


func _ready():
	start_pos = self.position
	start_rot = self.rotation
	if !waypoints.is_empty():
		is_patroling = true


func _physics_process(delta):
	if global_position.y < -100:
		queue_free()
		return
	
	# look for player while in area
	if player_in_range:
		# check collision
		%RayCast.target_position = to_local(player.global_position)
		%RayCast.force_raycast_update()
		
		if %RayCast.is_colliding(): # can only collide with world due to mask
			if seeing_player:
				seeing_player = false
		else:
			seeing_player = true
			is_attacking = true
	elif seeing_player:
		seeing_player = false
	
	# movement
	if is_attacking:
		#look at player
		look_at(player.global_position, Vector3.UP)
		#move towards player
		velocity = Vector3.FORWARD * speed
		velocity = velocity.rotated(Vector3.UP, rotation.y)
		
	else:
		if is_patroling:
			# move to next waypoint
			var next_pos = waypoints[waypoint].global_position
			if global_position != next_pos:
				#back to guard post
				look_at(next_pos, Vector3.UP)
				velocity = Vector3.FORWARD * speed / 2.0
				velocity = velocity.rotated(Vector3.UP, rotation.y)
				if global_position.distance_to(next_pos) < 0.2:
					velocity = Vector3()
					position = next_pos
					waypoint = (waypoint + 1) % waypoints.size()
			
		else:
			# move back to start pos
			if global_position != start_pos:
				#back to guard post
				if global_position.distance_to(start_pos) < 0.2:
					velocity = Vector3()
					position = start_pos
					rotation = start_rot
					
				else:
					look_at(start_pos, Vector3.UP)
					velocity = Vector3.FORWARD * speed
					velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	#GRAVITY
	if not is_on_floor():
		velocity.y = velocity.y - (GRAVITY * delta)
	
	move_and_slide()


func _on_detection_zone_body_entered(body) -> void:
	if body is Player:
		player_in_range = true

func _on_detection_zone_body_exited(body):
	if body is Player:
		player_in_range = false


func _on_lose_interest_timer_timeout() -> void:
	is_attacking = false


func damage(amount):
	health -= amount
	if health <= 0:
		queue_free()

func _on_hit_zone_body_entered(body):
	if body is Player:
		body.damage(hit_strength)
		%HitTimer.start()

func _on_hit_zone_body_exited(body: Node3D) -> void:
	if body is Player:
		%HitTimer.stop()

func _on_hit_timer_timeout() -> void:
	player.damage(hit_strength)
