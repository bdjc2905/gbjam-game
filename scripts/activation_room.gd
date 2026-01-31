extends Area2D

var start_pos=Vector2.ZERO
var doors
var width:int = 10
var height:int = 8
var tile_size:int = 32
var door_size:int = 2
@onready var room  = preload("res://prefabs/generate_room.tscn")
@onready var b  = preload("res://prefabs/block_1.tscn")

func _process(delta):
	if monitoring:
		for body in get_overlapping_bodies():
			if body.name=='Player':
				monitoring=false
				var script_ref = preload("res://scripts/Generate_floor.gd")
				var next_pos
				for side in [1,2,3,4]:
					if(doors.has(side)):
						var room_instance = script_ref.new()
						var origin_s 
						match side:
							1: 
								next_pos = Vector2(start_pos.x,start_pos.y-(8+height)*tile_size)
								origin_s=4
							2: 
								next_pos = Vector2(start_pos.x-(8+width)*tile_size,start_pos.y)
								origin_s=3
							3: 
								next_pos = Vector2(start_pos.x+(8+width)*tile_size,start_pos.y)
								origin_s=2
							4: 
								next_pos = Vector2(start_pos.x,start_pos.y+(8+height)*tile_size)
								origin_s=1
						room_instance.position=next_pos
						room_instance.origin_side=origin_s
						get_tree().current_scene.add_child(room_instance)
