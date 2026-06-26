class_name CardOld
extends Node2D

signal clicada

const SIZE := Vector2(100, 140)

@export var value: int
@export var max_y: float = 50.0

@onready var label: Label = $Panel/Label


func _ready() -> void:
	label.text = str(value)


func _on_panel_mouse_entered() -> void:
	var t: Tween = create_tween()
	t.tween_property($Panel, "z_index", 50, 0.0)
	t.tween_property($Panel, "position:y", -max_y, 0.3).from_current()


func _on_panel_mouse_exited() -> void:
	var t: Tween = create_tween()
	t.tween_property($Panel, "z_index", 0, 0.0)
	t.tween_property($Panel, "position:y", 0, 0.3).from_current()


func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			clicada.emit(self) # Replace with function body.
