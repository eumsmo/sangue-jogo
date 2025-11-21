class_name Sala
extends Node3D

@export var tipo: Enums.TipoSala

@export_subgroup("UI")
@export var saidas_holder: Node3D

var vizinhos: Dictionary[Node, Sala]
var anterior: Sala

var destruindo := false

func setup(sala_geradora: Sala):
	anterior = sala_geradora

func gerar_vizinhos():
	for saida in saidas_holder.get_children():
		if vizinhos.has(saida) and vizinhos[saida] != null:
			print("Não é necessário gerar vizinhos de " + saida.name)
			continue
		
		var sala = gerar_sala()
		sala.global_position = saida.global_position
		sala.rotation = rotation + saida.rotation
		vizinhos[saida] = sala
		sala.setup(self)
		
		GameManager.instance.adicionar_sala(sala)
	
	if anterior == null:
		var sala = gerar_sala()
		sala.global_position = global_position
		sala.rotation_degrees = rotation_degrees + Vector3(0,180,0)
		anterior = sala
		sala.setup(self)
		
		GameManager.instance.adicionar_sala(sala)

func gerar_sala() -> Node3D:
	var tipo_escolhido = Global.prob_por_pontos_dict(GameManager.instance.probabilidade_de_tipos.tipos)
	
	if tipo_escolhido == null:
		return null
	
	tipo_escolhido = tipo_escolhido as Enums.TipoSala
	var prob_salas = GameManager.instance.probabilidade_por_tipo[tipo_escolhido]
	
	var sala_escolhida = Global.prob_por_pontos_dict(prob_salas.salas)
	if sala_escolhida == null:
		return null
	
	var sala = sala_escolhida.instantiate()
	return sala

func check_distancia(iteracao := 0, chamada_de: Sala = null):
	if iteracao > GameManager.instance.iteracoes_de_sala:
		auto_destruir(chamada_de)
		return
	
	for vizinho in vizinhos.values():
		if vizinho == null or vizinho == chamada_de:
			continue
		vizinho.check_distancia(iteracao + 1, self)
	
	if anterior != null and anterior != chamada_de:
		anterior.check_distancia(iteracao + 1, self)
	

func auto_destruir(exceto: Sala):
	if destruindo:
		return
		
	destruindo = true
	
	for vizinho in vizinhos.values():
		if vizinho == null or vizinho == exceto:
			continue
		
		vizinho.anterior = null
		vizinho.auto_destruir(self)
	
	if anterior != null and anterior != exceto:
		anterior.auto_destruir(self)
	
	queue_free()
	
func handle_enter(body: Node3D):
	if body.is_in_group("jogador"):
		check_distancia()
		gerar_vizinhos()
