extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -1600.0 # Negativ, da in Godot Y nach unten positiv ist

# Holt die Gravitation aus den globalen Projekteinstellungen
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Gravitation anwenden
	velocity.y += gravity * delta

	# Tastatur-Input abfragen (für den Desktop-Prototyp)
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Bewegung ausführen
	move_and_slide()

func jump():
	velocity.y = JUMP_VELOCITY
	# Hier könnt ihr später die Sprung-Animation triggern
