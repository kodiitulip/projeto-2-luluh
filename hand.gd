class_name Hand
extends ColorRect


const CARD = preload("res://card.tscn")
@export var hand_curve: Curve
@export var rotation_curve: Curve
@export var max_rotation_degrees := 5
@export var x_sep := 10
@export var y_min := 0
@export var y_max := -15
@export var cartas: Array[int]
@export var card_y_on_mouse: float = 50.0

func _ready() -> void:
	for num in cartas:
		draw(num)


func draw(num: int = get_child_count() + 1) -> void:
		print("Drew a card")
		var new_card = CARD.instantiate()
		new_card.value = num
		new_card.max_y = card_y_on_mouse
		new_card.clicada.connect(discard)
		add_child(new_card)
		_update_cards()
func discard(carta) -> void:
	if get_child_count() < 1:
		return
	#var child := get_child(carta)
	carta.reparent(get_tree().root)
	carta.queue_free()
	_update_cards()
func _update_cards() -> void:
	print("babau")
	var cards := get_child_count()
	var all_cards_size := Card.SIZE.x * cards + x_sep * (cards - 1)
	var final_x_sep := x_sep

	if all_cards_size > size.x:
		final_x_sep = (size.x - Card.SIZE.x * cards) / (cards - 1)
		all_cards_size = size.x
	var offset := (size.x - all_cards_size) / 2

	for i in cards:
		var card := get_child(i)
		var y_multiplier := hand_curve.sample(1.0 / (cards-1) * i)
		var rot_multiplier := rotation_curve.sample(1.0 / (cards -1) * i)

		if cards == 1:
			y_multiplier = 0.0
			rot_multiplier = 0.0
		var final_x: float = offset + Card.SIZE.x * i + final_x_sep * i
		var final_y : float = y_min + y_max * y_multiplier
		card.position = Vector2(final_x, final_y)
		card.rotation_degrees = max_rotation_degrees * rot_multiplier
