extends Camera3D


@export var duration: float = 5.0
@export var pauses_player: bool = true
@export var pauses_game: bool = false

var player: Player


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	PauseMenu.game_paused.connect(on_game_paused)
	PauseMenu.game_unpaused.connect(on_game_unpaused)


func on_game_paused() -> void:
	if %Timer.is_stopped():
		return
	%Timer.paused = true

func on_game_unpaused() -> void:
	if %Timer.paused:
		%Timer.paused = false


func trigger() -> void:
	current = true
	if pauses_player:
		#TODO: Pause enemies too?
		player.paused = true
	if pauses_game:
		get_tree().paused = true
	%Timer.start(duration)


func _on_timer_timeout() -> void:
	current = false
	if pauses_game:
		get_tree().paused = false
	if pauses_player:
		player.paused = false
