@tool
class_name Card
extends PanelContainer

signal selected(card: Card)

enum HoverDirection {
	UP,
	DOWN,
}

@export var value: int = 0:
	set = _set_value
@export var max_z_index: int = 50

var hover_direction: HoverDirection
var hover_offset: float = 50

@onready var label: Label = $CenterContainer/Label


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	label.text = str(value)


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
	if not is_instance_valid(label):
		await ready
	label.text = str(value)
