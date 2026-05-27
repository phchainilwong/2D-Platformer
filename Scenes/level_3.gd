extends Node2D

@export var dialogue_lines: Array[String] = [
	"JINICHI: All my life... I thought they saved me. I thought they were my family.",
	"JINICHI: But it was the Chai Empire that burned my village. They slaughtered my people just for land...",
	"JINICHI: They didn't adopt me out of mercy. They turned me into a weapon to serve their own killers.",
	"JINICHI: No more. I am breaking out tonight. I will tear this empire down and show the world the blood on their hands!"
]

@onready var text_box_scene = preload("res://Scenes/textbox.tscn") 

func _ready():
	start_level_dialogue()

func start_level_dialogue():
	get_tree().paused = true
	
	var text_box = text_box_scene.instantiate()
	add_child(text_box)
	
	text_box.process_mode = Node.PROCESS_MODE_ALWAYS
	
	text_box.dialogue_finished.connect(_on_dialogue_finished)
	
	text_box.start_dialogue(dialogue_lines)

func _on_dialogue_finished():
	get_tree().paused = false
