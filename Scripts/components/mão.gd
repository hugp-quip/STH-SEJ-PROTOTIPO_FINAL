extends SlotContainer

var cardsHand : Array 

func inserirCartas():
	var i = 0
	#print(cardsHand.size())
	for card in cardsHand:
		slots[i].cardId = card
		slots[i].atualizar()
		i+=1
		
