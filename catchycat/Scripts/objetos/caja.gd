extends Area2D

func _on_body_entered(body):
	if body.name == "Jugador":
		body.can_hide = true  # Le permite esconderse
		#$AnimatedSprite2D.play("EscondidoArbusto")
		body.arbusto_actual = self  # Le damos referencia al arbusto
		$AnimatedSprite2D.play("ChocaArbusto")

func _on_body_exited(body):
	if body.name == "Jugador":
		body.can_hide = false
		body.is_hidden = false  # Por si estaba oculto, lo sacamos
		body.modulate.a = 1.0
		#$AnimatedSprite2D.play("ArbustoQuieto")
		body.arbusto_actual = null
		jugador_esta_oculto(false)  # Volver a animación de arbusto vacío

func jugador_esta_oculto(oculto: bool):
	if oculto:
		$AnimatedSprite2D.play("GatitoEntra")
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.play("EscondidoArbusto")
	else:
		$AnimatedSprite2D.play("ArbustoQuieto")
