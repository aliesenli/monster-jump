extends Node

signal platform_despawn_requested(platform: Node2D)
signal game_started
signal game_paused
signal game_resumed
signal game_over(score: int, highscore: int)
signal score_updated(score: int)
signal player_died
