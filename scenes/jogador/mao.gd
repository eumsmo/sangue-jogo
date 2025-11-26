extends Node3D

@export var itemEmMaoMesh: MeshInstance3D
var item_segurado: Item = null

var livre:
	get:
		return not itemEmMaoMesh.visible

func botar_na_mao(item: Item):
	if item == null:
		itemEmMaoMesh.visible = false
	else:
		itemEmMaoMesh.mesh = item.mesh
		itemEmMaoMesh.visible = true
	
	item_segurado = item

func remover_da_mao() -> Item:
	var item = item_segurado
	item_segurado = null
	return item
