extends Button

var x = 0
var y = 0
var near = []
var has_mine = false
var nearby_mines = 0
var required = -1
var satisfied = false

var buttonDefault = preload("res://Images/MineGrid.png")
var buttonMine = preload("res://Images/MineGrid_mine.png")
var buttonHover = preload("res://Images/MineGrid_hover.png")
var buttonMineHover = preload("res://Images/MineGrid_minehover.png")
var numberGrid = preload("res://Images/MineGrid_number.png")
var numberOk = preload("res://Images/MineGrid_ok.png")
var numberSpr = [preload("res://Images/Numbers/One.png"),
				preload("res://Images/Numbers/Two.png"),
				preload("res://Images/Numbers/Three.png"),
				preload("res://Images/Numbers/Four.png"),
				preload("res://Images/Numbers/Five.png"),
				preload("res://Images/Numbers/Six.png"),
				preload("res://Images/Numbers/Seven.png"),
				preload("res://Images/Numbers/Eight.png")]

func _ready():
	var p = int(self.name.replace("Button",""))
	x = p % 8
	y = int(p / 8)
	for i in [p+1, p-1, p+8, p-8, p-9, p-7, p+7, p+9]:
		if 0 > i or i > 63 or (x == 0 and i%8 == 7) or (x==7 and i%8==0):
			pass
		else:
			near.append(get_parent().get_node("Button" + str(i)))
			
func update():
	var t = 0
	for i in near:
		if i.has_mine == true:
			t += 1
	nearby_mines = t
	
	satisfied = nearby_mines == required
	if satisfied: 
		$ButtonSprite.texture = numberOk
	elif required != -1:
		$ButtonSprite.texture = numberGrid
		
func reset():
	required = -1
	$Number.visible = false
	$ButtonSprite.texture = buttonDefault
	has_mine = false
	satisfied = false

func place_number(n):
	disabled = true
	required = n
	$Number.visible = true
	$Number.texture = numberSpr[n-1]
	$ButtonSprite.texture = numberGrid

func _on_gui_input(event):
	if event is InputEventMouseButton and required == -1:
		if event.pressed:
			has_mine = not has_mine
			if has_mine:
				$ButtonSprite.texture = buttonMine
				get_parent().mineNum += 1
			else:
				$ButtonSprite.texture = buttonDefault
				get_parent().mineNum -= 1
			for i in near:
				i.update()

func _on_pressed():
	$click.play()

func _on_mouse_entered():
	if required == -1:
		if has_mine:
			$ButtonSprite.texture = buttonMineHover
		else:
			$ButtonSprite.texture = buttonHover

func _on_mouse_exited():
	if required == -1:
		if has_mine:
			$ButtonSprite.texture = buttonMine
		else:
			$ButtonSprite.texture = buttonDefault
