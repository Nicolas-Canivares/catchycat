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
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
	else:
		# Patrulla
		var direction = (target_patrol_point.global_position - global_position).normalized()
		velocity = direction * speed

		if global_position.distance_to(target_patrol_point.global_position) < 10:
			if target_patrol_point == patrol_point_a:
				target_patrol_point = patrol_point_b
			else:
				target_patrol_point = patrol_point_a

	move_and_slide()

func _on_body_entered(body):
	if body.name == "Player":
		player = body
		player_in_sight = true
		has_seen_player = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_sight = false
