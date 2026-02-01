extends Area2D

var start_pos = Vector2.ZERO
var doors = []
var entry_door_pos: Vector2

var width:int = 10
var height:int = 8
var tile_size:int = 32
var door_size:int = 2
var pasillo_size:int = 8

signal player_entered

func _ready():
	body_entered.connect(collision_player)

func _process(delta):
	if not monitoring:
		return
	for body in get_overlapping_bodies():
		if body.name == "Player":
			collision_player()
			
func collision_player():
	emit_signal("player_entered")
	monitoring = false
	_generate_next_rooms()
	queue_free()
	

func _generate_next_rooms():
	var script_ref = preload("res://scripts/Generate_floor.gd")

	for side in [1,2,3,4]:
		if doors.has(side):
			var room_instance = script_ref.new()
			var next_pos
			var origin_s

			match side:
				1: next_pos = Vector2(start_pos.x, start_pos.y - (pasillo_size + height) * tile_size); origin_s = 4
				2: next_pos = Vector2(start_pos.x - (pasillo_size + width) * tile_size, start_pos.y); origin_s = 3
				3: next_pos = Vector2(start_pos.x + (pasillo_size + width) * tile_size, start_pos.y); origin_s = 2
				4: next_pos = Vector2(start_pos.x, start_pos.y + (pasillo_size + height) * tile_size); origin_s = 1

			room_instance.width = width
			room_instance.height = height
			room_instance.tile_size = tile_size
			room_instance.door_size = door_size
			room_instance.pasillo_size = pasillo_size
			room_instance.position = next_pos
			room_instance.origin_side = origin_s

			get_tree().current_scene.add_child(room_instance)
