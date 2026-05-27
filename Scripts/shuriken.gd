extends Area2D

@export var speed : float = 600.0
var direction : float = 1.0

func _physics_process(delta):
	position.x += speed * direction * delta

func _on_area_entered(area):
	if area.is_in_group("Enemy"):
		if area.has_method("die"):
			area.die()
		queue_free()
