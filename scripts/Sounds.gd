extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	#Se conecta con las señales indicadas
	Signals.connect("flipcard", flipCard)
	Signals.connect("pairfound", pairFound)

func flipCard():
	#Se emite el sonido correspondiente
	$FlipCard.play()

func pairFound():
	#Se emite el sonido correspondiente
	$PairFound.play()
