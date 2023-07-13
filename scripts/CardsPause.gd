extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func _pressed():
	#Si la escena no esta pausada, se pausa y se cambia la imagen del botón
	if !get_tree().is_paused():
		get_tree().set_pause(true)
		set_texture_normal(load("res://assets/ui/play.png"))
	#Si la escena esta pausada, se reanuda y se cambia la imagen del botón
	elif get_tree().is_paused():
		get_tree().set_pause(false)
		set_texture_normal(load("res://assets/ui/pause.png"))
