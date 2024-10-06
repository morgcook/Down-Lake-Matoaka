extends Node2D

@export var pos = 0

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	pos = rng.randi_range(-1, 1)
	position.x = 154

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.y = -16 * pos

func _on_body_entered(body: Node2D) -> void:
	body.die()
