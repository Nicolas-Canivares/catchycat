extends CharacterBody2D

@export var speed := 200  # Velocidad de movimiento

var arbusto_actual = null
var is_hidden := false
var can_hide := false  # Puede esconderse si está cerca de una caja
var direction := Vector2.ZERO
var is_trapped := false
var mash_count := 0
var mash_threshold := 10  # Número de veces que hay que presionar Espacio para liberarse
signal jugador_liberado
var is_intangible := false
var is_parrying := false
var trap_timer: Timer = null
var recently_released: bool = false
var trapping_enemy: CharacterBody2D = null



func hacer_parry():
	is_parrying = true
	$AnimatedSprite2D.play("Parry")  # Asumiendo que tenés esta animación
	await get_tree().create_timer(0.5).timeout  # Duración del parry (ajustable)
	is_parrying = false

#var stamina = 100

func _physics_process(delta):
	direction = Vector2.ZERO
	if is_trapped:
		if Input.is_action_just_pressed("ui_select"):  # 'ui_select' suele ser Espacio
			mash_count += 1
			print("Mash count: ", mash_count)
			if mash_count >= mash_threshold:
				is_trapped = false
				mash_count = 0
				print("¡Liberado!")
				emit_signal("jugador_liberado")

		return  # Bloquea movimiento si está atrapado

	
	# Movimiento
	if is_hidden == false:
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
		modulate.a = 0.0 if is_hidden else 1.0
		esta_escondido()

	update_animation()
	update_prompt()
	if Input.is_action_just_pressed("parry"):  # Debes mapear "parry" a Shift en el Input Map
		hacer_parry()
	
func update_animation():
	if direction != Vector2.ZERO:
		$AnimatedSprite2D.play("RunGatoNegro")
		$AnimatedSprite2D.flip_h = direction.x < 0
	else:
		$AnimatedSprite2D.play("IdleGatoNegro")
	
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
		
func is_hidden_func() -> bool:
	return is_hidden
func is_trapped_func() -> bool:
	return is_trapped
func is_parrying_func() -> bool:
	return is_parrying

func intentar_parry():
	var enemigos = get_tree().get_nodes_in_group("enemigos")
	for enemigo in enemigos:
		if enemigo.global_position.distance_to(global_position) < 60:
			if enemigo.has_method("is_attacking_func") and enemigo.is_attacking_func():
				print("¡Parry exitoso!")
				enemigo.quedar_aturdido()
				return
	print("Parry fallido")  # Parry fuera de ventana

	
func trap_player(enemy = null):
	if recently_released:
		return  # No puede atraparte si sos inmune

	is_trapped = true
	mash_count = 0
	trapping_enemy = enemy
	print("¡Jugador atrapado! Presioná espacio para liberarte.")

	# Timer para reiniciar si no se libera en 3 segundos
	if trap_timer == null:
		trap_timer = Timer.new()
		trap_timer.one_shot = true
		trap_timer.wait_time = 3.0
		trap_timer.connect("timeout", _on_trap_timeout)
		add_child(trap_timer)
	trap_timer.start()

func _on_trap_timeout():
	if is_trapped:
		print("No lograste liberarte a tiempo.")
		get_tree().reload_current_scene()
