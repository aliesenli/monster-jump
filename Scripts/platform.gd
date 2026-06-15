extends StaticBody2D
@onready var area_2d: Area2D = $Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Verbindet das Signal der Area automatisch per Code mit unserer Funktion below
	area_2d.body_entered.connect(_on_body_entered)
	pass # Replace with function body.

func _on_body_entered(body):
	print("Body entered")
	# Prüfen, ob der Körper, der die Area betritt, die Funktion "jump" besitzt (unser Player)
	if body.has_method("jump"):
		# Wichtig für Doodle Jump: Sprung nur auslösen, wenn der Spieler nach unten fällt!
		if body.velocity.y >= 0:
			print("Spieler fällt nach unten")
			body.jump()
