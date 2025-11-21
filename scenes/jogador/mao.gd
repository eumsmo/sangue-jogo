extends Node3D

@export var itemEmMaoMesh: MeshInstance3D

func botar_na_mao(item: Item):
	if item == null:
		itemEmMaoMesh.visible = false
	else:
		itemEmMaoMesh.mesh = item.mesh
		itemEmMaoMesh.visible = true
