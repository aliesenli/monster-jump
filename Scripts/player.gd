extends CharacterBody2D

@export var config: PlayerConfig

const START_POSITION = Vector2(0, 0)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if GameManager.state != GameManager.State.PLAYING:
		return

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * config.speed
	else:
		velocity.x = move_toward(velocity.x, 0, config.speed)

	move_and_slide()

	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		velocity.y = config.jump_velocity

func reset() -> void:
	global_position = START_POSITION
	velocity = Vector2.ZERO

func _on_death_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		EventBus.player_died.emit()
