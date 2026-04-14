extends Control

var paused = false
func _ready() -> void:
	hide()



func toggle_pause():
	var volume_actuel = AudioServer.get_bus_volume_db(0)
	if paused:
		Engine.time_scale = 1
		hide()  # Masquer le menu pause
		InputMap.load_from_project_settings()
		Input.action_release("ui_left")
		Input.action_release("ui_right")
		Input.action_release("ui_up")
		Input.action_release("ui_down")
		AudioServer.set_bus_volume_db(0,volume_actuel+10)
	else:
		Engine.time_scale = 0
		InputMap.action_erase_events("ui_left")
		InputMap.action_erase_events("ui_right")
		InputMap.action_erase_events("ui_up")
		InputMap.action_erase_events("ui_down")
		show()  # Afficher le menu pause*
		AudioServer.set_bus_volume_db(0,volume_actuel-10)
		
	paused = !paused
		
func _process(delta: float) -> void:  # Vérifie les entrées et réagit à "Échap"
	if Input.is_action_just_pressed("ui_cancel"):  # "ui_cancel" est lié à Échap par défaut
		toggle_pause()


func _on_resume_button_pressed() -> void:
	Engine.time_scale = 1
	hide()  # Masquer le menu pause
	InputMap.load_from_project_settings()

func _on_back_to_menu_button_pressed() -> void:
	Engine.time_scale = 1
	hide()
	get_tree().change_scene_to_file("res://Scenes/Titlescreen.tscn")
	InputMap.load_from_project_settings()
	InputMap.load_from_project_settings()
	Input.action_release("ui_left")
	Input.action_release("ui_right")
	Input.action_release("ui_up")
	Input.action_release("ui_down")
