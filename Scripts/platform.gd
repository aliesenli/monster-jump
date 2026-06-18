extends StaticBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_edge_buffer() -> float:
	var rect_shape = collision_shape_2d.shape as RectangleShape2D
	return rect_shape.size.x / 2.0
