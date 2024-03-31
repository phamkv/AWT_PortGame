## Manages the pause menu

extends Control

func _ready():
	var GameManager = get_node("%GameManager")
	get_node("ResumeButton").pressed.connect(func(): GameManager.TogglePause())
	get_node("OptionsButton").pressed.connect(func(): SceneManager.LoadScene("OptionsScene"))
	get_node("MainMenuButton").pressed.connect(func(): SceneManager.LoadScene("MainMenuScene"))
	GameManager.gamePaused.connect(func():
		if (GameManager.isGamePaused):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			self.show()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			self.hide()	 
	)
	self.hide()
