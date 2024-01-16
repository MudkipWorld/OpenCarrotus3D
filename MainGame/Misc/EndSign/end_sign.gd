extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_end_coll_area_entered(area: Area3D) -> void:
	if area.name == "PlayerColl":
		print("Win! :D")
		get_tree().change_scene_to_file("res://MainGame/MenuScreen/menu.tscn")
