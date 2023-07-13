extends TextureButton

class_name Card

#Se definen las variables necesarias
var suit
var value
var face
var back

# Called when the node enters the scene tree for the first time.
func _ready():
	#Se establecen los valores de tamaños de las cartas
	set_h_size_flags(SIZE_EXPAND_FILL)
	set_v_size_flags(SIZE_EXPAND_FILL)
	set_ignore_texture_size(true)
	set_stretch_mode(TextureButton.STRETCH_KEEP_ASPECT_CENTERED)

func _init(s, v):
	#Se establecen los valores de la carta, y se cargan la imagenes
	suit = s
	value = v
	face = load("res://assets/cards/card-" + str(suit) + "-" + str(value) + ".png")
	back  = CardsManager.cardBack
	set_texture_normal(back)

func _pressed():
	#Se llama a la función correspondiente en caso de presionar sobre una carta
	CardsManager.chooseCard(self)

func flip():
	#Se cambia la imagen cargada en la carta a la correspondiente al girarla
	if get_texture_normal() == back:
		Signals.emit_signal("flipcard")
		set_texture_normal(face)
	else:
		Signals.emit_signal("flipcard")
		set_texture_normal(back)
