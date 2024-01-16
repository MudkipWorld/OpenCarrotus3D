extends CharacterBody3D


const SPEED = 4.0
var target_pos : Vector3
var accel = 10
@onready var nav = $NavigationAgent3D
@onready var ray = $TurtlePlaceholder/RayCast3D



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	target_pos = Vector3(randf_range(position.x -5, position.x +5), position.y,randf_range(position.z -5, position.z +5) )
	nav.target_position = target_pos


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	
	if not ray.is_colliding():
		target_pos = Vector3(randf_range(position.x -5, position.x +5), position.y,randf_range(position.z -5, position.z +5) )
		nav.target_position = target_pos
	
	elif is_on_wall():
		target_pos = Vector3(randf_range(position.x -5, position.x +5), position.y,randf_range(position.z -5, position.z +5) )
		nav.target_position = target_pos
	
	if is_on_floor():
		var move_dire = Vector3()
		move_dire = nav.get_next_path_position() - nav.target_position
		move_dire = move_dire.normalized()
	
	
	
		velocity = velocity.lerp(move_dire * SPEED, accel * delta)
		if move_dire:
			var dir = Vector2(velocity.z, velocity.x)
			$TurtlePlaceholder.rotation.y = dir.angle()


	move_and_slide()


func _on_navigation_agent_3d_target_reached() -> void:
	target_pos = Vector3(randf_range(position.x -5, position.x +5), position.y,randf_range(position.z -5, position.z +5) )
	nav.target_position = target_pos

