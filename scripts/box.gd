extends Node2D

@export var item_name : String  # Le nom de l'item associé à cette zone, par exemple "Champi"

@onready var zone_ingredient : Area2D = $ZoneIngredient  # La zone où le joueur va entrer
@export var ingredient_texture : Texture  # La texture à appliquer à l'ingrédient

# Paramètres de taille et d'offset pour les textures
var min_scale = 0.2  # Taille minimale de l'échelle
var max_scale = 0.3  # Taille maximale de l'échelle
var max_offset = 0  # Déplacement maximum de l'offset (en pixels)

func _ready():
	# Assigner la texture à l'ingrédient
	var ingredient = get_node("Ingredient")  # Trouver le sprite "Ingredient"
	ingredient.texture = ingredient_texture  # Appliquer la texture

	# Modifier la taille (échelle) du sprite de manière aléatoire
	var scale_factor = randf_range(min_scale, max_scale)  # Taille aléatoire
	ingredient.scale = Vector2(scale_factor, scale_factor)

	# Modifier l'offset du sprite de manière aléatoire
	var offset_x = randf_range(-max_offset, max_offset)  # Décalage horizontal
	var offset_y = randf_range(-max_offset, max_offset)  # Décalage vertical
	ingredient.offset = Vector2(offset_x, offset_y)

	# Connecter le signal "body_entered" de l'Area2D avec une méthode anonyme
	zone_ingredient.connect("body_entered", Callable(self, "_on_body_entered"))
	zone_ingredient.connect("body_exited", Callable(self, "_on_body_exit"))
	
# Fonction appelée lorsque le joueur entre dans la zone
func _on_body_entered(body: Node):
	# Vérifier si le corps entrant est bien un joueur (qu'il fait partie du groupe "player")
	if body.is_in_group("player"):
		# Ajouter l'item à l'inventaire du joueur
		body.addable_item(item_name)
		print("ENTER")

func _on_body_exit(body : Node):
	if body.is_in_group("player"):
		# Ajouter l'item à l'inventaire du joueur
		body.exit_item_zone(item_name)
		print("EXIT")
