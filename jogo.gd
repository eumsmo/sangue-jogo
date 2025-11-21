class_name GameManager
extends Node3D

static var instance: GameManager

@export_group("Referências")
@export_subgroup("Valores de uso externo")
@export var iteracoes_de_sala := 2 ## Idealmente sempre será igual a 2 (maior que isso pode quebrar)
@export_subgroup("Recursos")
@export var probabilidade_de_tipos: ProbTipoSala
@export var probabilidade_por_tipo: Dictionary[Enums.TipoSala, ProbSalas]
@export_subgroup("Mundo")
@export var salas_holder: Node3D

func _init():
	instance = self
	
func adicionar_sala(sala: Node3D):
	salas_holder.add_child.call_deferred(sala)
