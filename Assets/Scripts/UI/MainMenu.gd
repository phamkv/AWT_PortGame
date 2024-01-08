extends Control

func _ready():
	get_node("PlayButton").pressed.connect(func(): SceneManager.LoadScene("GameScene"))
	get_node("OptionsButton").pressed.connect(func(): SceneManager.LoadScene("OptionsScene"))
	get_node("QuitButton").pressed.connect(func(): get_tree().quit())
