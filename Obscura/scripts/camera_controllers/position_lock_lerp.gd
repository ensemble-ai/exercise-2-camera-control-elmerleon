class_name PositionLockLerp
extends CameraControllerBase

@export var follow_speed: float = 5.0  
@export var catchup_speed: float = 8.0 
@export var leash_distance: float = 7.0  

var vessel_moving: bool = false

func _ready() -> void:
	super()
	# Set initial camera position relative to the target
	global_position = target.global_position

func _process(delta: float) -> void:
	if !current:
		return

	var tpos = target.global_position  # Vessel position
	var cpos = global_position         # Camera position

	# Cdis camera to vess
	var distance_to_vessel = cpos.distance_to(tpos)

	# if vessel has velocity
	vessel_moving = target.velocity.length() > 0

	# follow the vessel 
	if vessel_moving:
		global_position.x = lerp(global_position.x, tpos.x, follow_speed * delta)
		global_position.z = lerp(global_position.z, tpos.z, follow_speed * delta)
	else:
		# if not than catch up
		global_position.x = lerp(global_position.x, tpos.x, catchup_speed * delta)
		
		global_position.z = lerp(global_position.z, tpos.z, catchup_speed * delta)

	#  if to far snap 
	if distance_to_vessel > leash_distance:
		global_position.x = tpos.x
		global_position.z = tpos.z

	# for camera height
	global_position.y = tpos.y + dist_above_target

	#draw crosshair
	if draw_camera_logic:
		draw_logic()

	
	super._process(delta)

func draw_logic() -> void:
	# create the cross
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color(1, 0, 0)  

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	var vessel_y = target.global_position.y 

	# actually draw it 
	immediate_mesh.surface_add_vertex(Vector3(global_position.x - 2.5, vessel_y, global_position.z))
	immediate_mesh.surface_add_vertex(Vector3(global_position.x + 2.5, vessel_y, global_position.z))

	immediate_mesh.surface_add_vertex(Vector3(global_position.x, vessel_y, global_position.z - 2.5))
	immediate_mesh.surface_add_vertex(Vector3(global_position.x, vessel_y, global_position.z + 2.5))

	immediate_mesh.surface_end()

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY

	# Free the mesh after one frame
	await get_tree().process_frame
	mesh_instance.queue_free()
