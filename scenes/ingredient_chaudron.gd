extends Node2D

@export var ingredient_texture : Texture

func _ready():
	var ingredient = get_node("Sprite2D")  # Trouver le sprite "Ingredient"
	ingredient.texture = ingredient_texture  # Appliquer la texture
