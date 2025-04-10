extends Resource
class_name InstantiatableGeometry

var group_idx : int
var prefab_idx : int
var position : Vector3

func _init(group_idx : int, prefab_idx : int, position : Vector3):
	self.group_idx = group_idx
	self.prefab_idx = prefab_idx
	self.position = position
	
