extends Node2D

@onready var contact : Area2D = $Contact  # La zone où le joueur va entrer
var random_inventory = ["Champi", "Yeux", "Salade", "Mercure"]  # Inventaire global des ingrédients disponibles
var chaudron_inventory = []  # Liste des items sélectionnés pour le chaudron

func _ready():
	# Connecter les signaux de contact avec la zone
	contact.connect("body_entered", Callable(self, "_on_body_entered"))
	contact.connect("body_exited", Callable(self, "_on_body_exit"))
	
	# Générer l'inventaire du chaudron
	reset_chaudron()

func generate_chaudron_inventory():
	# Sélectionner aléatoirement entre 1 et 4 items
	var item_count = randi_range(1, 4)  # Nombre d'items aléatoire
	chaudron_inventory = random_inventory.duplicate()  # Copier la liste originale
	chaudron_inventory.shuffle()  # Mélanger les items
	chaudron_inventory = chaudron_inventory.slice(0, item_count)  # Garder seulement un certain nombre d'items
	
	print("Inventaire du chaudron : ", chaudron_inventory)  # Debug

func chaudron_visibility():
	for text in random_inventory :
		var item = get_node("RequestIngredient/"+text)
		item.visible = false

	for text in chaudron_inventory :
		var item = get_node("RequestIngredient/"+text)
		item.visible = true

func reset_chaudron():
	generate_chaudron_inventory()
	chaudron_visibility()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.enter_test_chaudron()
		print("ENTER - Inventaire chaudron : ", chaudron_inventory)

func _on_body_exit(body):
	if body.is_in_group("player"):
		body.exit_test_chaudron()
		print("SORTIE")
