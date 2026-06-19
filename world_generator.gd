extends Node2D

@export var world_config: WorldConfig 
@export var platform_scene: PackedScene

const SPAWN_START_OFFSET = 100.0

var platform_pool: Array[Node2D] = []
var next_spawn_y: float = 0.0

func _ready() -> void:
	# Überprüfung, ob alle Abhängigkeiten im Inspektor gesetzt wurden (Vermeidung von Laufzeitfehlern)
	if not world_config or not platform_scene:
		push_error("WorldConfig oder PlatformScene fehlt im WorldGenerator!")
		return
	
	# Am EventBus für das Despawn-Signal registrieren
	EventBus.platform_despawn_requested.connect(_on_platform_despawn_requested)
	
	# Plattformen ab Spielerstart nach oben spawnen
	var player = get_tree().get_first_node_in_group("player")
	next_spawn_y = player.global_position.y - SPAWN_START_OFFSET if player else global_position.y
	
	# Den Pool initial befüllen
	_initialize_pool()

# Befüllt den Pool einmalig beim Spielstart vor
func _initialize_pool() -> void:
	for i in range(world_config.pool_size):
		var platform_instance = platform_scene.instantiate() as Node2D
		add_child(platform_instance)
		
		# Erste Verteilung der Plattformen nach oben
		_reposition_platform(platform_instance)
		
		# Plattform im Array registrieren
		platform_pool.append(platform_instance)

# Berechnet eine neue Position für eine Plattform weit oben im Level
# Positioniert eine Plattform weiter oben
func _reposition_platform(platform: Node2D) -> void:
	# Wir holen uns dynamisch die aktuelle sichtbare Breite des Spiels
	var screen_width = get_viewport_rect().size.x
	
	# Ein Puffer, damit Plattformen nicht über den Rand hinausragen (anpassen je nach Sprite-Grösse)
	var edge_buffer = 0.0
	if platform.has_method("get_edge_buffer"):
		edge_buffer = platform.get_edge_buffer()
	
	# X-Position zwischen dem linken und rechten Rand berechnen
	var random_x = 0
	var half_width = screen_width / 2.0
	var left_bound = -half_width + edge_buffer
	var right_bound = half_width - edge_buffer
	random_x = randf_range(left_bound, right_bound)
	
	# Plattform an der neuen Koordinate platzieren
	platform.global_position = Vector2(random_x, next_spawn_y)
	
	# Y-Position für die nächste Plattform berechnen
	var random_distance = randf_range(world_config.spawn_distance_min, world_config.spawn_distance_max)
	next_spawn_y -= random_distance

func _on_platform_despawn_requested(platform: Node2D) -> void:
	if platform in platform_pool:
		_reposition_platform(platform)

func reset() -> void:
	var player = get_tree().get_first_node_in_group("player")
	next_spawn_y = player.global_position.y - SPAWN_START_OFFSET if player else global_position.y
	for platform in platform_pool:
		_reposition_platform(platform)
