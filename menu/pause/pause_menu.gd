extends CanvasLayer


signal game_paused
signal game_unpaused

## Pause menu can't be opened if disabled
var enabled: bool = true

var music_bus: int
var sounds_bus: int
var voices_bus: int

var title: String:
	get:
		return %TitleLabel.text
	set(value):
		%TitleLabel.text = value

@onready var default_title: String = %TitleLabel.text


func _ready() -> void:
	hide()
	
	music_bus = AudioServer.get_bus_index("Music")
	sounds_bus = AudioServer.get_bus_index("Sounds")
	voices_bus = AudioServer.get_bus_index("Voices")
	
	%MusicSlider.value = AudioServer.get_bus_volume_db(music_bus)
	%SoundsSlider.value = AudioServer.get_bus_volume_db(sounds_bus)
	%VoicesSlider.value = AudioServer.get_bus_volume_db(voices_bus)
	
	%FullscreenCheckBox.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, value)


func _on_sounds_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sounds_bus, value)


func _on_voices_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(voices_bus, value)


func _unhandled_input(event: InputEvent) -> void:
	if not enabled and not visible:
		return
	
	if event.is_action_pressed("pause"):
		toggle()
		return
	
	if visible and not event is InputEventMouse and event.is_pressed():
		if not %MusicSlider.has_focus() and \
				not %SoundsSlider.has_focus() and \
				not %VoicesSlider.has_focus():
			%MusicSlider.grab_focus()


func toggle() -> void:
	visible = !visible
	get_tree().paused = visible
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		game_paused.emit()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		%snd_music.stop()
		%snd_sounds.stop()
		%snd_voices.stop()
		game_unpaused.emit()


# play a sample when value is changed
func _on_music_slider_drag_started() -> void:
	%snd_sounds.stop()
	%snd_voices.stop()
	%snd_music.play()

func _on_sounds_slider_drag_started() -> void:
	%snd_music.stop()
	%snd_voices.stop()
	%snd_sounds.play()

func _on_voices_slider_drag_started() -> void:
	%snd_music.stop()
	%snd_sounds.stop()
	%snd_voices.play()


# close on click anywhere outside
func _on_fade_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		toggle()


func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
