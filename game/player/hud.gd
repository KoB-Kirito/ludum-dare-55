@tool
class_name Hud
extends CanvasLayer


@onready var crosshair: TextureRect = %Crosshair


func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)
		update_configuration_warnings()
		return
	
	Events.health_updated.connect(on_health_updated)
	Events.transformed_to_ghost.connect(on_transformed_to_ghost)
	Events.returned_to_host.connect(on_returned_to_host)


func _process(_delta: float) -> void:
	if %CountdownTimer.is_stopped():
		return
	
	%Countdown.text = "%20.2f" % %CountdownTimer.time_left


func on_transformed_to_ghost(duration: float) -> void:
	%Countdown.show()
	%CountdownTimer.start(duration)
	
	%GhostTint.show()


func on_returned_to_host() -> void:
	%Countdown.hide()
	
	%GhostTint.hide()


func on_health_updated(health: int) -> void:
	if health <= 1:
		%BloodEffect.show()
	else:
		%BloodEffect.hide()


#region "In-Engine"
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not owner == null and not owner is Player:
		warnings.append("Please delete me! I live inside the player now.")
	return warnings
#endregion
