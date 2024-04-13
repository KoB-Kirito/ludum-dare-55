class_name Hud
extends CanvasLayer


@onready var crosshair: TextureRect = %Crosshair


func start_countdown(duration: float) -> void:
	%Countdown.show()
	%CountdownTimer.start(duration)


func _process(delta: float) -> void:
	if %CountdownTimer.is_stopped():
		return
	
	%Countdown.text = "%20.2f" % %CountdownTimer.time_left


func _on_countdown_timer_timeout() -> void:
	%Countdown.hide()
