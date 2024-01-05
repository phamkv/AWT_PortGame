extends Control

func _ready():
	get_node("ResumeButton").pressed.connect(func(): return)
	get_node("OptionsButton").pressed.connect(func(): AudioAndOptionsManager.LoadScene("OptionsScene"))
	get_node("MainMenuButton").pressed.connect(func(): AudioAndOptionsManager.LoadScene("MainMenuScene"))
	#connect to MainGameManager PauseEvent
	self.hide()
