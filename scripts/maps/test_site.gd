extends Node3D

const FLOOR_SIZE := Vector3(64, 1, 64)

var concrete := StandardMaterial3D.new()
var dark_concrete := StandardMaterial3D.new()
var accent := StandardMaterial3D.new()
var metal := StandardMaterial3D.new()

func _ready() -> void:
	concrete.albedo_color = Color(0.29, 0.34, 0.37)
	concrete.roughness = 0.88
	dark_concrete.albedo_color = Color(0.13, 0.18, 0.21)
	dark_concrete.roughness = 0.92
	accent.albedo_color = Color(0.95, 0.48, 0.16)
	accent.metallic = 0.25
	metal.albedo_color = Color(0.33, 0.42, 0.46)
	metal.metallic = 0.72
	metal.roughness = 0.38

func build() -> void:
	_add_box("Open Test Yard", Vector3(0, -0.5, 0), FLOOR_SIZE, concrete, true)
	_build_yard_boundaries()
	_build_workshop()
	_build_lab()
	_build_garage()
	_build_obstacle_course()
	_build_lighting_props()

func _build_yard_boundaries() -> void:
	_add_box("North perimeter", Vector3(0, 2, -32), Vector3(64, 4, 0.6), dark_concrete, true)
	_add_box("South perimeter", Vector3(0, 2, 32), Vector3(64, 4, 0.6), dark_concrete, true)
	_add_box("West perimeter", Vector3(-32, 2, 0), Vector3(0.6, 4, 64), dark_concrete, true)
	_add_box("East perimeter", Vector3(32, 2, 0), Vector3(0.6, 4, 64), dark_concrete, true)
	for i in range(8):
		var x := -24.0 + float(i) * 7.0
		_add_box("Yard stripe %02d" % i, Vector3(x, 0.012, 0), Vector3(0.12, 0.02, 48), accent, false)
	_add_box("Yard center marker", Vector3(0, 0.02, 0), Vector3(4, 0.04, 4), metal, false)

func _build_workshop() -> void:
	var origin := Vector3(20, 0, -18)
	_add_box("Workshop back wall", origin + Vector3(0, 3, -7), Vector3(20, 6, 0.6), dark_concrete, true)
	_add_box("Workshop left wall", origin + Vector3(-10, 3, 0), Vector3(0.6, 6, 14), dark_concrete, true)
	_add_box("Workshop right wall", origin + Vector3(10, 3, 0), Vector3(0.6, 6, 14), dark_concrete, true)
	_add_box("Workshop roof", origin + Vector3(0, 6.2, 0), Vector3(20, 0.4, 14), metal, true)
	_add_box("Workshop bench", origin + Vector3(-5, 1, -3), Vector3(5, 2, 1.2), metal, true)
	_add_box("Workshop storage", origin + Vector3(5, 1.2, -4), Vector3(3, 2.4, 2), accent, true)
	_add_box("Workshop partition", origin + Vector3(0, 1.5, 2), Vector3(0.4, 3, 5), dark_concrete, true)
	_add_label_marker("WORKSHOP", origin + Vector3(0, 5.2, 6.6))

func _build_lab() -> void:
	var origin := Vector3(-20, 0, -18)
	_add_box("Lab rear wall", origin + Vector3(0, 2.5, -6), Vector3(16, 5, 0.5), dark_concrete, true)
	_add_box("Lab left wall", origin + Vector3(-8, 2.5, 0), Vector3(0.5, 5, 12), dark_concrete, true)
	_add_box("Lab right wall", origin + Vector3(8, 2.5, 0), Vector3(0.5, 5, 12), dark_concrete, true)
	_add_box("Lab room divider", origin + Vector3(0, 2, 1), Vector3(0.35, 4, 8), metal, true)
	_add_box("Lab instrument table", origin + Vector3(-4, 1, -2), Vector3(4, 2, 1.5), accent, true)
	_add_box("Lab instrument table 2", origin + Vector3(4, 1, 3), Vector3(4, 2, 1.5), metal, true)
	_add_label_marker("TEST LAB", origin + Vector3(0, 4.2, 5.6))

func _build_garage() -> void:
	var origin := Vector3(20, 0, 17)
	_add_box("Garage rear wall", origin + Vector3(0, 2.5, -6), Vector3(16, 5, 0.5), dark_concrete, true)
	_add_box("Garage left wall", origin + Vector3(-8, 2.5, 0), Vector3(0.5, 5, 12), dark_concrete, true)
	_add_box("Garage right wall", origin + Vector3(8, 2.5, 0), Vector3(0.5, 5, 12), dark_concrete, true)
	_add_box("Garage roof", origin + Vector3(0, 5.2, 0), Vector3(16, 0.4, 12), metal, true)
	_add_box("Garage service pit", origin + Vector3(0, -0.12, 0), Vector3(3, 0.18, 7), accent, false)
	_add_label_marker("GARAGE", origin + Vector3(0, 4.2, 5.6))

func _build_obstacle_course() -> void:
	for i in range(5):
		var x := -18.0 + float(i) * 4.0
		_add_box("Test block %02d" % i, Vector3(x, 0.65, 14), Vector3(2.2, 1.3, 2.2), metal if i % 2 == 0 else accent, true)
	_add_box("Low ramp", Vector3(-12, 0.45, 24), Vector3(8, 0.5, 4), accent, true).rotation_degrees.y = -10
	_add_box("Barrier A", Vector3(-2, 1.1, 23), Vector3(0.5, 2.2, 7), dark_concrete, true)
	_add_box("Barrier B", Vector3(5, 0.7, 26), Vector3(5, 1.4, 0.5), metal, true)
	_add_label_marker("PHYSICS COURSE", Vector3(-2, 3, 29))

func _build_lighting_props() -> void:
	for i in range(4):
		var x := -24.0 + float(i) * 16.0
		_add_box("Beacon base %d" % i, Vector3(x, 0.45, -1), Vector3(0.8, 0.9, 0.8), metal, true)
		var lamp := OmniLight3D.new()
		lamp.position = Vector3(x, 3, -1)
		lamp.light_color = Color(0.25, 0.75, 1.0)
		lamp.light_energy = 1.1
		lamp.omni_range = 9
		lamp.shadow_enabled = false
		add_child(lamp)

func _add_label_marker(text: String, at: Vector3) -> void:
	var post := _add_box(text + " sign", at + Vector3(0, -1.6, 0), Vector3(0.14, 3.2, 0.14), accent, true)
	post.name = text.replace(" ", "_") + "_SignPost"
	_add_box(text + " sign panel", at, Vector3(4.5, 0.8, 0.18), dark_concrete, true)

func _add_box(label: String, at: Vector3, size: Vector3, material: Material, solid: bool) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = label.replace(" ", "_")
	body.position = at
	var mesh_instance := MeshInstance3D.new()
	var box_mesh := BoxMesh.new()
	box_mesh.size = size
	mesh_instance.mesh = box_mesh
	mesh_instance.material_override = material
	body.add_child(mesh_instance)
	if solid:
		var collision := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = size
		collision.shape = shape
		body.add_child(collision)
	add_child(body)
	return body
