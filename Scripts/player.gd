extends CharacterBody2D

signal OnUpdateHealth (health : int)
signal OnUpdateScore (score : int)

@export var move_speed : float = 100
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float = 500
@export var jump_force : float = 200
@export var health: int = 3
@export var bullet_scene : PackedScene = preload("res://Scenes/Shuriken.tscn")
@export var ammo : int = 10
signal OnUpdateAmmo (count : int)

# --- New Power-up Variables ---
var can_double_jump : bool = false
var has_double_jump_powerup : bool = false
var has_speed_boost : bool = false
# ------------------------------

var move_input : float

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer

var take_damage_sfx : AudioStream = preload("res://Audio/take_damage.wav")
var coin_sfx : AudioStream = preload("res://Audio/coin.wav")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Reset the ability to double jump when we touch the ground
		if has_double_jump_powerup:
			can_double_jump = true
	
	move_input = Input.get_axis("move_left","move_right")
	
	# If speed boost is active, multiply the move_speed
	var current_speed = move_speed * 2.0 if has_speed_boost else move_speed
	
	if move_input != 0:
		velocity.x = lerp(velocity.x, move_input * current_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking * delta)
	
	# Updated Jump Logic for Double Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_force
		elif can_double_jump:
			velocity.y = -jump_force
			can_double_jump = false # Consume the double jump
	
	move_and_slide()

func _process (delta):
	if velocity.x != 0:
		#Keep your flipping logic
		sprite.flip_h = velocity.x < 0
		
	_manage_animation_()
	
	# --- SHOOTING CHECK ---
	if Input.is_action_just_pressed("shoot") and ammo > 0:
		shoot()
	# -----------------------------------
	
	if global_position.y > 200:
		game_over()

# Shoot function
func shoot():
	ammo -= 1
	OnUpdateAmmo.emit(ammo)
	
	var b = bullet_scene.instantiate()
	
	# Set bullet position to player position
	b.global_position = global_position 
	b.direction = -1.0 if sprite.flip_h else 1.0
	
	# Add the bullet to the level, not the player
	get_parent().add_child(b)
func _manage_animation_ ():
	if not is_on_floor():
		anim.play("jump")
	elif move_input != 0:
		anim.play ("move")
	else:
		anim.play("idle")

func take_damage (amount : int):
	health -= amount
	OnUpdateHealth.emit(health)
	_damage_flash()
	play_sound(take_damage_sfx)
	
	if health <= 0:
		call_deferred("game_over")
		
func game_over ():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func increase_score(amount : int):
	PlayerStats.score += amount
	OnUpdateScore.emit(PlayerStats.score)
	play_sound(coin_sfx)
	# Trigger the powerup logic
	_apply_random_powerup()

func _apply_random_powerup():
	var roll = randi() % 2 # 0 or 1
	
	if roll == 0:
		# SPEED BOOST
		has_speed_boost = true
		sprite.modulate = Color.CYAN 
		await get_tree().create_timer(5.0).timeout 
		has_speed_boost = false
		sprite.modulate = Color.WHITE
	else:
		# DOUBLE JUMP
		has_double_jump_powerup = true
		sprite.modulate = Color.GOLD
		await get_tree().create_timer(5.0).timeout
		has_double_jump_powerup = false
		sprite.modulate = Color.WHITE

func _damage_flash ():
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = Color.WHITE
	
func play_sound (sound : AudioStream):
	audio.stream = sound
	audio.play()
