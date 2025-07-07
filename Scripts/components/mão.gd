extends SlotContainer

var rodadaCartas : Array 

func inserirCartas():
	var i = 0
	#print(rodadaCartas.size())
	for card in rodadaCartas:
		slots[i].cardId = card
		slots[i].atualizar()
		i+=1
		
