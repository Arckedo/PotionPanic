extends Area2D

@export var spawn_object: PackedScene
@export var spawn_chance: float = 0.05  # 5% de chance de spawn
@export var spawn_timer: Timer  # Timer pour contrôler le spawn
@export var spawn_radius: float = 100  # Rayon de spawn si pas de CollisionShape2D

func _ready():
	if spawn_timer:
		spawn_timer.timeout.connect(try_spawn)
		spawn_timer.start()
	else:
		print("Erreur: spawn_timer est NULL")

func try_spawn():
	if randf() < spawn_chance * (get_parent().violence/100) :
		print("Tentative de spawn...")
		var pos = get_valid_spawn_position()
		if pos:
			if spawn_object:
				var instance = spawn_object.instantiate()
				instance.position = pos
				get_parent().add_child(instance)

				# Appliquer l'effet de clignotement et bloquer le mouvement
				start_spawn_effect(instance)

				print("Spawn réussi à :", pos)
			else:
				print("Erreur: spawn_object est NULL")
		else:
			print("Aucune position valide trouvée.")

	spawn_timer.start()

func get_valid_spawn_position():
	var attempts = 10
	var shape_extents = get_shape_extents()

	while attempts > 0:
		var spawn_pos = global_position + Vector2(
			randf_range(-shape_extents.x + 10, shape_extents.x - 10),  # Décalage
			randf_range(-shape_extents.y + 10, shape_extents.y - 10)
		)

		if is_position_valid(spawn_pos):
			return spawn_pos

		attempts -= 1

	print("Aucune position libre après plusieurs essais.")
	return null

func is_position_valid(pos: Vector2) -> bool:
	for body in get_tree().get_nodes_in_group("no-spawn"):
		if body.global_position.distance_to(pos) < 40:  # Augmente la distance de sécurité
			print("Position invalide, trop proche d'un objet interdit")
			return false
	return true

func get_shape_extents() -> Vector2:
	for child in get_children():
		if child is CollisionShape2D:
			var shape = child.shape
			if shape is RectangleShape2D:
				return shape.extents
			elif shape is CircleShape2D:
				return Vector2(shape.radius, shape.radius)
	
	return Vector2(spawn_radius, spawn_radius)  # Valeur par défaut

func start_spawn_effect(instance):
	if instance.has_method("set_physics_process"):
		instance.set_physics_process(false)  # Désactive le mouvement

	# Créer un Tween pour faire clignoter l'opacité
	var tween = instance.create_tween()
	tween.tween_property(instance, "modulate:a", 0, 0.2)
	tween.tween_property(instance, "modulate:a", 1, 0.2)
	tween.tween_property(instance, "modulate:a", 0, 0.2)
	tween.tween_property(instance, "modulate:a", 1, 0.2)
	tween.tween_property(instance, "modulate:a", 0, 0.2)
	tween.tween_property(instance, "modulate:a", 1, 0.2)
	tween.tween_property(instance, "modulate:a", 0, 0.2)
	tween.tween_property(instance, "modulate:a", 1, 0.2)
	tween.tween_property(instance, "modulate:a", 0, 0.2)
	tween.tween_property(instance, "modulate:a", 1, 0.2)
	tween.tween_property(instance, "modulate:a", 0, 0.2)
	tween.tween_property(instance, "modulate:a", 1, 0.2)
	# Créer un Timer pour réactiver le mouvement après 2 secondes
	var wait_timer = Timer.new()
	wait_timer.wait_time = 3
	wait_timer.one_shot = true
	wait_timer.timeout.connect(func():
		if instance.has_method("set_physics_process"):
			instance.set_physics_process(true)  # Réactive le mouvement
		instance.modulate.a = 1  # Assure que l'opacité est bien restaurée
		wait_timer.queue_free()  # Supprime le Timer après usage
	)
	instance.add_child(wait_timer)
	wait_timer.start()
