extends Node

#Se definen las variables necesarias
@onready var Game = get_node('/root/Game/') 
var deck = Array()
var cardBack = preload("res://assets/cards/cardBack_blue2.png")
var card1
var card2

var matchTimer = Timer.new()
var flipTimer = Timer.new()
var secondsTimer = Timer.new()

var score = 0
var seconds = 0
var moves = 0
var scoreLabel
var timerLabel
var movesLabel
var resetButton
var goal = 5 

@onready var popUp = preload("res://scenes/PopUp.tscn")

#Se establecen todos los valores iniciales del juego
func _ready():
	#Se rellena la baraja
	fillDeck()
	#Se barajan las cartas
	dealDeck()
	#Se inician los temporizadores
	setUpTimers()
	#Se inicia la barra de estado
	setUpHUD()
	#Se instancia el pop up inicial y lo añadimos a la escena principal
	var splash = popUp.instantiate()
	Game.add_child(splash)

func setUpTimers():
	#Se conectan y se inicializan los temporizadores. Se añaden a la escena principal
	flipTimer.connect("timeout", turnOverCards)
	flipTimer.set_one_shot(true)
	add_child(flipTimer)
	matchTimer.connect("timeout", matchCardsAndScore)
	matchTimer.set_one_shot(true)
	add_child(matchTimer)
	secondsTimer.connect("timeout", countSeconds)
	add_child(secondsTimer)
	secondsTimer.start()

func countSeconds():
	#Se añade un segundo
	seconds += 1
	timerLabel.text = str(seconds)

#Se reinicia el juego
func resetGame():
	#Se liberan los recursos de la ya existente baraja
	for c in range (deck.size()):
		deck[c].queue_free()
	deck.clear()
	#Se establecen todos los valores de la barra de estado a 0
	score = 0 
	seconds = 0 
	moves = 0
	#Se reinician los temporizadores
	setUpTimers()
	#Se reinicia la barra de estado
	setUpHUD()
	#Se rellena la baraja
	fillDeck()
	#Se barajan las cartas
	dealDeck()

#Se establecen los valores de la barra de estado
func setUpHUD():
	scoreLabel = Game.get_node('HUD/Panel/Sections/SectionScore/Score')
	timerLabel = Game.get_node('HUD/Panel/Sections/SectionTimer/Seconds')
	movesLabel = Game.get_node('HUD/Panel/Sections/SectionMoves/Moves')
	scoreLabel.text = str(score)
	timerLabel.text = str(seconds)
	movesLabel.text = str(moves)
	#Obtenemos el botón de reset
	resetButton = Game.get_node('HUD/Panel/Sections/SectionButtons/ButtonReset')
	#Se conecta con la función correspondiente si es pulsado
	resetButton.connect("pressed", resetGame)

func fillDeck():
	#s = primer valor de la carta (1: las graficas, 2: las funciones)
	var s = 1 
	#v = segundo valor (las diferentes graficas/funciones que hay)
	var v = 1
	while s < 3:
		v = 1
		while v < 6:
			#Se van añadiendo todas las cartas
			deck.append(Card.new(s, v))
			v += 1
		s += 1

func dealDeck():
	#Se barajan las cartas
	deck.shuffle()
	var c = 0
	while c < deck.size():
		if Game != null:
			#Se añaden a la pantalla de juego
			var grid_node = Game.get_node_or_null('grid')
			if grid_node:
				grid_node.add_child(deck[c])
			c += 1

func chooseCard(c):
	#Se elige la primera carta y se gira
	if card1 == null:
		card1 = c
		card1.flip()
		card1.set_disabled(true)
	#Se elige la segunda carta y se gira
	elif card2 == null:
		card2 = c
		card2.flip()
		card2.set_disabled(true)
		#Se añade un movimiento
		moves += 1
		movesLabel.text = str(moves)
		#Se comprueban si ambas cartas son pareja
		checkCards()

func checkCards():
	#Se comprueba si las cartas son pareja y se establecen los temporizadores corespondientes para girarlas de nuevo o inhabilitarlas
	if card1.value == card2.value:
		matchTimer.start(0.6)
	else:
		flipTimer.start(1.2)

func turnOverCards():
	#Gira ambas cartas
	card1.flip()
	card2.flip()
	#Se establecen a null los valores de las variables auxiliares
	card1.set_disabled(false)
	card2.set_disabled(false)
	card1 = null
	card2 = null

func matchCardsAndScore():
	Signals.emit_signal("pairfound")
	#Se aumenta en 1 el valor de la puntuación
	score += 1
	scoreLabel.text = str(score)
	#Se cambia el color de las cartas para "inhabilitarlas"
	card1.set_modulate(Color(0.6, 0.6, 0.6, 0.5))
	card2.set_modulate(Color(0.6, 0.6, 0.6, 0.5))
	#Se establecen a null los valores de las variables auxiliares
	card1 = null
	card2 = null
	#Si se alcanza el objetivo, se instancia el pop up final y se gana el juego
	if score == goal:
		var winScreen = popUp.instantiate()
		Game.add_child(winScreen)
		winScreen.win()
