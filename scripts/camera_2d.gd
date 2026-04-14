extends Camera2D

@export var follow_speed := 5.0  # Vitesse normale de transition
@export var switch_focus_speed := 2.0  # Vitesse de transition quand on change de focus
@export var offset_lerp_speed := 10.0  # Vitesse de lissage du décalage
@export var max_offset := Vector2(700, 700)  # Offset max du chaudron
@export var influence_distance := 300.0  # Distance pour recentrer sur le joueur

@export var min_zoom := 1.0  # Zoom max (quand proche du chaudron)
@export var max_zoom := 2.0  # Zoom minimum (quand loin)
@export var zoom_speed := 5.0  # Vitesse d'interpolation du zoom
@export var min_zoom_distance := 100.0  # Distance minimale où le zoom reste fixe

var target_offset := Vector2.ZERO  # Décalage appliqué
var offset_factor := 1.0  # 1 = caméra influencée par l'objet, 0 = centrée sur le joueur
var in_zone := false  # Indique si le joueur est dans une zone influente
var current_focus_obj = null  # L'objet influent actuel
var is_switching_focus := false  # Indique si un changement de focus est en cours

@onready var cauldron = get_parent() as Node2D  # Le chaudron
@onready var player = get_node_or_null("/root/Main/Player")  # Mets le bon chemin
@onready var influence_zones := []  # Liste des zones influentes

func _ready():
	# Récupère le nœud parent 'boxes'
	var scene_root = get_tree().current_scene
	var boxes = scene_root.get_node("Boxes")  # Trouve le nœud 'boxes'

	# Assure-toi que 'boxes' existe avant de continuer
	if boxes:
		# Parcourt tous les enfants de 'boxes'
		for obj in boxes.get_children():
			if obj.has_node("ZoneCamera"):  # Vérifie si l'objet a une zone caméra
				var zone = obj.get_node("ZoneCamera")
				zone.body_entered.connect(func(body): _on_body_entered(body, obj))
				zone.body_exited.connect(func(body): _on_body_exited(body, obj))
				influence_zones.append(obj)


func _on_body_entered(body, obj):
	if body == player:
		in_zone = true
		if current_focus_obj != obj:
			is_switching_focus = true  # Active le ralentissement de transition
		current_focus_obj = obj  
		offset_factor = 0.0  # La caméra se recentre immédiatement sur l'objet

func _on_body_exited(body, obj):
	if body == player and current_focus_obj == obj:
		in_zone = false
		current_focus_obj = null
		offset_factor = 1.0  # La caméra suit à nouveau le joueur progressivement

func _process(delta):
	if not player:
		return

	# Détermine l'objet influent actuel
	var focus_obj = cauldron if current_focus_obj == null else current_focus_obj
	var distance = player.global_position.distance_to(focus_obj.global_position)

	# Si le joueur est proche, recentre totalement la caméra
	if distance < influence_distance:
		offset_factor = move_toward(offset_factor, 0.0, offset_lerp_speed * delta)
	else:
		offset_factor = move_toward(offset_factor, 1.0, offset_lerp_speed * delta)

	# Calcul du décalage dynamique
	var direction = (player.global_position - focus_obj.global_position).normalized()
	var desired_offset = Vector2(
		clamp(direction.x * max_offset.x, -max_offset.x, max_offset.x),
		clamp(direction.y * max_offset.y, -max_offset.y, max_offset.y)
	) * offset_factor

	# Interpolation fluide du décalage
	target_offset = lerp(target_offset, desired_offset, follow_speed * delta)

	# Gestion du zoom dynamique
	var zoom_factor = clamp((distance - min_zoom_distance) / (influence_distance - min_zoom_distance), 0.0, 1.0)
	var target_zoom = lerp(min_zoom, max_zoom, zoom_factor)
	zoom = lerp(zoom, Vector2(target_zoom, target_zoom), zoom_speed * delta)

	# Ralentit la transition si on change de focus
	var transition_speed = switch_focus_speed if is_switching_focus else follow_speed
	global_position = lerp(global_position, focus_obj.global_position + target_offset, transition_speed * delta)

	# Désactive le ralentissement une fois la transition terminée
	if is_switching_focus and global_position.distance_to(focus_obj.global_position + target_offset) < 10.0:
		is_switching_focus = false
