extends Resource
class_name InstantiatableObject

@export var prefabs : Array[PackedScene] = [] 

@export_range(0.0, 1.0) var minimum_slope : float = 0.5 
@export_range(0.0, 16.0, 0.5) var dispersion : float = 0.5 
@export_range(0.0, 1.0) var density : float = 0.125 

@export var minimum_altitude : float = 0
@export var maximum_altitude : float = 100

@export var position_offset : Vector3 = Vector3.ZERO

@export_flags_2d_physics var collision_mask : int = 1
@export var add_colliders : bool = true
@export var custom_collision_shape : Shape3D
@export var custom_collision_offset : Vector3
@export var custom_collision_size : Vector3 = Vector3(0.5, 2.0, 0.5)
