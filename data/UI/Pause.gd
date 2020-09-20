extends CanvasLayer

export (float) var minimum_value = -24
var default_master = -2
var default_SFX = -2
var default_music = -2

const CONFIG_FILE = "user://settings.cfg"

signal new_color
signal missing_config
var _config_file = ConfigFile.new()
var my_color = Color(1.0,1.0,1.0,1.0)

func _ready():
	$ColorRect.hide()
	$ColorRect/MasterControl.min_value = minimum_value
	$ColorRect/MusicControl.min_value = minimum_value
	$ColorRect/SFXControl.min_value = minimum_value
	$ColorRect/MasterControl/RichTextLabel.bbcode_text = "[center]Master[/center]"
	$ColorRect/MusicControl/RichTextLabel.bbcode_text = "[center]Music[/center]"
	$ColorRect/SFXControl/RichTextLabel.bbcode_text = "[center]SFX[/center]"
	set_settings()
	
func set_settings():
	AudioServer.set_bus_volume_db(0, $ColorRect/MasterControl.value)
	AudioServer.set_bus_volume_db(1, $ColorRect/MusicControl.value)
	AudioServer.set_bus_volume_db(2, $ColorRect/SFXControl.value)
	

func _on_MasterControl_value_changed(value):
	if value <= minimum_value:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
	AudioServer.set_bus_volume_db(0, lerp(AudioServer.get_bus_volume_db(0), value, 1.0))

func _on_MusicControl_value_changed(value):
	if value <= minimum_value:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
	AudioServer.set_bus_volume_db(1, lerp(AudioServer.get_bus_volume_db(1), value, 1.0))

func _on_SFXControl_value_changed(value):
	if value <= minimum_value:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
	AudioServer.set_bus_volume_db(2, lerp(AudioServer.get_bus_volume_db(2), value, 1.0))

func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = true

func _on_Windowed_toggled(button_pressed):
	OS.window_fullscreen = false

func _on_Quit_pressed():
	get_tree().quit()


func _on_ColorPicker_color_changed(color):
	emit_signal("new_color", color)
	my_color = color

func _on_Resume_pressed():
	$ColorRect.hide()
	get_tree().paused = false

func show_self():
	$ColorRect.show()
