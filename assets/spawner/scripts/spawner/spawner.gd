@tool
extends Node3D

const InstantiatableObject = preload("res://assets/spawner/scripts/spawner/instantiatable_object.gd")
const InstantiatableGeometry = preload("res://assets/spawner/scripts/spawner/instantiatable_geometry.gd")


@export_group("Prefabs Settings")
@export var geometry_root : Node3D
@export var instantiatable_objects : Array[InstantiatableObject] = []

@export_group("Terrain Settings")
@export var terrain_size = 20
@export var terrain_offset : Vector3 = Vector3.ZERO

@export_group("Noise Settings")
@export var noise_seed : int = 0
@export var noise_scale : float = 0.5
@export var noise_offset : Vector2 = Vector2( 0.0, 0.0 )
#	Help for Island / Beaches / smooth mountain sides
@export var soft_exp : float = 1.0


#	Actions
@export_category("Actions")

@export var update_geometry : bool :
	set(value):
		update_geometry_instances()
#var update_instances = false

@export var clear_geometry : bool :
	set(value):
		clear_geometry_instances()

#@export_tool_button("Update Geometry") var update_geometry_action = update_geometry_instances
#@export_tool_button("Clear") var clear_action = clear_geometry_instances

var lod_scale : float = 1.0

var geometry : Array[InstantiatableGeometry] = [] 
var rng
#var noise_map : PackedFloat32Array = PackedFloat32Array()

var noise : Noise 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_mesh():
	pass


func update_material():
	pass


func noise_init():

	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = noise_seed

	noise.fractal_octaves = 8
	noise.fractal_lacunarity = 2.75
	noise.fractal_gain = 4.0 #0.4


func noise_get_value_at(x : float, y : float) -> float :
	
	var noise_position = Vector2(x * noise_scale, y * noise_scale)
	noise_position += noise_offset
	noise_position *= lod_scale

	var noise_value = noise.get_noise_2d(noise_position.x, noise_position.y)

	noise_value = noise_value + 0.5
	noise_value = clamp( noise_value, 0.0, 1.0 )
	
	#  Help for Island / Beaches / smooth mountain sides
	noise_value = pow(noise_value, soft_exp);

	return noise_value


func update_geometry_instances():
	
	print_debug("update_geometry_instances")
	
	clear_geometry_instances()
	
	if instantiatable_objects.size() == 0:
		print("instantiatable_objects is empty")
		return

	#	Initialize noise
	noise_init()
	
	rng = RandomNumberGenerator.new()
	rng.seed = noise_seed

#	noise_map = NoiseUtils.generate_noise_map(noise_seed,noise_scale,terrain_size,noise_offset,soft_exp,lod_scale)

	for i in range(instantiatable_objects.size()):
		generate_geometry(i)
	
	instanstiate_geometry()
	
	

func clear_geometry_instances():
	
	print_debug("clear_geometry_instances")
	
#	noise_map.clear()
	#multimesh = null

	for child in geometry_root.get_children():
		#print_debug(child.name)
		#remove_child(child)
		child.queue_free()

	geometry.clear()
	#	Clear colliders
	#clear_colliders()

	
func clear_colliders():

	clear_colliders_in(geometry_root)	


func clear_colliders_in(root : Node3D):
	
	for child in root.get_children():
		#print_debug(child.name)
		remove_child(child)
		child.queue_free()
	
		
func instanstiate_geometry():
	
	print_debug("instanstiate_geometry")
	
	if geometry.size() <= 0:
		print("No geometry")
		return

	for data in geometry:
	
		var instance = instantiatable_objects[data.group_idx].prefabs[data.prefab_idx].instantiate()
		instance.position = data.position
		geometry_root.add_child(instance)
		instance.set_owner(get_tree().edited_scene_root)

		var group_data = geometry[data.group_idx]
		#if group_data.add_colliders:
			
			#	generate_colliders()



func generate_colliders():

	print_debug("generate_colliders")
	
	#var new_node = Node3D.new()
	#add_child(new_node)
	#new_node.owner = owner
	
	#var new_node = Node3D.new()
	#$"../StaticBody3D".add_child(new_node)
	#new_node.owner = $"../StaticBody3D".owner
	#
	#var static_body = StaticBody3D.new()
	#new_node.add_child(static_body)
	#static_body.owner = new_node.owner
	 #
	#var collision_shape = CollisionShape3D.new()
