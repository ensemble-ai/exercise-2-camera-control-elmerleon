class_name FourWaySpeedupPushZone
extends CameraControllerBase

@export var push_ratio: float = 0.5
@export var pushbox_top_left: Vector2 = Vector2(-10, 10)
@export var pushbox_bottom_right: Vector2 = Vector2(10, -10)
@export var speedup_zone_top_left: Vector2 = Vector2(-5, 5)
@export var speedup_zone_bottom_right: Vector2 = Vector2(5, -5)
@export var max_camera_speed: float = 50.0  

func _ready() -> void:
	super()
	global_position = target.global_position

func _process(delta: float) -> void:
	if !current:
		position = target.position 



	if draw_camera_logic:
		draw_logic()

	var tpos = target.global_position  # Vessel's position in world space
	var cpos = global_position         # Camera's position in world space
	var tvel = target.velocity         # Vessel's velocity

	# Define target position relative to the camera
	var relative_tpos = tpos - cpos

	# Check if in the inner speedup zone (camera should not move)
	if relative_tpos.x >= speedup_zone_top_left.x and relative_tpos.x <= speedup_zone_bottom_right.x and \
	   relative_tpos.z <= speedup_zone_top_left.y and relative_tpos.z >= speedup_zone_bottom_right.y:
		return

	# Check if in the middle region (between inner and outer zones)
	var in_middle_region = relative_tpos.x >= pushbox_top_left.x and relative_tpos.x <= pushbox_bottom_right.x and \
						   relative_tpos.z <= pushbox_top_left.y and relative_tpos.z >= pushbox_bottom_right.y

	# Determine edge contact for movement scaling
	var touching_left = relative_tpos.x <= pushbox_top_left.x
	var touching_right = relative_tpos.x >= pushbox_bottom_right.x
	var touching_top = relative_tpos.z >= pushbox_top_left.y
	var touching_bottom = relative_tpos.z <= pushbox_bottom_right.y

	# Movement adjustments based on push ratio and edge contacts
	var camera_move_x = 0.0
	var camera_move_z = 0.0

	if in_middle_region:
		# Apply push ratio scaling if in middle region
		camera_move_x = tvel.x * push_ratio * delta
		camera_move_z = tvel.z * push_ratio * delta
	else:
		# Full speed adjustment when touching an edge
		if touching_left:
			camera_move_x = tvel.x * delta
		elif touching_right:
			camera_move_x = tvel.x * delta

		if touching_top:
			camera_move_z = tvel.z * delta  # Move up at full speed
			print("Touching Top (Up)")
		elif touching_bottom:
			camera_move_z = tvel.z * delta  # Move down at full speed
			print("Touching Bottom (Down)")

	# Apply the calculated movement to the camera's position
	global_position += Vector3(camera_move_x, 0, camera_move_z)
	
	super(delta)

func draw_logic() -> void:
	var mesh_instance = MeshInstance3D.new()
	var immediate_mesh = ImmediateMesh.new()
	var material = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK  # Set a single color for both boxes

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Define the Y coordinate at the camera's height
	var y_coord = global_position.y

	# Draw the outer pushbox boundaries, relative to the camera’s current position
	immediate_mesh.surface_add_vertex(Vector3(global_position.x + pushbox_top_left.x, y_coord, global_position.z + pushbox_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(global_position.x + pushbox_bottom_right.x, y_coord, global_position.z + pushbox_top_left.y))

	immediate_mesh.surface_add_vertex(Vector3(global_position.x + pushbox_bottom_right.x, y_coord, global_position.z + pushbox_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(global_position.x + pushbox_bottom_right.x, y_coord, global_position.z + pushbox_bottom_right.y))

	immediate_mesh.surface_add_vertex(Vector3(global_position.x + pushbox_bottom_right.x, y_coord, global_position.z + pushbox_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(global_position.x + pushbox_top_left.x, y_coord, global_position.z + pushbox_bottom_right.y))

	immediate_mesh.surface_add_vertex(Vector3(global_position.x + pushbox_top_left.x, y_coord, global_position.z + pushbox_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(global_position.x + pushbox_top_left.x, y_coord, global_position.z + pushbox_top_left.y))

	# Draw the inner speedup zone boundaries, relative to the camera’s current position
	immediate_mesh.surface_add_vertex(Vector3(global_position.x + speedup_zone_top_left.x, y_coord, global_position.z + speedup_zone_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(global_position.x + speedup_zone_bottom_right.x, y_coord, global_position.z + speedup_zone_top_left.y))

	immediate_mesh.surface_add_vertex(Vector3(global_position.x + speedup_zone_bottom_right.x, y_coord, global_position.z + speedup_zone_top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(global_position.x + speedup_zone_bottom_right.x, y_coord, global_position.z + speedup_zone_bottom_right.y))

	immediate_mesh.surface_add_vertex(Vector3(global_position.x + speedup_zone_bottom_right.x, y_coord, global_position.z + speedup_zone_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(global_position.x + speedup_zone_top_left.x, y_coord, global_position.z + speedup_zone_bottom_right.y))

	immediate_mesh.surface_add_vertex(Vector3(global_position.x + speedup_zone_top_left.x, y_coord, global_position.z + speedup_zone_bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(global_position.x + speedup_zone_top_left.x, y_coord, global_position.z + speedup_zone_top_left.y))

	immediate_mesh.surface_end()

	# Add the mesh instance to the scene at the camera's global position
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = global_position

	# Free the mesh after one frame to avoid accumulation
	await get_tree().process_frame
	mesh_instance.queue_free()
