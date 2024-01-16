extends Node3D

var bullet = load('res://MainGame/Weapons/TestWeapon/Bullet.tscn')
@onready var ray = $BulletSpawn/Ray
@onready var time = $Timer
var shoot : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed('lmb')  && time.is_stopped():
		shooting()
	if Input.is_action_just_released('lmb') :
		time.stop()
		get_parent().get_parent().shooting = false
		



func shooting():
	get_parent().get_parent().shooting = true
	var create_bullet = bullet.instantiate()
	create_bullet.position = ray.position
	create_bullet.transform.basis = ray.transform.basis
	ray.add_child(create_bullet)
	time.start()
	await time.timeout
	time.stop()