#
	#var box : BoxShape3D = BoxShape3D.new()
	#box.size = Vector3(4.0,4.0,4.0)
	#collision_shape.shape = box
	#collision_shape.global_transform = Transform3D(Basis(), Vector3(0.0, 0.0, 0.0))
#
	#static_body.add_child(collision_shape)
	#collision_shape.owner = static_body.owner
	
	#var static_body = StaticBody3D.new()
	#add_child(static_body)
	#static_body.owner = owner

	#var collision_shape = CollisionShape3D.new()
	#var box : BoxShape3D = BoxShape3D.new()
	#box.size = Vector3(4.0,4.0,4.0)
	#collision_shape.shape = box
	#collision_shape.global_transform = Transform3D(Basis(), Vector3(0.0, 0.0, 0.0))

	#static_body.add_child(collision_shape)
	
	# Re-use the same shape
	#var shape = multimesh.mesh.create_trimesh_shape()
	
	var box_shape : BoxShape3D = BoxShape3D.new()
	#box_shape.size = custom_collision_size
	

	# Create one static body
	var collision_parent = StaticBody3D.new()
	#$"..".add_child(collision_parent)
	add_child(collision_parent)
	#collision_parent.owner = $".."
	collision_parent.owner = owner
	collision_parent.set_as_top_level(true)

	#for i in multimesh.visible_instance_count:

		# Create many collision shapes
	#	var collider = CollisionShape3D.new()
	#	collider.shape = box_shape
	#	collider.global_transform = Transform3D(Basis(), geometry_transforms[i].origin + Vector3(0.0, box_shape.size.y / 2.0, 0.0) + custom_collision_offset)
		#collider.shape = shape
		#collider.global_transform = geometry_transforms[i]

	#	collision_parent.add_child(collider)
	#	collider.owner = collision_parent.owner


func generate_geometry(group_idx : int):
	print("generate_geometry for group : " + str(group_idx))
	var group_data : InstantiatableObject = instantiatable_objects[group_idx]

	if group_data.prefabs.size() == 0:
		print("instantiatable_objects[0].prefabs is empty")
		return

	var max_range_value = terrain_size / group_data.dispersion
	max_range_value *= max_range_value
	print("max qty of instances : " + str(max_range_value))
	for i in range(0, max_range_value):

		var instance_position : Vector3 = generate_random_position()
		
		if exists_overlap(instance_position, group_data.dispersion):
			continue
		
		var noise_value = noise_get_value_at(instance_position.x, instance_position.z)
		
		#	Pick a prefab from the list
		var prefab_idx : int = rng.randi_range(0, group_data.prefabs.size() - 1)

		if (noise_value <= group_data.density):

			var height = find_height_at(instance_position.x, instance_position.z, group_data.minimum_slope, group_data.collision_mask)

			if height != null:
				## Set position for the instance
				instance_position.y = height
				geometry.append(InstantiatableGeometry.new(group_idx, prefab_idx, instance_position))


func exists_overlap(position : Vector3, min_distance : float) -> bool:
	
	var position_flat : Vector3 = Vector3(position.x, 0.0, position.z)
	var min_distance_squared : float = min_distance * min_distance
	
	for data in geometry:
		var data_position_flat : Vector3 = Vector3(data.position.x, 0.0, data.position.z)
		if position_flat.distance_squared_to(data_position_flat) < min_distance_squared:
			return true

	return false
	
	
func generate_random_position() -> Vector3 :
	
	var position : Vector3

	position.x = rng.randf_range( 0.0, terrain_size) - terrain_offset.x;
	position.y = 0.0;
	position.z = rng.randf_range( 0.0, terrain_size) - terrain_offset.z;

	return position
	


func find_height_at(x : float, z : float, minimum_slope : float, collision_mask : int):
	
	#RayCast3D
	var origin = Vector3(x, 1000, z)
	var target = origin  + Vector3(0, -1000, 0)
	
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(origin, target)
	query.collision_mask = collision_mask
	var result = space_state.intersect_ray(query)

	if result:
		if (result["normal"].y < minimum_slope):
			return null
		else:
			return result["position"].y
	else:
		return null
	
