extends TextureButton

@onready var tutos = []
@export var how2play = Control
var page = 0

func _ready():
	for i in range(1,6):
		tutos.append(get_parent().get_node(str(i)))

func _on_pressed():
	page = (page+1) % 5
	if page == 0:
		how2play.visible = false
	for i in range(5):
		tutos[i].visible = false
	tutos[page].visible = true
