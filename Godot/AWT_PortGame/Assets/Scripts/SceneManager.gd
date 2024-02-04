extends Node

var currentScene: String = ""
var previousScene: String = ""

func _ready():
	currentScene = get_tree().current_scene.get_name()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(0.5))	

func LoadScene(sceneName: String):
	previousScene = currentScene
	currentScene = sceneName
	get_tree().change_scene_to_file("res://Assets/Scenes/" + sceneName + ".tscn")
