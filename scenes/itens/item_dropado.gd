extends Node3D

@export var item: Item
@export var mesh: MeshInstance3D

@export var modelo: Node3D

func _ready() -> void:
	mesh.mesh = item.mesh
	
func _process(_delta):
	var camera_pos = get_viewport().get_camera_3d().global_transform.origin
	camera_pos.y = 0
	modelo.look_at(camera_pos, Vector3(0, 1, 0))

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("jogador"):
		if (body.adicionar_ao_inventario(item)):
			queue_free()
		
