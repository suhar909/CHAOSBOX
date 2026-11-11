extends CanvasLayer

var root_ui: Control
var status_label: Label
var crosshair: Label
var pause_panel: PanelContainer
var spawn_panel: PanelContainer

func _ready() -> void:
	_build_ui()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _build_ui() -> void:
	root_ui = Control.new()
	root_ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(root_ui)

	crosshair = Label.new()
	crosshair.text = "+"
	crosshair.add_theme_font_size_override("font_size", 26)
	crosshair.add_theme_color_override("font_color", Color(0.55, 0.96, 0.94))
	crosshair.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	crosshair.position = Vector2(-8, -18)
	root_ui.add_child(crosshair)

	var title := Label.new()
	title.text = "CHAOSBOX  /  TEST SITE"
	title.position = Vector2(28, 22)
	title.add_theme_font_size_override("font_size", 18)
	title.add_theme_color_override("font_color", Color(0.45, 0.91, 0.88))
	root_ui.add_child(title)

	status_label = Label.new()
	status_label.text = "WASD move   SHIFT sprint   SPACE jump   CTRL crouch\nV camera   TAB spawn tools   ESC pause"
	status_label.position = Vector2(28, 54)
	status_label.add_theme_font_size_override("font_size", 15)
	status_label.add_theme_color_override("font_color", Color(0.88, 0.92, 0.94))
	root_ui.add_child(status_label)

	pause_panel = _make_panel("PAUSED", "CHAOSBOX prototype\n\nPress ESC to resume.\nTAB opens the tool information.")
	pause_panel.visible = false
	spawn_panel = _make_panel("SANDBOX TOOLS", "Foundation build\n\nGravity Manipulator and object catalogue arrive in the next development stages.\n\nPress TAB to close.")
	spawn_panel.visible = false

func _make_panel(heading: String, body: String) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(480, 250)
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel.position = Vector2(-240, -125)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.045, 0.075, 0.095, 0.96)
	style.border_color = Color(0.2, 0.75, 0.72, 0.9)
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	panel.add_theme_stylebox_override("panel", style)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 14)
	panel.add_child(column)
	var title := Label.new()
	title.text = heading
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 25)
	title.add_theme_color_override("font_color", Color(0.47, 0.95, 0.87))
	column.add_child(title)
	var content := Label.new()
	content.text = body
	content.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	content.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_theme_font_size_override("font_size", 17)
	content.add_theme_color_override("font_color", Color(0.87, 0.91, 0.93))
	column.add_child(content)
	root_ui.add_child(panel)
	return panel

func toggle_spawn_hint() -> void:
	spawn_panel.visible = not spawn_panel.visible
	if spawn_panel.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func set_paused(value: bool) -> void:
	pause_panel.visible = value
	if value:
		spawn_panel.visible = false
