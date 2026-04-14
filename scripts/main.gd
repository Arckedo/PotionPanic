extends Node

@onready var heart3 = $Heart/Heart3 
@onready var heart2 = $Heart/Heart2 
@onready var heart1 = $Heart/Heart1 


# --- Variables exposées pour l'éditeur ---
var current_hp = 3
@export var timer_duration : int = 60
@export var violence_increase_rate : float = 2.0
@export var violence_max : float = 100.0
@export var item_duration_increase : int = 10
@export var violence_decrease_on_item : int = 10
@export var violence : float = 20.0
# --- Variables internes ---
var timer : Timer = null
var violence_bar : ProgressBar = null
var time_bar : ProgressBar = null

func _ready():
	# Initialisation des nœuds enfants
	timer = $UI/Timer
	violence_bar = $UI/ViolenceBar
	time_bar = $UI/TimeBar
	
	# Initialisation des barres
	violence_bar.value = violence
	violence_bar.max_value = violence_max
	
	# Initialisation de la barre de temps
	time_bar.max_value = timer_duration
	time_bar.value = timer_duration
	

	# Démarrer le timer une seule fois
	if timer.is_stopped():  # Vérifie si le timer est arrêté avant de le démarrer
		timer.start(timer_duration)


func _process(delta):
	# Augmenter la violence
	violence += delta * violence_increase_rate
	violence_bar.value = violence
	current_hp = get_node("Player").hp
	_update_health()
	# Vérifier si la violence atteint la limite
	if violence >= violence_max:
		game_over("Violence trop élevée!")

	# Mettre à jour la barre de temps
	if not timer.is_stopped():  # Vérifie si le timer est actif
		time_bar.value = timer.time_left  # Mettre à jour avec le temps restant
	if time_bar.value < 0.1:  # Si le timer est écoulé mais que le joueur est encore en vie
		game_over("Timer écoulé, mais le joueur est encore en vie.")

func add_time(x: int):
	if timer.is_stopped():
		return  # Ne rien faire si le timer est déjà arrêté
	
	timer.start(timer.time_left + x)  # Ajouter x secondes au temps restant
	time_bar.value += x  # Mettre à jour la barre de temps

	print("Temps ajouté :", x, "secondes. Temps restant :", timer.time_left)

# Fonction pour la fin du jeu
func game_over(reason: String):
	# Arrêter le timer
	timer.stop()
	print("Game Over: " + reason)
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
	# Optionnellement afficher un écran de fin ici

func _update_health () : 
	if current_hp == 2 :
		heart3.visible = false 
	elif current_hp == 1 : 
		heart2.visible =false 
	elif current_hp == 0 :
		heart1.visible == false 
		game_over("Plus de hp")
