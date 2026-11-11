extends CharacterBody3D

const WALK_SPEED := 5.2
const RUN_SPEED := 8.3
const CROUCH_SPEED := 2.7
const MOUSE_SENSITIVITY := 0.0022
const CAMERA_LERP := 10.0

var camera_pivot: Node3D
var camera: Camera3D
var body_visual: Node3D
var first_person_arms: Node3D
var collision_shape: CollisionShape3D
var is_third_person := false
var is_crouching := false
var pitch := 0.0
var bob_time := 0.0
var default_camera_position := Vector3.ZERO

func _ready() -> void:
	_build_character()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _build_character() -> void:
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.38
	capsule.height = 1.8
	collision_shape = CollisionShape3D.new()
	collision_shape.name = "CollisionShape"
	collision_shape.shape = capsule
	collision_shape.position.y = 0.9
	add_child(collision_shape)

	body_visual = Node3D.new()
	body_visual.name = "CharacterVisual"
	add_child(body_visual)
	_add_visual_capsule(body_visual, Vector3(0, 0.9, 0), 0.36, 1.55, Color(0.11, 0.75, 0.79))
	_add_visual_sphere(body_visual, Vector3(0, 1.85, 0), 0.25, Color(0.94, 0.69, 0.48))
	_add_visual_box(body_visual, Vector3(-0.49, 1.02, 0), Vector3(0.22, 0.75, 0.24), Color(0.08, 0.47, 0.53))
	_add_visual_box(body_visual, Vector3(0.49, 1.02, 0), Vector3(0.22, 0.75, 0.24), Color(0.08, 0.47, 0.53))

	camera_pivot = Node3D.new()
	camera_pivot.name = "CameraPivot"
	camera_pivot.position.y = 1.58
	add_child(camera_pivot)
	camera = Camera3D.new()
	camera.name = "PlayerCamera"
	camera.current = true
	camera.fov = 78.0
	camera_pivot.add_child(camera)

	first_person_arms = Node3D.new()
	first_person_arms.name = "FirstPersonArms"
	camera.add_child(first_person_arms)
	_add_visual_box(first_person_arms, Vector3(-0.31, -0.34, -0.58), Vector3(0.17, 0.48, 0.18), Color(0.08, 0.47, 0.53))
	_add_visual_box(first_person_arms, Vector3(0.31, -0.34, -0.58), Vector3(0.17, 0.48, 0.18), Color(0.08, 0.47, 0.53))
	default_camera_position = Vector3.ZERO

func _add_visual_capsule(parent: Node3D, at: Vector3, radius: float, height: float, color: Color) -> void:
	var instance := MeshInstance3D.new()
	var mesh := CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	instance.mesh = mesh
	instance.position = at
	instance.material_override = _material(color)
	parent.add_child(instance)

func _add_visual_sphere(parent: Node3D, at: Vector3, radius: float, color: Color) -> void:
	var instance := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	instance.mesh = mesh
	instance.position = at
	instance.material_override = _material(color)
	parent.add_child(instance)

func _add_visual_box(parent: Node3D, at: Vector3, size: Vector3, color: Color) -> void:
	var instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	instance.mesh = mesh
	instance.position = at
	instance.material_override = _material(color)
	parent.add_child(instance)

func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.78
	return material

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		pitch = clampf(pitch - event.relative.y * MOUSE_SENSITIVITY, deg_to_rad(-82), deg_to_rad(82))
		camera_pivot.rotation.x = pitch
	elif event is InputEventKey and event.pressed and not event.echo:
		if event.physical_keycode == KEY_V:
			is_third_person = not is_third_person
			body_visual.visible = is_third_person
			first_person_arms.visible = not is_third_person
		elif event.physical_keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_A): input_vector.x -= 1.0
	if Input.is_physical_key_pressed(KEY_D): input_vector.x += 1.0
	if Input.is_physical_key_pressed(KEY_W): input_vector.y += 1.0
	if Input.is_physical_key_pressed(KEY_S): input_vector.y -= 1.0
	input_vector = input_vector.normalized()
	var direction := (global_transform.basis * Vector3(input_vector.x, 0, -input_vector.y)).normalized()

	is_crouching = Input.is_physical_key_pressed(KEY_CTRL)
	var speed := CROUCH_SPEED if is_crouching else RUN_SPEED if Input.is_physical_key_pressed(KEY_SHIFT) else WALK_SPEED
	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed * 7.0 * delta)
		velocity.z = move_toward(velocity.z, 0.0, speed * 7.0 * delta)

	if not is_on_floor():
		velocity.y -= 20.0 * delta
	elif Input.is_physical_key_pressed(KEY_SPACE):
		velocity.y = 6.2

	var capsule := collision_shape.shape as CapsuleShape3D
	var target_height := 1.2 if is_crouching else 1.8
	capsule.height = move_toward(capsule.height, target_height, 3.0 * delta)
	collision_shape.position.y = capsule.height * 0.5
	camera_pivot.position.y = move_toward(camera_pivot.position.y, 1.05 if is_crouching else 1.58, 5.0 * delta)
	move_and_slide()

	var moving := Vector2(velocity.x, velocity.z).length() > 0.5 and is_on_floor()
	if moving:
		bob_time += delta * (13.0 if speed == RUN_SPEED else 9.0)
	else:
		bob_time = move_toward(bob_time, 0.0, delta * 5.0)
	var bob := sin(bob_time) * (0.035 if speed == RUN_SPEED else 0.022) if moving else 0.0
	var camera_target := Vector3(0, bob, 4.2) if is_third_person else Vector3(0, bob, 0)
	camera.position = camera.position.lerp(camera_target, minf(CAMERA_LERP * delta, 1.0))
