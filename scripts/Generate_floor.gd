extends Node2D

@export var width: int = 10
@export var height: int = 8
@export var tile_size: int = 32
@export var door_size: int = 2
@export var pasillo_size: int = 8

@export var biomes: Array[Node2D] # Escenas de bioma

var current_biome: Biome

var from_side := [1, 2, 3, 4]
var origin_side: int = 0
var ini_pose: Vector2
var puerta: Array = []
var entry_door_pos: Vector2

@onready var door_scene = preload("res://prefabs/door.tscn")
@onready var zone_scene = preload("res://prefabs/action_zone.tscn")
@onready var spawner    = preload("res://prefabs/spawner.tscn")

signal destroy_rooms

func _ready():
	GameManager.destroy_rooms.connect(_on_destroy_rooms)

	if biomes.is_empty():
		push_error("❌ No hay biomas asignados")
		return

	current_biome = biomes.pick_random() as Biome

	generate_floor(position)
	_generate_walls(position)
	create_spawner()


# =========================
# SUELO
# =========================
func generate_floor(start_pos: Vector2):
	ini_pose = start_pos

	for y in range(height):
		for x in range(width):
			var tile_scene: PackedScene = current_biome.floor_scene

			if current_biome.floor_alt_scene \
			and randf() < current_biome.alt_floor_chance:
				tile_scene = current_biome.floor_alt_scene

			var tile = tile_scene.instantiate()
			tile.position = start_pos + Vector2(x, y) * tile_size
			add_child(tile)


# =========================
# PAREDES
# =========================
func _generate_walls(start_pos: Vector2 = Vector2.ZERO):
	var doors = from_side.duplicate()
	doors.shuffle()

	var count_doors := randi_range(1, 4)
	doors = doors.slice(0, count_doors)

	# asegurar salida distinta a la entrada
	if origin_side != 0:
		var has_exit := false
		for side in doors:
			if side != origin_side:
				has_exit = true
				break

		if not has_exit:
			for side in [1, 2, 3, 4]:
				if side != origin_side:
					doors.append(side)
					break

	var new_doors := []
	for side in doors:
		if side != origin_side:
			new_doors.append(side)

	if origin_side != 0 and not doors.has(origin_side):
		doors.append(origin_side)

	for side in [1, 2, 3, 4]:
		_build_wall(start_pos, side, doors.has(side))

	generate_trigger(new_doors)


func _build_wall(start_pos: Vector2, side: int, has_door: bool):
	var wall_len := 0
	var num_door := 0

	match side:
		1: wall_len = width;  start_pos = Vector2(0, -1)
		2: wall_len = height; start_pos = Vector2(-1, 0)
		3: wall_len = height; start_pos = Vector2(width, 0)
		4: wall_len = width;  start_pos = Vector2(0, height)

	var door_start := int((wall_len - door_size) / 2) if has_door else -1

	for i in range(wall_len):
		var pos = start_pos * tile_size
		if side in [1, 4]:
			pos.x += i * tile_size
		else:
			pos.y += i * tile_size

		if has_door and i >= door_start and i < door_start + door_size:
			num_door += 1

			if side == origin_side:
				var d = door_scene.instantiate()
				d.position = pos
				puerta.append(d)
				add_child(d)
				entry_door_pos = pos
			else:
				var door_value=0
				if num_door == 1:
					door_value = 1
				elif num_door == door_size:
					door_value = 2
				_build_pasillo(pos, side, door_value)
		else:
			var w = current_biome.wall_scene.instantiate()
			w.position = pos
			add_child(w)

	status_puerta(false)


# =========================
# PASILLOS
# =========================
func _build_pasillo(init_pos: Vector2, side: int, door: int):
	for i in range(pasillo_size):
		var pos = init_pos

		match side:
			1: pos.y -= i * tile_size
			2: pos.x -= i * tile_size
			3: pos.x += i * tile_size
			4: pos.y += i * tile_size

		if door in [1, 2]:
			var wall_pos = pos
			if side in [1, 4]:
				wall_pos.x += tile_size if door == 2 else -tile_size
			else:
				wall_pos.y += tile_size if door == 2 else -tile_size

			var w = current_biome.wall_scene.instantiate()
			w.position = wall_pos
			add_child(w)

		var f = current_biome.floor_scene.instantiate()
		f.position = pos
		add_child(f)


# =========================
# TRIGGER / PUERTAS
# =========================
func generate_trigger(doors):
	var area = zone_scene.instantiate()
	area.player_entered.connect(close_door)

	area.width = width
	area.height = height
	area.tile_size = tile_size
	area.door_size = door_size
	area.pasillo_size = pasillo_size
	area.doors = doors
	area.start_pos = ini_pose
	area.entry_door_pos = entry_door_pos

	area.scale = Vector2(width - 2, height - 2)
	area.position = ini_pose + Vector2(width, height) * tile_size / 2

	get_tree().current_scene.add_child.call_deferred(area)


func status_puerta(state: bool = false):
	for obj in puerta:
		obj.visible = state
		obj.set_process(state)
		obj.set_physics_process(state)
		for child in obj.get_children():
			if child is CollisionShape2D:
				child.set_deferred("disabled", !state)


# =========================
# SPAWNER
# =========================
func create_spawner():
	var spawn = spawner.instantiate()
	spawn.top_left = ini_pose + Vector2(tile_size, tile_size)
	spawn.bottom_right = ini_pose + Vector2(
		(width - 1) * tile_size,
		(height - 1) * tile_size
	)
	get_tree().current_scene.add_child.call_deferred(spawn)


# =========================
# LIMPIEZA DE ROOMS
# =========================
func close_door():
	GameManager.previous_room = GameManager.current_room
	GameManager.current_room = self
	GameManager.destroy_rooms.emit()
	status_puerta(true)


func _on_destroy_rooms():
	call_deferred("_check_destroy")


func _check_destroy():
	if self == GameManager.current_room:
		return
	if self == GameManager.previous_room:
		return
	queue_free()
