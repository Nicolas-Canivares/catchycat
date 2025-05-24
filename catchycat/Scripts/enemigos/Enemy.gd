extends CharacterBody2D

@export var speed := 100.0
var player_in_sight := false
var has_seen_player := false
var player: Node2D = null

@onready var patrol_point_a: Node2D = get_parent().get_node("PatrolPointA")
@onready var patrol_point_b: Node2D = get_parent().get_node("PatrolPointB")

var target_patrol_point: Node2D

func _ready():
	target_patrol_point = patrol_point_b
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _physics_process(_delta):
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


func _on_body_entered(body):
	if body.name == "Jugador":
		if body.has_method("is_hidden_func") and body.is_hidden_func():
			return  # No lo detecta si está escondido
		player = body
		player_in_sight = true
		has_seen_player = true


func _on_body_exited(body):
	if body.name == "Jugador":
		player_in_sight = false
		
