extends Control

var playButton

# Called when the node enters the scene tree for the first time.
func _ready():
	#Se obtiene el botón
	playButton = get_node('CenterContainer/Panel/VBoxContainer/Button')
	#Se conecta con la función correspondiente en caso de ser presionado
	playButton.connect("pressed", newGame)
	get_tree().set_pause(true)

func newGame():
	#Se inicia el juego desde cero
	get_tree().set_pause(false)
	CardsManager.resetGame()
	queue_free()

func win():
	#Se establece la interfaz del popUp
	$CenterContainer/Panel/VBoxContainer/TextureRect.set_texture(load("res://assets/ui/popup_complete.png"))
	$CenterContainer/Panel/VBoxContainer/Label.text = "You found 5 pairs in " + str(CardsManager.seconds) + " seconds, and flipped " + str(CardsManager.moves) + " pairs of cards!"
