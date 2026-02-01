extends Control
@onready var btn_reintentar: Button = $Label/Reintentar
@onready var btn_menu: Button = $Label/Menu
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	# Conectar botones
	btn_reintentar.pressed.connect(_on_reintentar_pressed)
	btn_menu.pressed.connect(_on_menu_pressed)
	play_sound("res://audios/glitch-warrior-gaming-song-367232.mp3")
	play_sound("res://audios/die-47695.mp3")

func _on_reintentar_pressed() -> void:
	get_tree().change_scene_to_file("res://Bran.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://andres/escenas/menu.tscn")

func play_sound(path: String) -> void:
	var sound = load(path) as AudioStream
	if sound:
		audio_player.stream = sound
		audio_player.play()
	else:
		print("No se pudo cargar el sonido:", path)
		
		
