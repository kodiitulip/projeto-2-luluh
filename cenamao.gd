extends Node2D

@onready var hand: Hand = $CanvasLayer/ColorRect/Hand
@onready var hand_2: Ocultas = $CanvasLayer/ColorRect/Hand2


func _ready() -> void:
	hand_2.enviar_carta.connect(hand.draw)


func _on_add_pressed() -> void:
	hand.draw()


func _on_del_pressed() -> void:
	hand.discard(hand.get_child(-1))
