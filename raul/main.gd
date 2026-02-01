extends Node2D
@export var escena_bola: PackedScene
@export var escena_diavlo: PackedScene
@export var escena_octavio: PackedScene
@export var escena_llorona: PackedScene


func _ready():
	# 1. Instanciamos a Octavio
	var octavio = escena_octavio.instantiate()
	octavio.position = Vector2(200, 200) # Lo ponemos en una posición inicial
	add_child(octavio)
	
	# 2. Instanciamos al Diavlo
	var diavlo = escena_diavlo.instantiate()
	diavlo.position = Vector2(800, 200)
	add_child(diavlo)
	
	# 3. Instanciamos la Bola de Fuegoz
	var bola = escena_bola.instantiate()
	bola.position = Vector2(810, 200)
	add_child(bola)
	
	var llorona = escena_llorona.instantiate()
	llorona.position = Vector2(800, 200) # Lo ponemos en una posición inicial
	add_child(llorona)
