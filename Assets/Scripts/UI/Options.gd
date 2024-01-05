extends Control

var masterVolume: float

func _ready():
	masterVolume = AudioAndOptionsManager.masterVolume
	get_node("QuitButton").pressed.connect(
		func(): 
			AudioAndOptionsManager.masterVolume = masterVolume
			AudioAndOptionsManager.LoadScene(AudioAndOptionsManager.previousScene)
			)
	get_node("SoundSetting/VolumeSlider").value_changed.connect(
		func(value: float): 
			masterVolume = value/100
			get_node("SoundSetting/VolumeNumber").text = str(int(masterVolume * 100))
			)	
	get_node("SoundSetting/VolumeSlider").value = masterVolume*100
