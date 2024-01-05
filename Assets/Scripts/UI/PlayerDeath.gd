extends Control

func _ready():
	get_node("RestartButton").pressed.connect(func(): AudioAndOptionsManager.LoadScene("GameScene"))
	get_node("MainMenuButton").pressed.connect(func(): AudioAndOptionsManager.LoadScene("MainMenuScene"))
	#connect to MainGameManager DeathEvent
	self.hide()
