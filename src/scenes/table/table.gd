extends Panel

var value_input: int = 0
var value_output: int = 0

const SINAL_IGUAL = preload("uid://ckij3xbovmou")
const SINAL_MAIOR = preload("uid://bt5bunicaa08c")
const SINAL_MENOR = preload("uid://cp4wkcdp6kogu")
const SINAL_VAZIO = preload("uid://cqxerrsyvc1m8")

@onready var mesa_input: HandDeck = %MesaInput
@onready var mesa_output: HandDeck = %MesaOutput
@onready var sinal_image: TextureRect = %SinalImage

func _ready() -> void:
	mesa_input.child_order_changed.connect(_on_mesa_input_cards_changed)
	mesa_output.child_order_changed.connect(_on_mesa_output_cards_changed)


func _on_mesa_output_card_discarted(card: Card) -> void:
	card.origin_deck.draw_card(card)


func _on_mesa_input_cards_changed() -> void:
	var value: int = 0
	for card: Card in mesa_input.get_children():
		value += card.value
	value_input = value
	calc()


func _on_mesa_output_cards_changed() -> void:
	var value: int = 0
	for card: Card in mesa_output.get_children():
		value += card.value
	value_output = value
	calc()


func calc() -> void:
	var texture: Texture2D = SINAL_VAZIO
	if mesa_input.get_child_count() == 0 or mesa_output.get_child_count() == 0:
		sinal_image.texture = texture
		return
	if value_input > value_output:
		texture = SINAL_MAIOR
	elif value_input < value_output:
		texture = SINAL_MENOR
	elif value_input == value_output:
		texture = SINAL_IGUAL
	sinal_image.texture = texture
