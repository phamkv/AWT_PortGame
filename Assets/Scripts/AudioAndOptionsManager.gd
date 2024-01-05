extends Node

var masterVolume: float = 0.5
var currentScene: String = ""
var previousScene: String = ""

func _ready():
	currentScene = get_tree().current_scene.get_name()

func LoadScene(sceneName: String):
	previousScene = currentScene
	currentScene = sceneName
	get_tree().change_scene_to_file("res://Assets/Scenes/" + sceneName + ".tscn")
