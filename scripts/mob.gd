extends CharacterBody2D  # Permet le mouvement du mob

@export var speed = 1000  # Vitesse du mob
var direction = Vector2.ZERO  # La direction du mouvement

func _ready():
	$Area2D.connect("body_entered", Callable(self, "_on_player_detected"))

func _on_player_detected(body):
	if body.is_in_group("player"):  # Vérifie si c'est bien le joueur
		direction = (body.global_position - global_position).normalized()  # Fixe la direction
		print("Joueur détecté ! Le mob attaque !")

func _physics_process(delta):
	if direction != Vector2.ZERO:
		# Utilisation de move_and_collide pour détecter les collisions
		var collision = move_and_collide(direction * speed * delta)

		if collision:
			var collider = collision.get_collider()

			# Ignorer les collisions avec d'autres mobs
			if collider.is_in_group("mob"):
				return  # Ne rien faire, traverser les autres mobs

			# Si le mob touche le joueur, il inflige 40 dégâts et se supprime
			if collider.is_in_group("player"):
				collider.take_damage(1)
				queue_free()  # Supprime le mob

			# Si le mob touche un mur (StaticBody2D), il se supprime
			elif collider.is_in_group("wall"):  # Vérifie que c'est un mur
				print("Le mob a touché un mur.")
				queue_free()  # Supprime le mob
