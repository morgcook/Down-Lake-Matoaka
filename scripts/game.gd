extends Node2D

@onready var lanes: Node = $Lanes
@onready var timer: Timer = $Timer
@onready var obstacles: Node = $Obstacles
@onready var player: CharacterBody2D = $Player
@onready var death_timer: Timer = $Death_Timer
@onready var start_menu: Node2D = $"Start Menu"
@onready var score_label: Label = $Score
@onready var high_score_label: Label = $"High Score"

@export var speed = 40
@export var running = false

var rng = RandomNumberGenerator.new()
var obst_scene = preload("res://scenes/obstacle.tscn")
var slow_down = false

var score = 0
var high_score = 0
	
func _input(event: InputEvent) -> void:
	if not running and event.is_action_pressed("start"):
		reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not running:
		if speed != 0 and slow_down:
			speed = floor(speed * 0.95)
		return
	
	timer.wait_time = 5 - clamp(remap(speed, 40, 200, 0.5, 4), 0, 4)
	
	for obj in lanes.get_children():
		obj.position.x -= speed * delta
		
		if obj.visible == false and lanes.get_child_count() == 6:
			obj.visible = true
		
		if obj.position.x <= 0 and lanes.get_child_count() == 6:
			var new_node = obj.duplicate()
			new_node.position.x = obj.position.x + 288
			new_node.visible = false
			lanes.add_child(new_node)
		
		if obj.position.x < -72:
			lanes.remove_child(obj)
			
	for obst in obstacles.get_children():
		obst.position.x -= speed * delta
		
		if obst.position.x <= -16:
			obstacles.remove_child(obst)
	
	if not player.dead:
		speed += 3 * delta
		score = floor(speed / 1.25) - 31
		
	score_label.text = "Score: " + str(score)
	
	high_score = max(score, high_score)
	
	high_score_label.text = "High Score: " + str(high_score)
		

func _on_timer_timeout() -> void:
	# generate obstacles
	if not player.dead:
		generate_obstacles()

func generate_obstacles():
	if rng.randf() < 0.5:
		obstacles.add_child(obst_scene.instantiate())
	else:
		var obst1 = obst_scene.instantiate()
		var obst2 = obst_scene.instantiate()
		if rng.randf() < 0.5:
			obst1.pos = -1
			obst2.pos = rng.randi_range(0, 1)
		else:
			obst1.pos = 1
			obst2.pos = rng.randi_range(-1, 0)
		obstacles.add_child(obst1)
		obstacles.add_child(obst2)
	
func _on_death_timer_timeout() -> void:
	slow_down = true
	running = false
	start_menu.visible = true
	timer.stop()

func reset():
	slow_down = false
	player.dead = false
	running = true
	start_menu.visible = false
	for obst in obstacles.get_children():
		obst.queue_free()
	timer.start()
	player.position.x = 0
	player.pos = 0
	score = 0
	speed = 40
