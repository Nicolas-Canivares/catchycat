extends CharacterBody2D

@export var speed := 220.0
var player_in_sight := false
var has_seen_player := false
var player: Node2D = null

@onready var patrol_point_a: Node2D = get_parent().get_node("PatrolPointA")
@onready var patrol_point_b: Node2D = get_parent().get_node("PatrolPointB")

var target_patrol_point: Node2D
var is_stunned := false

var is_attacking := false
var parry_window := 0.3  # Tiempo en segundos donde se puede hacer el parry


func _ready():
	target_patrol_point = patrol_point_b
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _physics_process(_delta):
	if is_stunned:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if is_stunned:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	if not is_stunned:
		$AnimatedSprite2D.play("MovimientoEnemigo")

	if has_seen_player and player:
		if player.has_method("is_hidden_func") and player.is_hidden_func():
			# Si el jugador se esconde, dejar de seguirlo
			player = null
			has_seen_player = false
			player_in_sight = false
			return

		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		# Si está cerca, inicia ataque (abre ventana de parry)
		if global_position.distance_to(player.global_position) < 50:
			start_attack()

	else:
		# Patrullar entre puntos
		var direction = (target_patrol_point.global_position - global_position).normalized()
		velocity = direction * speed



		if global_position.distance_to(target_patrol_point.global_position) < 10:
			target_patrol_point = patrol_point_b if target_patrol_point == patrol_point_a else patrol_point_a

	move_and_slide()

	# Detección de parry
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Jugador":
			var jugador = collision.get_collider()
			if jugador.has_method("is_parrying_func") and jugador.is_parrying_func():
				quedar_aturdido()
				return

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

func quedar_aturdido():
	is_stunned = true
	velocity = Vector2.ZERO

	$AnimatedSprite2D.play("aturdido")
	$BodyCollision.disabled = true  # ← Se vuelve intangible

	await get_tree().create_timer(2.0).timeout

	is_stunned = false
	$BodyCollision.disabled = false  # ← Vuelve a ser sólido

	# Reanudar animación de movimiento si no está viendo al jugador
	if not has_seen_player:
		$AnimatedSprite2D.play("MovimientoEnemigo")


func start_attack():
	if is_stunned or is_attacking:
		return  # No atacar si está aturdido o ya atacando

	is_attacking = true
	velocity = Vector2.ZERO  # Detener movimiento
	$AnimatedSprite2D.play("ataque")
	print("¡Enemigo ataca!")

	await get_tree().create_timer(parry_window).timeout

	is_attacking = false
	$AnimatedSprite2D.play("IdleEnemigo")  # O cualquier animación de espera/patrullaje
	print("Ventana de parry cerrada")

	
func is_attacking_func() -> bool:
	return is_attacking
