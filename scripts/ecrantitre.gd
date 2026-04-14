extends Control

func _ready() -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_option_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/optionscreen.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_tuto_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
