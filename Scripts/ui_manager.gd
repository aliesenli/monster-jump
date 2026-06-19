extends CanvasLayer

@onready var main_menu_panel: Control = $MainMenuPanel
@onready var hud_panel: Control = $HUDPanel
@onready var pause_menu_panel: Control = $PauseMenuPanel
@onready var score_label: Label = $HUDPanel/ScoreLabel
@onready var highscore_label: Label = $MainMenuPanel/HighscoreLabel

func _ready() -> void:
	EventBus.game_started.connect(_on_game_started)
	EventBus.game_paused.connect(_on_game_paused)
	EventBus.game_resumed.connect(_on_game_resumed)
	EventBus.game_over.connect(_on_game_over)
	EventBus.score_updated.connect(_on_score_updated)
	_show_main_menu()

func _show_main_menu() -> void:
	main_menu_panel.visible = true
	hud_panel.visible = false
	pause_menu_panel.visible = false

func _on_game_started() -> void:
	main_menu_panel.visible = false
	hud_panel.visible = true
	pause_menu_panel.visible = false
	score_label.text = "0m"

func _on_game_paused() -> void:
	pause_menu_panel.visible = true

func _on_game_resumed() -> void:
	pause_menu_panel.visible = false

func _on_game_over(score: int, highscore: int) -> void:
	if highscore > 0:
		highscore_label.text = "Highscore: %dm" % highscore
	else:
		highscore_label.text = ""
	_show_main_menu()

func _on_score_updated(score: int) -> void:
	score_label.text = "%dm" % score

func _on_start_button_pressed() -> void:
	GameManager.start_game()

func _on_resume_button_pressed() -> void:
	GameManager.resume_game()

func _on_restart_button_pressed() -> void:
	GameManager.restart_game()

func _on_pause_button_pressed() -> void:
	GameManager.pause_game()
