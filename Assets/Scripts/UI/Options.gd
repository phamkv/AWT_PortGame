extends Control

var busIndex: int
var masterVolume: float

func _ready():
	busIndex = AudioServer.get_bus_index("Master")
	get_node("QuitButton").pressed.connect(
		func(): 
			AudioServer.set_bus_volume_db(busIndex, linear_to_db(masterVolume))
			SceneManager.LoadScene(SceneManager.previousScene)
			)
	get_node("SoundSetting/VolumeSlider").value_changed.connect(
		func(value: float):
			masterVolume = value/100
			get_node("SoundSetting/VolumeNumber").text = str(value)
			)
	var soundValue = db_to_linear(AudioServer.get_bus_volume_db(busIndex))
	masterVolume = soundValue
	get_node("SoundSetting/VolumeSlider").value = int(soundValue*100)
	get_node("SoundSetting/VolumeNumber").text = str(int(soundValue*100))
