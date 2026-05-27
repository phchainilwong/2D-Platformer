extends Node2D

@export var dialogue_lines: Array[String] = [
	"TUTORIAL: Welcome to Shadow Path. Press E to continue...",
	"TUTORIAL: Use A and D (or Left/Right Arrows) to move Jinichi through the platforms.",
	"TUTORIAL: Press SPACE to shoot Shurikens and eliminate enemies. Becareful, you only have 10 per level!",
	"TUTORIAL: Press W to jump. As a ninja, you can jump however you like, as long as...",
	"TUTORIAL: YOU COLLECT THE COINS! Collecting coins allow you to gain double jump or double speed.",
	"TUTORIAL: If Jinichi turns yellow, DOUBLE JUMP. If he turns blue, DOUBLE SPEED",
	"JINICHI: My village was destroyed during a war, and I was raised by the Chai Empire after becoming the sole survivor.",
	"JINICHI: Believing a rival empire was responsible, I trained my entire life to become the world's greatest ninja.",
	"JINICHI: Now, my journey begins as I search for the truth behind my village's destruction.",
	"JINICHI: The enemy think they are safe in the dark... but the shadows belong to me. Let's begin."
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
