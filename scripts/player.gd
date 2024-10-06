extends CharacterBody2D
var pos = 0
const SPEED = 50

@onready var game: Node2D = $".."
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var dead = false
@onready var death_timer: Timer = $"../Death_Timer"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up") and pos != 1:
		pos += 1
	if event.is_action_pressed("down") and pos != -1:
		pos -= 1

func _physics_process(_delta: float) -> void:
	if dead or not game.running:
		if animated_sprite.frame == 13:
			animated_sprite.play("water_idle")
		return
		
	animated_sprite.play("row")	
	
	position.y = -16 * pos
	
	animated_sprite.speed_scale = remap(game.speed, 40, 200, 0.5, 2)
	
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if direction == 1:
			animated_sprite.speed_scale *= 1.5
		else:
			animated_sprite.speed_scale /= 2
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	position.x = clamp(position.x, -10, 110)
	
	move_and_slide()

func die():
	dead = true
	death_timer.start()
	animated_sprite.speed_scale = 1.0
	if animated_sprite.animation != "death":
		animated_sprite.play("death")
		position.y = -16 * pos - 1
