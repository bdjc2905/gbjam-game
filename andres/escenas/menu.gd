extends Control

@onready var btn_menu: Button = $Button
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D



func _ready() -> void:
	
	btn_menu.pressed.connect(_on_menu_pressed)
	# Conectar botones
	play_sound("res://audios/haunted-house-explorer-instrumental-168968.mp3")
	

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Bran.tscn")

func play_sound(path: String) -> void:
	var sound = load(path) as AudioStream
	if sound:
		audio_player.stream = sound
		audio_player.play()
	else:
		print("No se pudo cargar el sonido:", path)
