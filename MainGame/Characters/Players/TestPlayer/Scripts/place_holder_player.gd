extends CharacterBody3D


var SPEED = 6.0
const JUMP_VELOCITY = 8.5
var mouse_sense = 0.01
@export var push_speed : float = 80
var stomp : bool = false
var spring_jumping : bool = false
var shooting : bool = false
var runnin : bool = false
var hit : bool = false
@onready var hit_cool_down = $HitCoolDown




@onready 	var model = $JazzModel

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	get_meta('PlayerInfo').health = get_meta('PlayerInfo').hearts
	$JazzModel/Armature/Skeleton3D/Model_002.get_active_material(0).albedo_color = Color.WHITE


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
		
	if is_on_floor():
		gravity = 9.8
		stomp = false

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("s") && not is_on_floor() && not stomp:
		stomp = true
		

		
		
	if stomp:
		spring_jumping = false
		gravity = 25
		$JazzModel.rotate_y(0.5)


	if not stomp:
		
		var move_dir := Vector3.ZERO
		move_dir.x = Input.get_axis("a", "d")
		move_dir.z = Input.get_axis("w", "s")
		
		move_dir = move_dir.rotated(Vector3.UP, $cam.rotation.y).normalized()
		
		if Input.is_action_pressed('q'):
			if move_dir:
				$JazzModel/RunParticles.emitting = true
			SPEED = 10.0
		if Input.is_action_just_released('q'):
			$JazzModel/RunParticles.emitting = false
			SPEED = 6.0
		
		
		velocity = Vector3(move_dir.x *SPEED, velocity.y, move_dir.z *SPEED)

		if move_dir:
			if not shooting:
				$JazzModel/AnimationPlayer.play('Run')
			runnin = true
			var dir = Vector2(velocity.z, velocity.x)
			$JazzModel.rotation.y = dir.angle()
		elif not move_dir:
			runnin = false
			if not shooting:
				$JazzModel/AnimationPlayer.play('Idle')
	move_and_slide()
	jumping_on_spring()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			if stomp:
				velocity.y = JUMP_VELOCITY
				c.get_collider().get_node("Destruction").destroy()
				GlobalStuff.score += 50
				stomp = false
				
			c.get_collider().apply_central_impulse(-c.get_normal() * push_speed)
			
	gun_shooting()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("rmb"):
			$cam.rotation.x -= event.relative.y * mouse_sense
			$cam.rotation.x = clamp($cam.rotation.x, -1,0.3)

			
			$cam.rotation.y -= event.relative.x *mouse_sense



func _on_player_coll_area_entered(area: Area3D) -> void:
	if area.name == "SpringColl":
		spring_sping_time()
		velocity.y = JUMP_VELOCITY + area.get_parent().get_parent().spring_power
		area.get_parent().get_parent().get_node("SpringAnimation").play("RESET")
		area.get_parent().get_parent().get_node("SpringAnimation").play("Bounce")
		
		
	if area.name == "EnemyColl" && stomp:
		velocity.y = JUMP_VELOCITY
		area.get_parent().queue_free()
		GlobalStuff.score += 100
		stomp = false
		
	elif area.name == "EnemyColl" && not stomp && not hit:
		taking_damage()
	
		
		


func taking_damage():
	hit = true
	hit_cool_down.wait_time = 1
	hit_cool_down.start()
	$JazzModel/Armature/Skeleton3D/Model_002.get_active_material(0).albedo_color = Color.INDIAN_RED
	get_meta('PlayerInfo').health = clamp(get_meta('PlayerInfo').health-1, 0,5)
	if get_meta('PlayerInfo').health <= 0:
		if get_meta('PlayerInfo').lives <= 0:
			get_tree().change_scene_to_file("res://MainGame/MenuScreen/menu.tscn")
		else:
			get_meta('PlayerInfo').lives -= 1
			get_tree().reload_current_scene()
	await hit_cool_down.timeout
	$JazzModel/Armature/Skeleton3D/Model_002.get_active_material(0).albedo_color = Color.WHITE
	hit = false


func jumping_on_spring():
	if spring_jumping && not is_on_floor():
		stomp = false
		$JazzModel.rotate_y(-0.2)

func spring_sping_time():
	spring_jumping = true
	$Timer.wait_time = 0.5
	$Timer.start()
	await $Timer.timeout
	spring_jumping = false


func gun_shooting():
	if shooting:
		if not runnin:
			$JazzModel/AnimationPlayer.play('IdleShoot')
		elif runnin:
			$JazzModel/AnimationPlayer.play('RunShoot')
