@tool
class_name Card
extends PanelContainer

signal selected(card: Card)

enum HoverDirection {
	UP,
	DOWN,
}

const NEGATIVO = preload("uid://dqj0m3ytsi8nv")
const POSITIVO = preload("uid://dly6p10qkwsd2")

@export var value: int = 0:
	set = _set_value
@export var max_z_index: int = 50

var origin_deck: HandDeck
var hover_direction: HoverDirection
var hover_offset: float = 50

@onready var upper_number: Label = %UpperNumber
@onready var lower_number: Label = %LowerNumber
@onready var sign_symbol: TextureRect = %SignSymbol


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	_set_value(value)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		selected.emit(self)


func _on_mouse_entered() -> void:
	if Engine.is_editor_hint():
		return
	var t: Tween = create_tween()
	t.tween_property(self, ^"z_index", max_z_index, 0.0)
	var hover_y: float = -hover_offset if hover_direction == HoverDirection.UP else hover_offset
	t.tween_property(self, ^"position:y", hover_y, 0.3).from_current()


func _on_mouse_exited() -> void:
	if Engine.is_editor_hint():
		return
	var t: Tween = create_tween()
	t.tween_property(self, ^"z_index", 0, 0.0)
	t.tween_property(self, ^"position:y", 0, 0.3).from_current()


func _set_value(new: int) -> void:
	value = new
	if not (is_instance_valid(upper_number)
		and is_instance_valid(lower_number)
		and is_instance_valid(sign_symbol) ):
		await ready
	var is_pos: bool = signi(value) >= 0
	var text: String = ("+ %s" % value) if is_pos else ("- %s" % abs(value))
	upper_number.text = text
	lower_number.text = text
	var type_variation: StringName = &"CardLabelPos" if is_pos else &"CardLabelNeg"
	upper_number.theme_type_variation = type_variation
	lower_number.theme_type_variation = type_variation
	var symbol: Texture2D = POSITIVO if is_pos else NEGATIVO
	sign_symbol.texture = symbol
