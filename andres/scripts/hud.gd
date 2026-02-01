extends CanvasLayer

@onready var life_label = $Label2
@onready var coins_label = $Label
@onready var health_bar: TextureProgressBar = $Container/TextureProgressBar
var max_health := 100
var current_health := 100
var coins := 0

func _ready():
	# Aquí actualizas la interfaz para que muestre los valores iniciales
	update_life(current_health, max_health)
	update_coins(coins)

func update_life(current, max):
	life_label.text = str(current)
	health_bar.max_value = max    # Define el máximo de la barra (vida máxima)
	health_bar.value = current   # Asigna el valor actual de vida (la barra se llena proporcionalmente)


func update_coins(amount):
	coins_label.text = str(amount)
