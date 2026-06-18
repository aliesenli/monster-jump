extends CharacterBody2D

@export var config: PlayerConfig


# Holt die Gravitation aus den globalen Projekteinstellungen
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * config.speed
	else:
		velocity.x = move_toward(velocity.x, 0, config.speed)

	# Bewegung ausführen
	move_and_slide()
	
	# Wenn der Spieler NICHT auf dem Boden ist, wird er nach unten gezogen.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#Sobald der Spieler einen Boden (Die Plattform) berührt, spring er automatisch.
	if is_on_floor():
		velocity.y = config.jump_velocity

func _on_death_zone_body_entered(body: Node2D) -> void:
	if(body.name == "Player"):
		get_tree().call_deferred("reload_current_scene")
	pass # Replace with function body.
