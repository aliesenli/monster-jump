extends Node

enum State { MENU, PLAYING, PAUSED }

var state: State = State.MENU
var highscore: int = 0
var current_score: int = 0
var start_y: float = 0.0

var player_ref: CharacterBody2D
var world_generator_ref: Node2D
var camera_ref: Camera2D

const SAVE_PATH = "user://highscore.dat"
const SCORE_DIVISOR = 10.0

func _ready() -> void:
	_load_highscore()
	EventBus.player_died.connect(_on_player_died)

func _process(_delta: float) -> void:
	if state != State.PLAYING:
		return
	if not player_ref:
		return
	var new_score = int(floor((start_y - player_ref.global_position.y) / SCORE_DIVISOR))
	if new_score > current_score:
		current_score = new_score
		EventBus.score_updated.emit(current_score)

func start_game() -> void:
	if not player_ref:
		return
	get_tree().paused = false
	player_ref.reset()
	if world_generator_ref:
		world_generator_ref.reset()
	if camera_ref:
		camera_ref.reset()
	current_score = 0
	start_y = player_ref.global_position.y
	state = State.PLAYING
	EventBus.game_started.emit()

func pause_game() -> void:
	if state != State.PLAYING:
		return
	state = State.PAUSED
	get_tree().paused = true
	EventBus.game_paused.emit()

func resume_game() -> void:
	if state != State.PAUSED:
		return
	state = State.PLAYING
	get_tree().paused = false
	EventBus.game_resumed.emit()

func restart_game() -> void:
	get_tree().paused = false
	if player_ref:
		player_ref.reset()
	if world_generator_ref:
		world_generator_ref.reset()
	if camera_ref:
		camera_ref.reset()
	current_score = 0
	start_y = player_ref.global_position.y if player_ref else 0.0
	state = State.PLAYING
	EventBus.game_started.emit()

func _on_player_died() -> void:
	state = State.MENU
	if current_score > highscore:
		highscore = current_score
		_save_highscore()
	EventBus.game_over.emit(current_score, highscore)

func _load_highscore() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		highscore = file.get_32()
		file.close()

func _save_highscore() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_32(highscore)
		file.close()
