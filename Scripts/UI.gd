extends Control

signal over

func _process(delta):
	if Globals.timeflow == true:
		Globals.timeleft -= delta
	$Time.text = str(snapped(Globals.timeleft, 0.1))
	$Score.text = str(Globals.score)
	$ProgressBar.value = Globals.timeleft
	$ProgressBar2.value = Globals.timeleft
	
	if Globals.timeleft < 0:
		Globals.timeleft = 0
		Globals.timeflow = false
		$GridContainer.gameover = true
		over.emit()
