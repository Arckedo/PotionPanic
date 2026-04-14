extends Control



func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")



func _on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Titlescreen.tscn")
