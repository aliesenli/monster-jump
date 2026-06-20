extends Camera2D

@export var player: CharacterBody2D

const START_OFFSET = 540.0
const VIEWPORT_HALF = 640.0
const DEATH_ZONE_MARGIN = 60.0
const DESPAWN_ZONE_MARGIN = 110.0
const PRE_SCROLL_DEATH_MARGIN = 200.0
const PRE_SCROLL_DESPAWN_MARGIN = 250.0

var _start_y: float = 0.0
var _is_scrolling: bool = false

@onready var death_zone: Area2D = $DeathZone
@onready var despawn_zone: Area2D = $DespawnZone

func _ready() -> void:
	_start_y = player.global_position.y if player else 0.0

func _process(_delta):
	if not player:
		return

	if player.global_position.y < global_position.y:
		global_position.y = player.global_position.y
		_is_scrolling = true

	if _is_scrolling:
		death_zone.position.y = VIEWPORT_HALF + DEATH_ZONE_MARGIN
		despawn_zone.position.y = VIEWPORT_HALF + DESPAWN_ZONE_MARGIN
	else:
		death_zone.position.y = _start_y - global_position.y + VIEWPORT_HALF + PRE_SCROLL_DEATH_MARGIN
		despawn_zone.position.y = _start_y - global_position.y + VIEWPORT_HALF + PRE_SCROLL_DESPAWN_MARGIN

func reset() -> void:
	if player:
		_start_y = player.global_position.y
		_is_scrolling = false
		global_position = Vector2(0, player.global_position.y - START_OFFSET)
