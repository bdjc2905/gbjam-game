extends Node

var collected_masks: Array[int] = []

func can_spawn(id: int) -> bool:
	return not collected_masks.has(id)

func collect_mask(id: int) -> void:
	if not collected_masks.has(id):
		collected_masks.append(id)
