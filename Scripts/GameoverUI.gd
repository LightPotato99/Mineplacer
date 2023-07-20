extends Control

func _on_control_over():
	if Globals.highscore < Globals.score:
		Globals.highscore = Globals.score
	
	$TextureRect/Score.text = "Score: " + str(Globals.score)
	$TextureRect/Highscore.text = "Highscore: " + str(Globals.highscore)
