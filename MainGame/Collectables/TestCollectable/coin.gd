extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	rotate_y(0.1)


func _on_col_area_entered(area: Area3D) -> void:
	if area.name == "PlayerColl":
		GlobalStuff.coins += 1
		queue_free()
