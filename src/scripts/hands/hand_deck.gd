@tool
class_name HandDeck
extends Container

signal card_discarted(card: Card)

enum HAlignment {
	LEFT,
	CENTER,
	RIGHT,
	FILL,
}

const CARD = preload("uid://hpjbc4ad37oe")

@export var x_sep: float = 10
@export var hover_direction: Card.HoverDirection = Card.HoverDirection.UP
@export var horizontal_alignment: HAlignment = HAlignment.CENTER:
	set(v):
		horizontal_alignment = v
		queue_sort()

@export_group("Initial Cards", "initial_")
@export var initial_values: Array[int]
@export_subgroup("Debug Buttons")
@export_tool_button("Draw Initial Cards", "EditAddRemove") var initial_draw := _draw_initial_cards
@export_tool_button("Clear Cards", "Clear") var initial_clear := _clear_cards


func _ready() -> void:
	sort_children.connect(_sort_cards)
	_draw_initial_cards()


func draw_card(card: Card) -> void:
	if not is_instance_valid(card):
		return
	if is_instance_valid(card.get_parent()):
		card.reparent(self, false)
	else:
		add_child(card)
	card.selected.connect(discard, CONNECT_ONE_SHOT)
	queue_sort()


func draw_new(num: int = get_child_count() + 1) -> void:
	var new_card: Card = CARD.instantiate()
	new_card.value = num
	new_card.hover_direction = hover_direction
	new_card.selected.connect(discard, CONNECT_ONE_SHOT)
	add_child(new_card)
	queue_sort()


func discard(card: Card) -> void:
	if not is_instance_valid(card):
		return
	card.reparent(get_tree().root)
	if card.selected.is_connected(discard):
		card.selected.disconnect(discard)
	card_discarted.emit(card)
	queue_sort()


func discard_free(card: Card) -> void:
	discard(card)
	card.queue_free()


func _sort_cards() -> void:
	var cards: Array = get_children().filter(func(n): return n is Card)
	var cards_num: int = cards.size()
	var all_cards_size: float = cards.reduce(
		func(accm, curr: Card):
			return accm + curr.size.x,
		0,
	)
	var final_size: float = all_cards_size + x_sep * (cards_num - 1)
	var final_x_sep: float = x_sep

	if final_size > size.x or horizontal_alignment == HAlignment.FILL:
		final_x_sep = (size.x - all_cards_size) / (cards_num - 1)
		final_size = size.x

	var hoffset: float = 0.0
	match horizontal_alignment:
		HAlignment.LEFT, HAlignment.FILL:
			hoffset = 0.0
		HAlignment.CENTER:
			hoffset = (size.x - final_size) / 2.0
		HAlignment.RIGHT:
			hoffset = (size.x - final_size)

	for i in cards_num:
		var card: Card = cards.get(i)
		if not is_instance_valid(card):
			continue
		var final_pos: Vector2 = Vector2(
			hoffset + card.size.x * i + final_x_sep * i,
			position.y,
		)
		fit_child_in_rect(card, Rect2(final_pos, card.size))

func _draw_initial_cards() -> void:
	for card: int in initial_values:
		draw_new(card)


func _clear_cards() -> void:
	for child: Node in get_children():
		child.queue_free()
