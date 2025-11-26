extends Node

const size := 1
var inventario: Array[Item]
var inv_index_left := 0
var inv_index_right := 0

signal on_slot_change(slot_idx: int, item: Item)

func _ready() -> void:
	for i in range(0,size):
		inventario.append(null)
		on_slot_change.emit(i, null)

func adicionar_pela_esquerda(item: Item) -> bool:
	for i in range(0, len(inventario)):
		if inventario[i] == null:
			inventario[i] = item
			on_slot_change.emit(i, item)
			print("+inventario: " + str(inventario))
			return true
			
	return false
	

func adicionar_pela_direita(item: Item) -> bool:
	for i in range(len(inventario)-1, -1,-1):
		if inventario[i] == null:
			inventario[i] = item
			on_slot_change.emit(i, item)
			print("+inventario: " + str(inventario))
			return true
		
	return false


func pegar_pela_esquerda(resetar_index := false) -> Item:
	if resetar_index or inv_index_left >= len(inventario):
		inv_index_left = 0
	
	var item = null
	for i in range(inv_index_left, len(inventario)):
		if inventario[i] != null:
			item = inventario[i]
			inventario[i] = null
			inv_index_left = i
			on_slot_change.emit(i, null)
			print("-inventario: " + str(inventario))
			break
	
	return item

func pegar_pela_direita(resetar_index := false) -> Item:
	if resetar_index or inv_index_right < 0:
		inv_index_right = len(inventario) - 1
	
	var item = null
	for i in range(inv_index_right, -1, -1):
		if inventario[i] != null:
			item = inventario[i]
			inventario[i] = null
			inv_index_right = i
			on_slot_change.emit(i, null)
			print("-inventario: " + str(inventario))
			break
	
	return item


func tem_espaco() -> bool:
	if len(inventario) < size:
		return true
	
	for i in range(0, len(inventario)):
		if inventario[i] == null:
			return true
	
	return false
