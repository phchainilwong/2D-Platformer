extends CanvasLayer

signal dialogue_finished


@onready var panel = $PanelContainer
@onready var label = $PanelContainer/MarginContainer/Label

var lines: Array[String] = []
var current_line_index: int = 0

func start_dialogue(text_lines: Array[String]):
	lines = text_lines
	current_line_index = 0
	show_line()
	show()

func show_line():
	if current_line_index < lines.size():
		label.text = lines[current_line_index]
	else:
		emit_signal("dialogue_finished")
		queue_free()

func _unhandled_input(event):
	
	if event.is_action_pressed("advance_dialogue") and panel.is_visible_in_tree():
		current_line_index += 1
		show_line()
