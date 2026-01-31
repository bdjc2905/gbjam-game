extends Node2D

@export var width:int = 10
@export var height:int = 8
@export var tile_size:int = 32
@export var door_size:int = 2

@export var from_side = [1,2,3,4] 
var origin_side = 0
var ini_pose
@onready var floor_scene = preload("res://prefabs/floor.tscn")
@onready var wall_scene  = preload("res://prefabs/pared.tscn")
@onready var door_scene  = preload("res://prefabs/floor.tscn")
@onready var zone_scene  = preload("res://prefabs/action_zone.tscn")

func _ready():
	generate_floor(position)
	_generate_walls(position)

func generate_floor(start_pos:Vector2):
	ini_pose=start_pos
	for i in range(height):
		for j in range(width):
			var f = floor_scene.instantiate()
			f.position += Vector2(j*tile_size, i*tile_size)
			add_child(f)

func _generate_walls(start_pos:Vector2=Vector2.ZERO):
	var doors = from_side.duplicate()
	doors.shuffle()
	var count_doors = randi_range(1, 4)
	doors = doors.slice(0, count_doors) 
	while count_doors==1 and doors.has(origin_side):
		count_doors = randi_range(1, 4)
		doors = doors.slice(0, count_doors)
	generate_trigger(doors)
	if origin_side != 0 and not doors.has(origin_side):
		doors.append(origin_side)
	for side in [1,2,3,4]:
		_build_wall(start_pos,side, doors.has(side))
	

func generate_trigger(doors):
	var area_scene = preload("res://prefabs/action_zone.tscn")

	var area_instance = area_scene.instantiate()
	area_instance.width=width
	area_instance.height=height
	area_instance.tile_size=tile_size
	area_instance.door_size = door_size
	
	area_instance.position=Vector2(ini_pose.x+((width/2)*tile_size),ini_pose.y+((height/2)*tile_size))
	area_instance.doors=doors
	area_instance.start_pos=ini_pose
	get_tree().current_scene.add_child(area_instance)
# -----------------------
func _build_wall(start_pos,side:int, has_door:bool):
	var wall_len = 0
	var num_door=0
	match side:
		1: # top
			wall_len = width
			start_pos = Vector2(0, -1)
		2: # left
			wall_len = height
			start_pos = Vector2(-1,0)
		3: # right
			wall_len = height
			start_pos = Vector2(width,0)
		4: # bottom
			wall_len = width
			start_pos = Vector2(0,height)
	var door_start = int((wall_len - door_size)/2) if has_door else -1
	# crear tiles de pared
	for i in range(wall_len):
		var tile
		var pos = start_pos * tile_size
		if side in [1,4]: # top o bottom → horizontal
			pos.x += i * tile_size
		else:            # left o right → vertical
			pos.y += i * tile_size
		if i >= door_start and i < door_start + door_size:
			if has_door:
				num_door+=1
				var door_value=0
				if(num_door==1):
					door_value=1
				elif (num_door==door_size):
					door_value=2
				tile = door_scene.instantiate()
				tile.position = pos
				add_child(tile)
				if(side!=origin_side):
					_build_pasillo((pos),side,door_value)
			else:
				tile = wall_scene.instantiate()
				tile.position = pos
				add_child(tile)
		else:
			tile = wall_scene.instantiate()
			tile.position = pos
			add_child(tile)
		

func _build_pasillo(init_poition:Vector2,side:int,door:int):
	var zone = zone_scene.instantiate()
	for i in range(8):
		var pos = init_poition
		var f = floor_scene.instantiate()
		match side:
			1: pos.y -= i * tile_size
			2: pos.x -= i * tile_size
			3: pos.x += i * tile_size
			4: pos.y += i * tile_size
		if(door==1):	
			var wall_pos = pos
			if side in [1,4]: # top o bottom → horizontal
				wall_pos.x -= tile_size
			else:            # left o right → vertical
				wall_pos.y -= tile_size
			var w = wall_scene.instantiate()
			w.position = wall_pos
			add_child(w)
		if(door==2):
			var wall_pos = pos
			if side in [1,4]: # top o bottom → horizontal
				wall_pos.x += tile_size
			else:            # left o right → vertical
				wall_pos.y += tile_size
			var w = wall_scene.instantiate()
			w.position = wall_pos
			add_child(w)
			
		f.position = pos
		add_child(f)
	
	
