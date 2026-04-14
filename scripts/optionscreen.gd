extends Control

func _ready() -> void:
	var volume_actuel = AudioServer.get_bus_volume_db(0)
	$MarginContainer/VBoxContainer/VolumeSlider.value = volume_actuel
	print(volume_actuel)
	
	
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Titlescreen.tscn")


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
