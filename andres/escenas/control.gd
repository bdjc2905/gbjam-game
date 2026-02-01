extends Control

@onready var btn_reintentar: Button = $Label/Reintentar
@onready var btn_menu: Button = $Label/Menu


func _ready() -> void:
	# Conectar botones
	btn_reintentar.pressed.connect(_on_reintentar_pressed)
	btn_menu.pressed.connect(_on_menu_pressed)


func _on_reintentar_pressed() -> void:
	get_tree().change_scene_to_file("res://andres/escenas/mapa_provisional.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://andres/escenas/menu.tscn")
