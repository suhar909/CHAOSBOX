extends Node3D

const PLAYER_SCRIPT: Script = preload("res://scripts/player/player_controller.gd")
const MAP_SCRIPT: Script = preload("res://scripts/maps/test_site.gd")
const HUD_SCRIPT: Script = preload("res://scripts/ui/game_hud.gd")

var player: CharacterBody3D
var hud: CanvasLayer
var paused := false

func _ready() -> void:
	_build_environment()
	var test_site := Node3D.new()
	test_site.name = "TestSite"
	test_site.set_script(MAP_SCRIPT)
	add_child(test_site)
	test_site.build()

	player = CharacterBody3D.new()
	player.name = "Player"
	player.set_script(PLAYER_SCRIPT)
	player.position = Vector3(0, 1.2, 8)
	add_child(player)

	hud = CanvasLayer.new()
	hud.name = "GameHUD"
	hud.set_script(HUD_SCRIPT)
	add_child(hud)

func _build_environment() -> void:
	var world_environment := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_SKY
	environment.sky = Sky.new()
	var sky_material := ProceduralSkyMaterial.new()
	sky_material.sky_top_color = Color(0.12, 0.22, 0.34)
	sky_material.sky_horizon_color = Color(0.62, 0.72, 0.78)
	sky_material.ground_bottom_color = Color(0.12, 0.14, 0.16)
	sky_material.ground_horizon_color = Color(0.48, 0.53, 0.55)
	environment.sky.sky_material = sky_material
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.52, 0.61, 0.72)
	environment.ambient_light_energy = 0.65
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	world_environment.environment = environment
	add_child(world_environment)

	var sun := DirectionalLight3D.new()
	sun.name = "Sun"
	sun.rotation_degrees = Vector3(-48, -32, 0)
	sun.light_color = Color(1.0, 0.88, 0.72)
	sun.light_energy = 1.25
	sun.shadow_enabled = true
	add_child(sun)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.physical_keycode == KEY_ESCAPE:
			_set_paused(not paused)
		elif event.physical_keycode == KEY_TAB and not paused:
			hud.toggle_spawn_hint()

func _set_paused(value: bool) -> void:
	paused = value
	get_tree().paused = paused
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CAPTURED
	hud.set_paused(paused)
