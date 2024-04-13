class_name Player
extends CharacterBody3D


signal health_updated


@export var hud:Hud
@export var death_height: int = -15

@export_subgroup("Properties")
@export var movement_speed = 5
@export var jump_strength = 8

@export_subgroup("Weapons")
@export var weapons: Array[Weapon] = []
@export var impact_scene: PackedScene
@export var portal_scene: PackedScene

var weapon: Weapon
var weapon_index := 0

var mouse_sensitivity = 700
var gamepad_sensitivity := 0.075

var mouse_captured := true

var movement_velocity: Vector3
var rotation_target: Vector3

var input_mouse: Vector2

var health:int = 100
var gravity := 0.0

var previously_floored := false

var jump_single := true
var jump_double := true

var container_offset = Vector3(1.2, -1.1, -2.75)

var tween:Tween


# Functions

func _ready():
	PauseMenu.game_paused.connect(on_game_paused)
	PauseMenu.game_unpaused.connect(on_game_unpaused)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#weapon = weapons[weapon_index] # Weapon must never be nil
	initiate_change_weapon(weapon_index)

func _physics_process(delta):
	
	# Handle functions
	
	handle_controls(delta)
	handle_gravity(delta)
	
	# Movement

	var applied_velocity: Vector3
	
	movement_velocity = transform.basis * movement_velocity # Move forward
	
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	velocity = applied_velocity
	move_and_slide()
	
	# Rotation
	
	%Camera.rotation.z = lerp_angle(%Camera.rotation.z, -input_mouse.x * 25 * delta, delta * 5)	
	
	%Camera.rotation.x = lerp_angle(%Camera.rotation.x, rotation_target.x, delta * 25)
	rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)
	
	%Container.position = lerp(%Container.position, container_offset - (basis.inverse() * applied_velocity / 30), delta * 10)
	
	# Movement sound
	
	%snd_footsteps.stream_paused = true
	
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			%snd_footsteps.stream_paused = false
	
	# Landing after jump or falling
	
	%Camera.position.y = lerp(%Camera.position.y, 0.0, delta * 5)
	
	if is_on_floor() and gravity > 1 and !previously_floored: # Landed
		#Audio.play("sounds/land.ogg")
		%Camera.position.y = -0.1
	
	previously_floored = is_on_floor()
	
	# Falling/respawning
	
	if position.y < death_height:
		get_tree().reload_current_scene()


# Mouse capture
func on_game_unpaused() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_captured = true

func on_game_paused() -> void:
	mouse_captured = false
	input_mouse = Vector2.ZERO


# Mouse movement
func _input(event):
	if event is InputEventMouseMotion and mouse_captured:
		
		input_mouse = event.relative / mouse_sensitivity
		
		rotation_target.y -= event.relative.x / mouse_sensitivity
		rotation_target.x -= event.relative.y / mouse_sensitivity

func handle_controls(_delta):
	# Movement
	
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	movement_velocity = Vector3(input.x, 0, input.y).normalized() * movement_speed
	
	# Rotation
	
	var rotation_input := Input.get_vector("camera_right", "camera_left", "camera_down", "camera_up")
	
	rotation_target -= Vector3(-rotation_input.y, -rotation_input.x, 0).limit_length(1.0) * gamepad_sensitivity
	rotation_target.x = clamp(rotation_target.x, deg_to_rad(-90), deg_to_rad(90))
	
	# Shooting
	
	action_shoot()
	
	# Jumping
	
	if Input.is_action_just_pressed("jump"):
		if jump_strength <= 0:
			return
		
		if jump_single or jump_double:
			%snd_jump.play()
		
		if jump_double:
			
			gravity = -jump_strength
			jump_double = false
			
		if(jump_single): action_jump()
		
	# Weapon switching
	
	action_weapon_toggle()

# Handle gravity

func handle_gravity(delta):
	
	gravity += 20 * delta
	
	if gravity > 0 and is_on_floor():
		
		jump_single = true
		gravity = 0

# Jumping

func action_jump():
	
	gravity = -jump_strength
	
	jump_single = false;
	jump_double = true;

# Shooting

func action_shoot():
	
	if Input.is_action_pressed("shoot"):
	
		if !%Cooldown.is_stopped():
			return # Cooldown for shooting
		
		%snd_shoot.play()
		
		%Container.position.z += 0.25 # Knockback of weapon visual
		%Camera.rotation.x += 0.025 # Knockback of %Camera
		#movement_velocity += Vector3(0, 0, weapon.knockback) # Knockback
		
		# Set %Muzzle flash position, play animation
		
		%Muzzle.play("default")
		
		%Muzzle.rotation_degrees.z = randf_range(-45, 45)
		%Muzzle.scale = Vector3.ONE * randf_range(0.40, 0.75)
		%Muzzle.position = %Container.position - weapon.muzzle_position
		
		%Cooldown.start(weapon.cooldown)
		
		# Shoot the weapon, amount based on shot count
		
		for n in weapon.shot_count:
		
			%RayCast.target_position.x = randf_range(-weapon.spread, weapon.spread)
			%RayCast.target_position.y = randf_range(-weapon.spread, weapon.spread)
			
			%RayCast.force_raycast_update()
			
			if !%RayCast.is_colliding():
				continue # Don't create impact when %RayCast didn't hit
			
			var collider = %RayCast.get_collider()
			var collision_point = %RayCast.get_collision_point()
			
			# Hitting an enemy
			
			if collider.has_method("damage"):
				collider.damage(weapon.damage)
			
			# Creating an impact animation
			
			var impact = impact_scene.instantiate()
			
			impact.play("shot")
			
			get_tree().root.add_child(impact)
			
			impact.position = collision_point + (%RayCast.get_collision_normal() / 10)
			impact.look_at(%Camera.global_transform.origin, Vector3.UP, true)
			
			# Portal
			
			var portal = portal_scene.instantiate()
			portal.look_at(collision_point - (%RayCast.get_collision_normal()))

# Toggle between available weapons (listed in 'weapons')

func action_weapon_toggle():
	
	if Input.is_action_just_pressed("weapon_toggle"):
		
		weapon_index = wrap(weapon_index + 1, 0, weapons.size())
		initiate_change_weapon(weapon_index)
		
		%snd_weapon_change.play()

# Initiates the weapon changing animation (tween)

func initiate_change_weapon(index):
	
	weapon_index = index
	
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(%Container, "position", container_offset - Vector3(0, 1, 0), 0.1)
	tween.tween_callback(change_weapon) # Changes the model

# Switches the weapon model (off-screen)

func change_weapon():
	
	weapon = weapons[weapon_index]

	# Step 1. Remove previous weapon model(s) from %Container
	
	for n in %Container.get_children():
		%Container.remove_child(n)
	
	# Step 2. Place new weapon model in %Container
	
	var weapon_model = weapon.model.instantiate()
	%Container.add_child(weapon_model)
	
	weapon_model.position = weapon.position
	weapon_model.rotation_degrees = weapon.rotation
	
	# Step 3. Set model to only render on layer 2 (the weapon %Camera)
	
	for child in weapon_model.find_children("*", "MeshInstance3D"):
		child.layers = 2
		
	# Set weapon data
	
	%RayCast.target_position = Vector3(0, 0, -1) * weapon.max_distance
	hud.crosshair.texture = weapon.crosshair


func damage(amount):
	
	health -= amount
	health_updated.emit(health) # Update health on HUD
	
	if health < 0:
		get_tree().reload_current_scene() # Reset when out of health
