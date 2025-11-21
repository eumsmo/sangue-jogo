extends Node

var rng = RandomNumberGenerator.new()

func prob_por_pontos(distribuicao_pontos: Array[int]) -> int:
	var pontos_totais = 0
	for pontos in distribuicao_pontos:
		pontos_totais += pontos
	
	var rng_val = rng.randi_range(1, pontos_totais)
	var index_escolhido = -1
	
	for i in range(0, len(distribuicao_pontos)):
		var pontos = distribuicao_pontos[i]
		if rng_val <= pontos:
			index_escolhido = i
			break
			
		rng_val -= pontos
	
	return index_escolhido

func prob_por_pontos_dict(dict: Dictionary) -> Variant:
	var pontos: Array[int]
	var valores: Array[Variant]
	
	for valor in dict.keys():
		pontos.append(dict[valor]) 
		valores.append(valor)
	
	var index_escolhido = prob_por_pontos(pontos)
	if index_escolhido < 0 or index_escolhido >= len(pontos):
		return null
	
	return valores[index_escolhido]
