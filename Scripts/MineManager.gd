extends GridContainer

var buttons: Array[Button]
var watching = []
var mineNum = 0
var mineplaces = []
var places = []
var matches = 0
var gameover = false
var bonustime = false
var anim
var bgm

func _ready():
	anim = get_parent().get_parent().get_node("AnimationPlayer")
	bgm =  get_parent().get_parent().get_node("bgm")
	Globals.score = 0
	Globals.timeleft = 30
	for i in range(64):
		buttons.append(get_node("Button" + str(i)))
	reset()
	await get_tree().create_timer(1).timeout
	Globals.timeflow = true
	anim.play("startgame")
	bgm.play()

func reset():
	watching.clear()
	matches = 0
	mineNum = 0
	places.clear()
	mineplaces.clear()
	for i in buttons:
		i.reset()
	
	#classic_place()
	random_place()
	
func classic_place():
	var placingN = randi() % 15 + 10
	var p = RandomNumberGenerator.new().randf_range(0,1)
			
	for i in range(placingN):
		p = randi() % 64
		if p not in mineplaces:
			mineplaces.append(p)
			
	for pos in range(64):
		if pos in mineplaces:
			continue
		var mines = 0
		var x = pos % 8
		for i in [pos+1, pos-1, pos+8, pos-8, pos-9, pos-7, pos+7, pos+9]:
			if 0 > i or i > 63 or (x == 0 and i%8 == 7) or (x==7 and i%8==0):
				pass
			elif i in mineplaces:
				mines += 1
		if mines > 0 and (randi() % 4 == 0):
			buttons[pos].place_number(mines)
			watching.append(pos)
	
		
func random_place():
	var probP = [0.02,0.06,0.15,0.3,0.5,0.7,0.85,0.94,0.98,1.01]
	var placingN = 0
	var p = RandomNumberGenerator.new().randf_range(0,1)
	for j in range(10):
		if p < probP[j]:
			placingN = j+6
			break
	
	for i in range(placingN):
		p = randi() % 64
		for reroll in range(3):
			if p % 8 == 0 or p / 8 == 0 or p / 8 == 7 or p % 8 == 7:
				p = randi() % 64
			else:
				break
		if p not in places:
			places.append(p)
			
	var prob = [0.25,0.5,0.7,0.86,0.94,0.98,0.995,1.01]
	
	for i in places:
		watching.append(i)
		p = RandomNumberGenerator.new().randf_range(0,1)
		var rng = 0
		for j in range(8):
			if p < prob[j]:
				rng = j
				break
				
		buttons[i].place_number(rng + 1)
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and gameover == false:
		var allmatch = true
		for i in watching:
			if buttons[i].satisfied == true:
				matches += 1
			else:
				allmatch = false
				
		var timemod = 0.25 - Globals.score * 0.00015
		if timemod < 0.1:
			timemod = 0.1
		var adding = timemod * matches ** 2
		if adding > 10:
			adding = 5 + adding * 0.5
		Globals.timeleft += adding
		Globals.score += matches
		if adding > 0:
			if adding < 10:
				$reward.volume_db = -20 + adding * 2
				$reward.pitch_scale = 0.8 + adding * 0.04
			else:
				$reward.volume_db = 0
				$reward.pitch_scale = 1.2
				
			$reward.play()
			anim.play("gotreward")
		
		if Globals.timeleft > 30 and bonustime == false:
			Globals.timeleft = 30
			
		if allmatch == true:
			Globals.timeleft += int(matches * 1.2)
			Globals.score += matches * 3
			anim.play("allclear")
		
		if Globals.timeleft > 30:
			bonustime = true
		if Globals.timeleft > 40:
			Globals.timeleft = 40
		$reroll.play()
		reset()
		
	if Globals.timeleft < 30:
		bonustime = false
		
