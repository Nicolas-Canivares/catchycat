extends CharacterBody2D

@export var speed := 220.0
var player_in_sight := false
var has_seen_player := false
var player: Node2D = null

@onready var patrol_point_a: Node2D = get_parent().get_node("PatrolPointA")
@onready var patrol_point_b: Node2D = get_parent().get_node("PatrolPointB")

var target_patrol_point: Node2D

var can_catch_player := true
var is_waiting_after_release := false


func _ready():
	target_patrol_point = patrol_point_b
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	if get_parent().has_node("Jugador"):
		var jugador_node = get_parent().get_node("Jugador")
		jugador_node.connect("jugador_liberado", Callable(self, "_on_jugador_liberado"))


func _physics_process(_delta):
	if is_waiting_after_release:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	if has_seen_player and player:
		if player.has_method("is_hidden_func") and player.is_hidden_func():
			# Si se esconde, dejar de seguirlo
			player = null
			has_seen_player = false
			player_in_sight = false
			return

		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
	else:
		# Patrullar entre puntos
		var direction = (target_patrol_point.global_position - global_position).normalized()
		velocity = direction * speed
		$AnimatedSprite2D.play("MovimientoEnemigo")

		if global_position.distance_to(target_patrol_point.global_position) < 10:
			target_patrol_point = patrol_point_b if target_patrol_point == patrol_point_a else patrol_point_a

	move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Jugador" and can_catch_player:
			var jugador = collision.get_collider()
			if jugador.has_method("is_trapped_func") and not jugador.is_trapped_func():
				if jugador.has_method("trap_player"):
					jugador.trap_player()



func _on_body_entered(body):
	if body.name == "Jugador":
		if body.has_method("is_hidden_func") and body.is_hidden_func():
			return
		player = body
		player_in_sight = true
		has_seen_player = true
		




func _on_body_exited(body):
	if body.name == "Jugador":
		player_in_sight = false
		
func _on_jugador_liberado():
	can_catch_player = false
	is_waiting_after_release = true
	velocity = Vector2.ZERO  # se queda quieto

	# Activar parpadeo visual en el jugador
	if player and player.has_method("empezar_intangibilidad_durante"):
		player.empezar_intangibilidad_durante(1.5)

	await get_tree().create_timer(1.5).timeout
	can_catch_player = true
	is_waiting_after_release = false


		
