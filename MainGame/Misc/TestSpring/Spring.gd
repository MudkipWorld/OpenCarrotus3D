extends StaticBody3D

@export var spring_power : float = 1
@export var spring_color : Material

func _ready() -> void:
	var top_color = $Top
	top_color.set_surface_override_material(0,spring_color)

