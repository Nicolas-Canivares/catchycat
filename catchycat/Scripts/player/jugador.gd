extends CharacterBody2D

@export var speed := 200  # Velocidad de movimiento

var direction := Vector2.ZERO


func _physics_process(delta):
	direction = Vector2.ZERO

	# Movimiento
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
