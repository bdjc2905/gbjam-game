extends Control

@onready var label = $CenterContainer/Label

func _ready():
	visible = false  # Oculto al inicio

func show_game_over( coins: int):
	label.text = "Game Over\nMonedas: %d" % [coins]
	visible = true
	# Puedes pausar el juego si quieres:
	get_tree().paused = true

func hide_game_over():
	visible = false
	get_tree().paused = false
