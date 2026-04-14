extends Node2D  # Ou le type de nœud parent que tu utilises pour Box

# Liste pour stocker les Box dans la scène
var boxes = []

func _ready():
	# Stocker toutes les boxes présentes dans la scène
	boxes = get_children()

	# Vérifier que chaque enfant est bien une Box
	for box in boxes:
		print("Vérification de l'enfant : ", box.name)
	
	# Échanger les positions des Box entre elles
	swap_boxes_positions()
	swap_boxes_positions()

# Fonction pour échanger les positions des boxes entre elles
func swap_boxes_positions():
	# S'assurer qu'il y a au moins deux boxes à échanger
	if boxes.size() >= 2:
		# Choisir deux boxes au hasard
		var box1 = boxes[randi() % boxes.size()]
		var box2 = boxes[randi() % boxes.size()]

		# S'assurer que box1 et box2 ne sont pas la même box
		while box1 == box2:
			box2 = boxes[randi() % boxes.size()]

		# Échanger les positions des deux boxes
		var temp_position = box1.position
		box1.position = box2.position
		box2.position = temp_position
		
		# Afficher les nouvelles positions des boxes
		print("Échange des positions : ", box1.name, " -> ", box1.position, ", ", box2.name, " -> ", box2.position)
