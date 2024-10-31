class_name PositionLockLerpTargetFocus
extends CameraControllerBase

@export var lead_speed: float = 60.0  
@export var hyper_lead_speed: float = 400 # for hyper case
@export var catchup_delay_duration: float = 0.5 
@export var catchup_speed: float = 8.0 
@export var leash_distance: float = 15.0  
@export var hyper_leash_distance: float = 10 # for hyper case

var lead_position: Vector3
var vessel_moving: bool = false
var time_since_stop: float = 0.0  

func _ready() -> void:
	super()
	# Set initial camera and lead positions to the vessel's position
	global_position = target.global_position
	lead_position = global_position

func _process(delta: float) -> void:
	if not current:
		return

	var tpos = target.global_position  #vessel pos
	var cpos = global_position         # camer pos

	# vessel speed
	var vessel_speed = target.velocity.length()
	vessel_moving = vessel_speed > 0

	# adjust lead speed ,leash distance based on vessel speed
	var current_lead_speed = lead_speed
	var current_leash_distance = leash_distance

	if vessel_speed >= target.HYPER_SPEED:
		current_lead_speed = hyper_lead_speed
		current_leash_distance = hyper_leash_distance

	if vessel_moving:
		# reset time
		time_since_stop = 0.0

		#calc leash posiion infront of vessel
		var lead_direction = target.velocity.normalized()
		lead_position = tpos + lead_direction * current_leash_distance

		# where the camera follows
		global_position.x = move_toward(global_position.x, lead_position.x, current_lead_speed * delta)
		global_position.z = move_toward(global_position.z, lead_position.z, current_lead_speed * delta)

	else:
		# vessel stopped
		time_since_stop += delta

		# move twords the vessel
		if time_since_stop >= catchup_delay_duration:
			global_position.x = move_toward(global_position.x, tpos.x, catchup_speed * delta)
			global_position.z = move_toward(global_position.z, tpos.z, catchup_speed * delta)

	# maintinaing height
	global_position.y = tpos.y + dist_above_target

	# for the cross
	if draw_camera_logic:
		draw_logic()

	super._process(delta)

func draw_logic() -> void:
	# Create the cross
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color(1, 1, 4) 

	# Assign material and mesh
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)


	var vessel_y = target.global_position.y

	
	immediate_mesh.surface_add_vertex(Vector3(global_position.x - 2.5, vessel_y, global_position.z))
	immediate_mesh.surface_add_vertex(Vector3(global_position.x + 2.5, vessel_y, global_position.z))

	immediate_mesh.surface_add_vertex(Vector3(global_position.x, vessel_y, global_position.z - 2.5))
	immediate_mesh.surface_add_vertex(Vector3(global_position.x, vessel_y, global_position.z + 2.5))

	immediate_mesh.surface_end()


	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY

	
	await get_tree().process_frame
	mesh_instance.queue_free()
