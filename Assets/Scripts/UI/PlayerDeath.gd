extends Control

func _ready():
	var GameManager = get_node("%GameManager")
	get_node("RestartButton").pressed.connect(func(): SceneManager.LoadScene("GameScene"))
	get_node("MainMenuButton").pressed.connect(func(): SceneManager.LoadScene("MainMenuScene"))
	GameManager.playerDeath.connect(func():
		if (GameManager.isPlayerDead):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			self.show()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			self.hide()	 
	)
	self.hide()
