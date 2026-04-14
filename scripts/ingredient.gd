extends Node2D

@export var rotation_speed : float = 90.0  # Vitesse de rotation en degrés par seconde
@export var radius : float = 50.0  # Distance à laquelle l'objet tourne autour du parent
@export var base_position : float = 0.0  # Position de départ sur le cercle (0-100%)
@export var ingredient_texture : Texture
var angle_offset : float = 0.0  # L'angle actuel de l'objet sur le cercle

func _ready():
	var ingredient = get_node("Sprite2D")  # Trouver le sprite "Ingredient"
	ingredient.texture = ingredient_texture  # Appliquer la texture
	# Calculer l'angle de départ à partir de base_position (0 à 100%)
	angle_offset = base_position * 3.6  # 100% correspond à 360°, donc on multiplie par 3.6

	# Initialiser la position de l'objet
	update_position()

func _process(delta):
	# Modifier l'angle de l'objet en fonction de la vitesse de rotation
	angle_offset += rotation_speed * delta
	if angle_offset >= 360.0:
		angle_offset -= 360.0  # Réinitialiser l'angle pour éviter qu'il devienne trop grand
	
	# Calculer la nouvelle position sur le cercle
	update_position()

func update_position():
	# Calculer la position de l'objet sur le cercle avec l'angle_offset
	var angle = deg_to_rad(angle_offset)  # Convertir l'angle en radians
	position = Vector2(radius * cos(angle), radius * sin(angle))  # Position sur le cercle
