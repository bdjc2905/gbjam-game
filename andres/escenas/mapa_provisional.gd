extends Node2D

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_sound("res://audios/Lavender Glitch.mp3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_sound(path: String) -> void:
	var sound = load(path) as AudioStream
	if sound:
		audio_player.stream = sound
		audio_player.play()
	else:
		print("No se pudo cargar el sonido:", path)
