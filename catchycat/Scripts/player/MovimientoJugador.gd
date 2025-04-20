extends CharacterBody2D

@export var speed := 200  # Velocidad de movimiento

var arbusto_actual = null
var is_hidden := false
var can_hide := false  # Puede esconderse si está cerca de una caja
var direction := Vector2.ZERO
#var stamina = 100

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

	# Ocultarse con E
	if can_hide and Input.is_action_just_pressed("ui_accept"):
		is_hidden = not is_hidden
		modulate.a = 0.1 if is_hidden else 1.0
		esta_escondido()

	update_animation()
	update_prompt()
	


func update_animation():
	if direction != Vector2.ZERO:
		$AnimatedSprite2D.play("Run")
		$AnimatedSprite2D.flip_h = direction.x < 0
	else:
		$AnimatedSprite2D.play("Idle")
	
func update_prompt():
	var label = $HidePromptLabel
	label.visible = true  # Aseguramos que esté activo para que se vea el fade
	$HidePromptLabel/E/AnimationPlayer.play("LetraE")
	var tween = create_tween()
	if can_hide and not is_hidden:
		tween.tween_property(label, "modulate:a", 1.0, 0.3)
	else:
		tween.tween_property(label, "modulate:a", 0.0, 0.3)
	

func esta_escondido():
	if arbusto_actual != null:
		arbusto_actual.jugador_esta_oculto(is_hidden)
