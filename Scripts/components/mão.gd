extends SlotContainer

var rodadaCartas : Array 

func inserirCartas(_rodada_cartas: Array[int]):
	rodadaCartas = _rodada_cartas
	var i = 0
	#print(rodadaCartas.size())
	for card in rodadaCartas:
		slots[i].criar_carta(card)
		i+=1
		
