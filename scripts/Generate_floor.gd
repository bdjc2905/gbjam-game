extends Node2D

@export var width:int = 10
@export var height:int = 8
@export var tile_size:int = 32
@export var door_size:int = 2
@export var pasillo_size:int = 8

var from_side := [1,2,3,4]
var origin_side = 0
var ini_pose
var puerta := []

var entry_door_pos: Vector2

@onready var floor_scene = preload("res://prefabs/floor.tscn")
@onready var wall_scene  = preload("res://prefabs/pared.tscn")
@onready var door_scene  = preload("res://prefabs/door.tscn")
@onready var zone_scene  = preload("res://prefabs/action_zone.tscn")

@onready var spawner  = preload("res://prefabs/spawner.tscn")
var spawn
signal destroy_rooms
var this_no :bool
func _ready():
	GameManager.destroy_rooms.connect(_on_destroy_rooms)
	generate_floor(position)
	_generate_walls(position)
	create_spawner()
func create_spawner():
	spawn = spawner.instantiate()
	var min = ini_pose + Vector2(tile_size,tile_size)
	var max = Vector2(
		ini_pose.x + ((width-1) * tile_size),
		ini_pose.y + ((height-1) * tile_size)
	)
	spawn.top_left=min
	spawn.bottom_right=max
	get_tree().current_scene.add_child.call_deferred(spawn)
func generate_floor(start_pos:Vector2):
	ini_pose = start_pos
	for i in range(height):
		for j in range(width):
			var f = floor_scene.instantiate()
			f.position += Vector2(j * tile_size, i * tile_size)
			add_child(f)

func _generate_walls(start_pos:Vector2 = Vector2.ZERO):

	var doors = from_side.duplicate()
	doors.shuffle()

	var count_doors = randi_range(1, 4)
	doors = doors.slice(0, count_doors)

	# 👉 asegurar al menos una salida que NO sea la de entrada
	if origin_side != 0:
		var has_exit := false
		for side in doors:
			if side != origin_side:
				has_exit = true
				break

		if not has_exit:
			for side in [1,2,3,4]:
				if side != origin_side:
					doors.append(side)
					break

	var new_doors := []
	for side in doors:
		if side != origin_side:
			new_doors.append(side)

	if origin_side != 0 and not doors.has(origin_side):
		doors.append(origin_side)

	for side in [1,2,3,4]:
		_build_wall(start_pos, side, doors.has(side))

	generate_trigger(new_doors)


func _on_destroy_rooms():
	call_deferred("_check_destroy")
	
func _check_destroy():
	if self == GameManager.current_room:
		return
	if self == GameManager.previous_room:
		return
	spawn.queue_free()
	queue_free()
	
func close_door():
	GameManager.previous_room = GameManager.current_room
	GameManager.current_room = self
	GameManager.destroy_rooms.emit()
	status_puerta(true)

	
func generate_trigger(doors):
	var area_instance = zone_scene.instantiate()
	area_instance.player_entered.connect(close_door)
	area_instance.scale= Vector2(((width)-2),((height)-2))
	area_instance.width = width
	area_instance.height = height
	area_instance.tile_size = tile_size
	area_instance.door_size = door_size
	area_instance.pasillo_size = pasillo_size
	area_instance.doors = doors
	area_instance.start_pos = ini_pose

	# 👉 PASAMOS la posición de la puerta de entrada
	area_instance.entry_door_pos = entry_door_pos

	area_instance.position = Vector2(
		ini_pose.x + (width * tile_size) / 2,
		ini_pose.y + (height * tile_size) / 2
	)
	get_tree().current_scene.add_child.call_deferred(area_instance)

func status_puerta(state:bool =false):
	for obj in puerta:
		obj.visible = state
		obj.set_process(state)
		obj.set_physics_process(state)
		for child in obj.get_children():
			if child is CollisionShape2D:
				child.set_deferred("disabled", !state)


func _build_wall(start_pos, side:int, has_door:bool):
	var wall_len = 0
	var num_door = 0

	match side:
		1: wall_len = width;  start_pos = Vector2(0, -1)
		2: wall_len = height; start_pos = Vector2(-1, 0)
		3: wall_len = height; start_pos = Vector2(width, 0)
		4: wall_len = width;  start_pos = Vector2(0, height)

	var door_start = int((wall_len - door_size) / 2) if has_door else -1

	for i in range(wall_len):
		var pos = start_pos * tile_size
		if side in [1,4]:
			pos.x += i * tile_size
		else:
			pos.y += i * tile_size

		if i >= door_start and i < door_start + door_size and has_door:
			num_door += 1
			if origin_side != 0 and side == origin_side:
				var tile = door_scene.instantiate()
				tile.position = pos
				puerta.append(tile)
				add_child(tile)
				entry_door_pos=pos

			if side != origin_side:
				
				var door_value=0
				if(num_door==1):
					door_value=1
				elif(num_door==door_size):
					door_value=2
				_build_pasillo(pos, side, door_value)
			else:
				entry_door_pos = pos
		else:
			var w = wall_scene.instantiate()
			w.position = pos
			add_child(w)
	status_puerta(false)

func _build_pasillo(init_poition:Vector2, side:int, door:int):
	for i in range(pasillo_size):
		var pos = init_poition
		match side:
			1: pos.y -= i * tile_size
			2: pos.x -= i * tile_size
			3: pos.x += i * tile_size
			4: pos.y += i * tile_size

		if door == 1 or door == 2:
			var wall_pos = pos
			if side in [1,4]:
				wall_pos.x += tile_size if door == 2 else -tile_size
			else:
				wall_pos.y += tile_size if door == 2 else -tile_size
			var w = wall_scene.instantiate()
			w.position = wall_pos
			add_child(w)

		var f = floor_scene.instantiate()
		f.position = pos
		add_child(f)
