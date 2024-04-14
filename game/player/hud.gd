@tool
class_name Hud
extends CanvasLayer


@onready var crosshair: TextureRect = %Crosshair


func _process(_delta: float) -> void:
	if %CountdownTimer.is_stopped():
		return
	
	%Countdown.text = "%20.2f" % %CountdownTimer.time_left


func start_countdown(duration: float) -> void:
	%Countdown.show()
	%CountdownTimer.start(duration)
	
	%GhostTint.show()


func _on_countdown_timer_timeout() -> void:
	%Countdown.hide()
	
	%GhostTint.hide()


func on_health_updated(health: int) -> void:
	if health <= 1:
		%BloodEffect.show()


#region "In-Engine"
func _ready() -> void:
	Events.health_updated.connect(on_health_updated)
	
	if Engine.is_editor_hint():
		set_process(false)
		update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not owner == null and not owner is Player:
		warnings.append("Please delete me! I live inside the player now.")
	return warnings
#endregion
