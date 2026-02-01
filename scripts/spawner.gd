extends Node2D

@export var min_enemies := 1
@export var max_enemies := 4

@export var min_coins := 3
@export var max_coins := 10

@export var min_coffee := 0
@export var max_coffee := 2

@export var special_chance := 0.25

@export var enemy_scene: PackedScene
@export var coin_scene: PackedScene
@export var coffee_scene: PackedScene

# IMPORTANTE:
# índice 0 = máscara id 0
# índice 1 = máscara id 1
# índice 2 = máscara id 2
@export var mask_scenes: Array[PackedScene]

var top_left: Vector2
var bottom_right: Vector2


func _ready():
	spawn_all()


func spawn_all():
	spawn_random(enemy_scene, min_enemies, max_enemies)
	spawn_random(coin_scene, min_coins, max_coins)
	spawn_random(coffee_scene, min_coffee, max_coffee)
	spawn_special_mask()


# -----------------------
# SPAWN NORMAL
# -----------------------
func spawn_random(scene: PackedScene, min: int, max: int):
	if scene == null:
		return

	var count := randi_range(min, max)
	for i in range(count):
		var obj = scene.instantiate()
		obj.global_position = random_position()
		add_child(obj)


func random_position() -> Vector2:
	return Vector2(
		randf_range(top_left.x, bottom_right.x),
		randf_range(top_left.y, bottom_right.y)
	)


func spawn_special_mask():
	if randf() > special_chance:
		return

	var valid_scenes: Array[PackedScene] = []

	for scene in mask_scenes:
		var temp= scene.instantiate()
		if temp == null:
			continue

		if MaskManager.can_spawn(temp.mask_id):
			valid_scenes.append(scene)

		temp.queue_free()

	if valid_scenes.is_empty():
		return

	var chosen_scene: PackedScene = valid_scenes.pick_random()
	var mask = chosen_scene.instantiate()

	mask.global_position = (top_left + bottom_right) / 2
	add_child(mask)
