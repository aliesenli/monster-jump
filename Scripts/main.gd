extends Node2D

func _ready() -> void:
	GameManager.player_ref = $World/Player
	GameManager.world_generator_ref = $WorldGenerator
	GameManager.camera_ref = $Camera2D
	$Camera2D.reset()
