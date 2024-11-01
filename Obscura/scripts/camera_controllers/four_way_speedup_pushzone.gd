class_name FourWaySpeedupPushZone
extends CameraControllerBase

@export var push_ratio: float = 0.5
@export var pushbox_top_left: Vector2 = Vector2(-10, 10)
@export var pushbox_bottom_right: Vector2 = Vector2(10, -10)
@export var speedup_zone_top_left: Vector2 = Vector2(-5, 5)
@export var speedup_zone_bottom_right: Vector2 = Vector2(5, -5)
@export var max_camera_speed: float = 50.0  

func _ready() -> void:
	
	global_position = target.global_position
	super()

func _process(delta: float) -> void:
	if !current:
		position = target.position # to reposition

	if draw_camera_logic:
		draw_logic()

	var tpos = target.global_position  # Vessel position in world space
	var cpos = global_position         # Camera  position in world space
	var tvel = target.velocity         # Vessel  velocity

	# tar pos to camera
	var relative_tpos = tpos - cpos

	#if in inner
	if relative_tpos.x >= speedup_zone_top_left.x and relative_tpos.x <= speedup_zone_bottom_right.x and \
	   relative_tpos.z <= speedup_zone_top_left.y and relative_tpos.z >= speedup_zone_bottom_right.y:
		return

	# check if middle zone
	var in_middle_region = relative_tpos.x >= pushbox_top_left.x and relative_tpos.x <= pushbox_bottom_right.x and \
						   relative_tpos.z <= pushbox_top_left.y and relative_tpos.z >= pushbox_bottom_right.y

	# edges 
	var touching_left = relative_tpos.x <= pushbox_top_left.x
	var touching_right = relative_tpos.x >= pushbox_bottom_right.x
	var touching_top = relative_tpos.z >= pushbox_top_left.y
	var touching_bottom = relative_tpos.z <= pushbox_bottom_right.y

	#
	var camera_move_x = 0.0
	var camera_move_z = 0.0

	if in_middle_region:
		#  if in middle use the ratio
		camera_move_x = tvel.x * push_ratio * delta
		camera_move_z = tvel.z * push_ratio * delta
	else:
		# now if touching edge or border go normal
		if touching_left:
			camera_move_x = tvel.x * delta
		elif touching_right:
			camera_move_x = tvel.x * delta

		if touching_top:
			camera_move_z = tvel.z * delta  
		elif touching_bottom:
			camera_move_z = tvel.z * delta  
			

	# Apply the calculated movement to the camera's position
	global_position += Vector3(camera_move_x, 0, camera_move_z)
	
	super(delta)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()

	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	#coords for outer
	var left = pushbox_top_left.x
	var right = pushbox_bottom_right.x
	var top = pushbox_top_left.y
	var bottom = pushbox_bottom_right.y

	# outer
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))

	# cords for inner
	var s_left = speedup_zone_top_left.x
	var s_right = speedup_zone_bottom_right.x
	var s_top = speedup_zone_top_left.y
	var s_bottom = speedup_zone_bottom_right.y

	# inner
	immediate_mesh.surface_add_vertex(Vector3(s_right, 0, s_top))
	immediate_mesh.surface_add_vertex(Vector3(s_right, 0, s_bottom))
	immediate_mesh.surface_add_vertex(Vector3(s_right, 0, s_bottom))
	immediate_mesh.surface_add_vertex(Vector3(s_left, 0, s_bottom))
	immediate_mesh.surface_add_vertex(Vector3(s_left, 0, s_bottom))
	immediate_mesh.surface_add_vertex(Vector3(s_left, 0, s_top))
	immediate_mesh.surface_add_vertex(Vector3(s_left, 0, s_top))
	
	immediate_mesh.surface_add_vertex(Vector3(s_right, 0, s_top))

	immediate_mesh.surface_end()


	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	await get_tree().process_frame
	mesh_instance.queue_free()
