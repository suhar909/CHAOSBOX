# CHAOSBOX — development notes

## Foundation build (Stage 1)

The project is configured for Godot 4.x using the Compatibility renderer and launches `scenes/main/main.tscn`. The scene assembles a small modular prototype at runtime:

- An open test yard with perimeter walls, a marked test lane, workshop, partitioned lab, garage, and obstacle course.
- Directional sunlight, a procedural sky, ambient lighting, and low-cost yard beacons.
- A `CharacterBody3D` player with mouse-look, first-/third-person camera toggle, sprint, jump, crouch, movement bob, and a simple visible avatar/first-person arms.
- A minimal HUD with control hints, pause overlay, and a clearly-labelled future-tools information panel.

### Known limitations

This is the playable foundation only. The TAB panel is informational, not yet an object spawn menu. The third-person camera is a basic offset camera; collision avoidance is not implemented. The player avatar and environment use procedural built-in primitives. No NPC, physics tool, resource catalogue, world saving, or ragdoll system is included in this stage.

### Verification

The repository tools do not provide a Godot runtime or terminal here, so the project could not be launched in headless mode. The project and scripts were reviewed for Godot 4 syntax, but runtime testing remains to be done in the Godot editor.
