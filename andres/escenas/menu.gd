extends Control

@onready var btn_menu: Button = $Button


func _ready() -> void:
	# Conectar botones
	btn_menu.pressed.connect(_on_menu_pressed)

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://andres/escenas/mapa_provisional.tscn")
