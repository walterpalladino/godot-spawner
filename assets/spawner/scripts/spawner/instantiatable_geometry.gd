extends Resource
class_name InstantiatableGeometry

var group_idx : int
var prefab_idx : int
var position : Vector3
var rotation : Vector3
var scale : Vector3

func _init(group_idx : int, prefab_idx : int, position : Vector3, rotation : Vector3 = Vector3.ZERO, scale : Vector3 = Vector3.ONE):
	self.group_idx = group_idx
	self.prefab_idx = prefab_idx
	self.position = position
	self.rotation = rotation
	self.scale = scale	
