extends StaticBody3D

@export var amount = 90

func body_in(body):
	if body.get("PLAYER"):
		body.position.x = position.x
		body.position.z = position.z
		body.rot8(amount)

func _process(delta):
	var cam = get_viewport().get_camera_3d()
	var dist = (global_position - cam.global_position).project(cam.get_global_transform().basis.z).length()
	$MeshInstance3D.set_instance_shader_parameter("Distance", dist)
