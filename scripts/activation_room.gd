extends Area2D

var start_pos=Vector2.ZERO
var origin
@onready var room  = preload("res://prefabs/generate_room.tscn")
@onready var b  = preload("res://prefabs/block_1.tscn")

func _process(delta):
	if monitoring:
		for body in get_overlapping_bodies():
			if body.name=='Player':
				monitoring=false
				print("activar")
				var script_ref = preload("res://scripts/Generate_floor.gd")
				var room_instance = script_ref.new()  # instanciamos el script directamente
				  # agregamos a la escena si es Node2D
				room_instance.position=start_pos
				room_instance.origin_side=origin
				add_child(room_instance)
				var bi= b.instantiate()
				bi.position=start_pos
				add_child(bi)

			
			
