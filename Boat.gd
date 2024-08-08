extends Node3D

@export var float_force := 3.0

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var boat = $RigidBody3D
@onready var probes = $RigidBody3D/ProbeContainer.get_children()
@onready var physics_material = PhysicsMaterial.new()

@export var wave_a = Vector3(1.0, 0.4, 10.0)
@export var wave_a_dir = Vector2(1.0, 0.0)

@export var wave_b = Vector3(1.0, 0.25, 20.0)
@export var wave_b_dir = Vector2(1.0, 1.0)

@export var wave_c = Vector3(1.0, 0.15, 1.0)
@export var wave_c_dir = Vector2(1.0, 0.5)
@export var time: float = 0.0

var submerged := false

func _ready():
	physics_material.friction = 0
	boat.physics_material_override = physics_material

func _physics_process(delta):
	time += delta
	submerged = false
	update_probes()
	for p in probes:
		var water_height = get_height(p.global_position)
		var depth = water_height - p.global_position.y
		if depth > 0:
			submerged = true
			apply_buoyancy_force(p, depth)

func get_gerstner_wave_height(wave, wave_dir, position, time):
	var amplitude = wave.x
	var steepness = wave.y
	var wavelength = wave.z

	var k = 2.0 * PI / wavelength
	var c = sqrt(9.8 / k)
	var d = wave_dir.normalized()
	var f = k * (d.dot(Vector2(position.x, position.z)) - (c * time))
	var a = steepness / k

	return amplitude * a * sin(f)

func get_height(position):
	var height = 0.0
	height += get_gerstner_wave_height(wave_a, wave_a_dir, position, time / 2.0)
	height += get_gerstner_wave_height(wave_b, wave_b_dir, position, time / 2.0)
	height += get_gerstner_wave_height(wave_c, wave_c_dir, position, time / 2.0)

	return height

func apply_buoyancy_force(p, depth):
	# Apply the buoyancy force at the probe's position
	var buoyancy_force = Vector3.UP * float_force * gravity * depth
	boat.apply_force(buoyancy_force, p.global_position - boat.global_transform.origin)

# Ensure probes' positions are updated
func update_probes():
	for p in probes:
		# Ensure the probes follow the boat's transformation
		p.global_transform = p.global_transform
