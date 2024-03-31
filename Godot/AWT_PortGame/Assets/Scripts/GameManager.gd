## The main controller
## Handles events like the players health, the players death, and input events

extends Node

signal playerDeath
signal inventoryToggle
signal itemDropped
signal gamePaused

var isInventoryOpen: bool = false
var isGamePaused: bool = false
var isPlayerDead: bool = false

var playerHealth: int = 100
var playerMaxHealth: int = 100
	
func TogglePause():
	if (isPlayerDead):
		return
	if (isInventoryOpen):
		isInventoryOpen = false
		inventoryToggle.emit()
	isGamePaused = !isGamePaused
	gamePaused.emit()

func _input(event):
	if event.is_action_pressed("pause"):
		TogglePause()
	if event.is_action_pressed("dropItem"):
		itemDropped.emit()
	if event.is_action_pressed("toggleInventory"):
		if (isGamePaused || isPlayerDead):
			return
		isInventoryOpen = !isInventoryOpen
		inventoryToggle.emit()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and playerHealth < playerMaxHealth and get_node("/root/GameScene/UI/Player/Inventory").mainHandSlot.itemName == "Mushroom":
			HealPlayer(10)
			get_node("/root/GameScene/UI/Player/Inventory").mainHandSlot.ModifyItemCount(-1)
			if (get_node("/root/GameScene/UI/Player/Inventory").mainHandSlot.IsSlotEmpty()):
				get_node("/root/GameScene/Player").UpdateMainHand("")
			
func PlayerDeath():
	if (isInventoryOpen):
		isInventoryOpen = !isInventoryOpen
		inventoryToggle.emit()
	if (isGamePaused):
		isGamePaused = !isGamePaused
		gamePaused.emit()
	get_node("%HealthBar").hide()
	get_node("%HealthBarBackground").hide()
	isPlayerDead = true
	playerDeath.emit()

func DamagePlayer(amount: int):
	if (amount < 0):
		return
	playerHealth -= amount
	if (playerHealth <= 0):
		playerHealth = 0
		PlayerDeath()
	UpdateHealthBar()
		
		
func HealPlayer(amount: int):
	if (amount < 0 || playerHealth > playerMaxHealth):
		return
	playerHealth += amount
	if (playerHealth > playerMaxHealth):
		playerHealth = playerMaxHealth
	UpdateHealthBar()
	
func UpdateHealthBar():
	get_node("%HealthBar").set_scale(Vector2(float(playerHealth)/float(playerMaxHealth),1))
