extends Node3D

var speed = 80
var explosion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	delete()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0 , speed, 0) * delta
	


func delete():
	await get_tree().create_timer(1).timeout
	queue_free()


func _on_bullet_coll_area_entered(area: Area3D) -> void:
	if area.name == "ObjColl":
		area.get_parent().get_node("Destruction").destroy()
		GlobalStuff.score += 50
		queue_free()

	if area.name == "EnemyColl":
		area.get_parent().queue_free()
		GlobalStuff.score += 100
		queue_free()
