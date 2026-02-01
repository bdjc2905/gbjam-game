extends Node2D

@onready var enemy_scene= preload("res://prefabs/pared.tscn")
@onready var coin_scene= preload("res://prefabs/pared.tscn")
@onready var coffee_scene= preload("res://prefabs/pared.tscn")
@onready var mask1= preload("res://prefabs/test.tscn")
@onready var mask2= preload("res://prefabs/test.tscn")
@onready var mask3= preload("res://prefabs/test.tscn")

@export var min_enemies := 1
@export var max_enemies := 4

@export var min_coins := 3
@export var max_coins := 10

@export var min_coffee := 0
@export var max_coffee := 2

@export var special_chance := 0.25 # 25%

var masks=[]
var top_left: Vector2
var bottom_right: Vector2
func _ready() -> void:
	spawn_all()


func spawn_all():
	masks.append(mask1)
	masks.append(mask2)
	masks.append(mask3)
	spawn_random(enemy_scene, min_enemies, max_enemies)
	spawn_random(coin_scene, min_coins, max_coins)
	spawn_random(coffee_scene, min_coffee, max_coffee)
	spawn_special()
	
func spawn_random(scene:PackedScene, min:int, max:int):
	if scene == null:
		return

	var count = randi_range(min, max)

	for i in count:
		var obj = scene.instantiate()
		obj.global_position = random_position()
		add_child(obj)
		
func random_position() -> Vector2:
	return Vector2(
		randf_range(top_left.x, bottom_right.x),
		randf_range(top_left.y, bottom_right.y)
	)
	
func spawn_special():
	if masks.size() >0:
		return
	if randf() > special_chance:
		return
	var p = randi_range(0,masks.size())
	var special = masks[p].instantiate()
	special.global_position = (top_left + bottom_right) / 2
	add_child(special)
	masks.remove_at(p)
