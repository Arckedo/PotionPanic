extends CharacterBody2D

func _ready():
	add_to_group("player")
	$InvincibilityTimer.wait_time = inv_time
	$InvincibilityTimer.connect("timeout", Callable(self, "_on_invincibility_timer_timeout"))
var inv_time = 0.5
var inv = false
var is_addable_item = false
var is_chaudron = false
var ingredient = ""
var inventory = []
var inventory_chaudron = []
var hp = 3
@export var max_speed: float = 200.0
@export var dash_duration: float = 0.2  # Durée du dash en secondes
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D  # Récupération du sprite animé

var dash_time_left: float = 0.0  # Temps restant pour le dash

# Fonction de déplacement

# Fonction de déplacement
func _physics_process(delta: float) -> void:
	var input_direction = Vector2(
	Input.get_axis("ui_left", "ui_right"),
	Input.get_axis("ui_up", "ui_down")
	).normalized()

	# Si le joueur appuie sur shift et que le dash est activé
	if dash_time_left > 0:
	# Appliquer la vitesse de dash
		velocity = input_direction * 2*max_speed
		dash_time_left -= delta  # Réduire le temps restant du dash
		sprite.play("run")  # Animation de course pendant le dash
	else:
		# Si pas en dash, on applique la vitesse normale
		if input_direction != Vector2.ZERO:
			velocity = input_direction * max_speed
			sprite.play("run")
		else:
			velocity = Vector2.ZERO  # Arrêt immédiat
			sprite.play("idle")  # Animation d'attente

	# Flip du sprite selon la direction horizontale
	if input_direction.x != 0:
		sprite.flip_h = input_direction.x < 0  # Retourne le sprite si va à gauche

	# Appliquer le mouvement
	move_and_slide()


func trigger_dash():
	if dash_time_left <= 0:  # Si on n'est pas en train de dash
		dash_time_left = dash_duration  # Redémarrer le temps du dash
		print("Dash activé!")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_shift"):  # Vérifie si Shift est appuyé une seule fois
		trigger_dash()

	if is_addable_item == true :
		if Input.is_action_pressed("ui_accept"):
			if ingredient not in inventory:
				inventory.append(ingredient)
				print("Item ajouté à l'inventaire : add item :", ingredient)
	
	if is_chaudron == true :
		if Input.is_action_pressed("ui_accept"):
			test_chaudron()
	
	for text in inventory :
		var item = get_node(text)
		item.visible = true
		
# Ajouter un item à l'inventaire
func addable_item(ingredient_str: String):
	if ingredient not in inventory:  # Eviter les doublons
		ingredient = ingredient_str
		is_addable_item = true
	else :
		ingredient = ""
		is_addable_item = false

func exit_item_zone(ingredient_str: String):
	is_addable_item = false 
	ingredient = ""

# Supprimer un item de l'inventaire
func test_chaudron():
	var main = get_parent()
	var chaudron =  main.get_node("Chaudron")
	inventory_chaudron = chaudron.chaudron_inventory
	print(inventory_chaudron)
	print(inventory)
	inventory.sort()
	inventory_chaudron.sort()
	if inventory_chaudron == inventory :
		print("HUUUUUUUUUUUUU")
		#APPEL FONCTION QUI CREER DE NOUVEAUX ITEMS ET BAISSE LE TIMER
		chaudron.reset_chaudron()
		inventory_chaudron = chaudron.chaudron_inventory
		main.add_time(5)
	if inventory.size() > 0:
		for text in inventory:
			var item = get_node(text)
			item.visible = false 
		inventory.clear()
		print("Inventaire vidé")


func die():
	# main.game_over("Tu t'es fait tabasser a mort !!")
	pass



func enter_test_chaudron():
	is_chaudron = true

func exit_test_chaudron():
	is_chaudron = false

func take_damage(amount):
	if inv == true :
		return 0
	hp -= amount
	print("Ouch ! Vie restante :", hp)
	activate_invincibility()
	if hp <= 0:	
		die()

func activate_invincibility():
	inv = true
	$InvincibilityTimer.start()  # Démarre le timer d'invincibilité
	start_blinking()

func _on_invincibility_timer_timeout() -> void:
	inv = false  # Fin de l'invincibilité
	stop_blinking()

func start_blinking():
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1, 0.3), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1, 1), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.set_loops(10)

func stop_blinking():
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
