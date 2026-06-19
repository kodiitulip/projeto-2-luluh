extends Hand
class_name Ocultas
signal enviar_carta

# Called when the node enters the scene tree for the first time.
func discard(carta):
	super(carta)
	enviar_carta.emit(carta.value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
