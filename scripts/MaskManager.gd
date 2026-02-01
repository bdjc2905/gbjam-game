extends Node

var collected_masks: Array[int] = []
var count=0
func can_spawn(id: int) -> bool:
	return not collected_masks.has(id)

func collect_mask(id: int) -> void:
	count+=1
	if count >=3:
		get_tree().change_scene_to_file("res://andres/escenas/win.tscn")
	if not collected_masks.has(id):
		collected_masks.append(id)
