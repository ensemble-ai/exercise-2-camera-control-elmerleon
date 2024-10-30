class_name AutoScroll
extends CameraControllerBase

@export var autoscroll_speed: Vector3 = Vector3(0.05, 0, 0.05)
@export var top_left: Vector2 = Vector2(-10, 10)   
@export var bottom_right: Vector2 = Vector2(10, -10)  

var frame_left: float
var frame_right: float
var frame_top: float
var frame_bottom: float
var camera_height: float = 10.0  

func _ready() -> void:
	super()
	# Initialize frame boundaries
	frame_left = top_left.x
	frame_right = bottom_right.x
	frame_top = top_left.y  
	frame_bottom = bottom_right.y  

	# Center the camera at the vessel's position
	global_position = target.global_position
	global_position.y = target.global_position.y + camera_height

func _process(delta: float) -> void:
	if !current:
		return

	super(delta)  # Call base class process first

	if draw_camera_logic:
		draw_logic()

	# Autoscroll the frame
	var scroll_x = autoscroll_speed.x * delta
	var scroll_z = autoscroll_speed.z * delta

	# Move the frame boundaries
	frame_left += scroll_x
	frame_right += scroll_x
	frame_top += scroll_z
	frame_bottom += scroll_z

	# Keep the camera centered on the autoscrolling frame
	global_position.x = (frame_left + frame_right) / 2
	global_position.z = (frame_top + frame_bottom) / 2
	global_position.y = target.global_position.y + camera_height  

	# Move the vessel along with the frame by adjusting its position
	target.global_position.x += scroll_x
	target.global_position.z += scroll_z

	# Boundary checks to constrain the vessel within the frame
	var tpos = target.global_position

	# Left edge: Push the player forward if they touch the left edge
	if tpos.x < frame_left:
		target.global_position.x = frame_left
	# Right edge
	if tpos.x > frame_right:
		target.global_position.x = frame_right
	# Top edge
	if tpos.z > frame_top:
		target.global_position.z = frame_top
	# Bottom edge
	if tpos.z < frame_bottom:
		target.global_position.z = frame_bottom

func draw_logic() -> void:
	var mesh_instance = MeshInstance3D.new()
	var immediate_mesh = ImmediateMesh.new()
	var material = StandardMaterial3D.new()

	# Set material properties before drawing
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	var vessel_y = target.global_position.y  # Use the vessel's Y position

	# Draw the frame border box using frame boundaries at the vessel's Y position
	immediate_mesh.surface_add_vertex(Vector3(frame_left, vessel_y, frame_top))
	immediate_mesh.surface_add_vertex(Vector3(frame_right, vessel_y, frame_top))

	immediate_mesh.surface_add_vertex(Vector3(frame_right, vessel_y, frame_top))
	immediate_mesh.surface_add_vertex(Vector3(frame_right, vessel_y, frame_bottom))

	immediate_mesh.surface_add_vertex(Vector3(frame_right, vessel_y, frame_bottom))
	immediate_mesh.surface_add_vertex(Vector3(frame_left, vessel_y, frame_bottom))

	immediate_mesh.surface_add_vertex(Vector3(frame_left, vessel_y, frame_bottom))
	immediate_mesh.surface_add_vertex(Vector3(frame_left, vessel_y, frame_top))

	immediate_mesh.surface_end()

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY

	# Free the mesh after one frame
	await get_tree().process_frame
	mesh_instance.queue_free()
