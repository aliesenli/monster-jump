extends Camera2D

@export var player: CharacterBody2D

func _process(_delta):
	if player:
		# Die Kamera folgt dem Spieler nur nach oben
		if player.global_position.y < global_position.y:
			global_position.y = player.global_position.y
