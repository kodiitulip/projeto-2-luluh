
class_name FontScaler
extends Node

const FONT_CLAMP_MIN: int = 4
const FONT_CLAMP_MAX: int = 4096

@export var base_font_size: int
@export var base_size: Vector2

var control: Control


func _enter_tree() -> void:
	control = get_parent()
	control.resized.connect(_scale_handler)


func _exit_tree() -> void:
	control.resized.disconnect(_scale_handler)


func _scale_handler() -> void:
	var new_width: float = maxf(control.size.x, 1.0)
	var scale: float = new_width / base_size.x
	var scaled: int = clampi(floori(base_font_size * scale), FONT_CLAMP_MIN, FONT_CLAMP_MAX)
	control.add_theme_font_size_override("font_size", scaled)
