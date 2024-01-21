extends Control

class_name PlayerInventory

var GameManager: Node
var Player: Node

enum SlotType {
	Storage,
	Mainhand,
	Crafting,
	CraftingResult
}

enum Recipes {
	sword,
	pickaxe,
	none
}

var storageSlots: Array[Node]
var mainHandSlot: Node
var craftingSlots: Array[Node]
var craftingResultSlot: Node

var selectedInventorySlot: Node = null
var currentRecipe: Recipes = Recipes.none

var swordRecipe: Array[String] = ["Stone", "", "Wood", ""]
var pickaxeRecipe: Array[String] = ["Stone", "Stone", "Wood", ""]

func _ready():
	self.hide()
	Player = get_node("/root/GameScene/Player")
	GameManager = get_node("%GameManager")
	GameManager.inventoryToggle.connect(func():
		if (GameManager.isInventoryOpen):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			self.show()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			self.hide()	 
	)
	GameManager.itemDropped.connect(func():
		if (!mainHandSlot.IsSlotEmpty()):
			for i in mainHandSlot.GetItemCount():
				#Add: spawn Items
				pass
			mainHandSlot.ClearSlot()
			Player.UpdateMainHand("")
	)
	
	storageSlots = $Storage.get_children()
	mainHandSlot = $MainHand.get_node("InventorySlot")
	craftingSlots = $Crafting.get_children()
	craftingResultSlot = craftingSlots.pop_back()
	
	var count: int = 0
	for storageSlot: Node in storageSlots:
		storageSlot.slotIndex = count
		storageSlot.slotType = SlotType.Storage
		count += 1
	count = 0
	for craftingSlot: Node in craftingSlots:
		craftingSlot.slotIndex = count
		craftingSlot.slotType = SlotType.Crafting
		count += 1
	mainHandSlot.slotType = SlotType.Mainhand
	craftingResultSlot.slotType = SlotType.CraftingResult
	
func AddItemToInventory(itemName: String, texture: Texture2D, itemCount: int):
	if (itemName == null || itemName == "" || texture == null || itemCount == 0):
		return
	for inventorySlot in storageSlots:
		if (inventorySlot.itemName == itemName):
			inventorySlot.ModifyItemCount(itemCount)
			return
	for inventorySlot in storageSlots:
		if (inventorySlot.IsSlotEmpty()):
			inventorySlot.UpdateSlot(texture, str(itemCount), itemName)
			return

func SelectSlot(inventorySlot: Node):
	checkForValidRecipe()
	if (selectedInventorySlot != null):
		if (inventorySlot == selectedInventorySlot):
			inventorySlot.Deselect()
			selectedInventorySlot = null
			return
		if (inventorySlot.IsSlotEmpty() and selectedInventorySlot.IsSlotEmpty()):
			return
		if (inventorySlot.slotType == SlotType.CraftingResult || selectedInventorySlot.slotType == SlotType.CraftingResult):
			if ((inventorySlot.slotType == SlotType.CraftingResult && selectedInventorySlot.IsSlotEmpty) || (selectedInventorySlot.slotType == SlotType.CraftingResult && inventorySlot.IsSlotEmpty())):
				match currentRecipe:
					Recipes.sword:
						for i in swordRecipe.size():
							if (swordRecipe[i] != ""):
								craftingSlots[i].ModifyItemCount(-1)
						swapInventorySlotContent(selectedInventorySlot, inventorySlot)
					Recipes.pickaxe:
						for i in pickaxeRecipe.size():
							if (pickaxeRecipe[i] != ""):
								craftingSlots[i].ModifyItemCount(-1)
						swapInventorySlotContent(selectedInventorySlot, inventorySlot)
					Recipes.none:
						pass
				currentRecipe = Recipes.none
		elif (inventorySlot.slotType == SlotType.Crafting && (inventorySlot.itemName == selectedInventorySlot.itemName || inventorySlot.IsSlotEmpty()) && !selectedInventorySlot.IsSlotEmpty() && selectedInventorySlot.GetItemCount() > 1):
			if (inventorySlot.IsSlotEmpty()):
				inventorySlot.UpdateSlot(selectedInventorySlot.SlotImage.get_texture(),"0",selectedInventorySlot.itemName)
			inventorySlot.ModifyItemCount(1)
			selectedInventorySlot.ModifyItemCount(-1)
		elif (selectedInventorySlot.slotType == SlotType.Crafting && (inventorySlot.itemName == selectedInventorySlot.itemName || selectedInventorySlot.IsSlotEmpty()) && !inventorySlot.IsSlotEmpty() && inventorySlot.GetItemCount() > 1):
			if (selectedInventorySlot.IsSlotEmpty()):
				selectedInventorySlot.UpdateSlot(inventorySlot.SlotImage.get_texture(),"0",inventorySlot.itemName)
			inventorySlot.ModifyItemCount(-1)
			selectedInventorySlot.ModifyItemCount(1)
		elif (selectedInventorySlot.itemName == inventorySlot.itemName && !selectedInventorySlot.IsSlotEmpty()):
			inventorySlot.UpdateSlot(selectedInventorySlot.SlotImage.get_texture(),inventorySlot.ItemCount.get_text(),selectedInventorySlot.itemName)
			inventorySlot.ModifyItemCount(selectedInventorySlot.GetItemCount())
			selectedInventorySlot.ClearSlot()
		else:
			swapInventorySlotContent(selectedInventorySlot, inventorySlot)
		
		if (inventorySlot.slotType == SlotType.Mainhand || selectedInventorySlot.slotType == SlotType.Mainhand):
			Player.UpdateMainHand(mainHandSlot.itemName)
			pass
		
		selectedInventorySlot.Deselect()
		selectedInventorySlot = null
	else:
		inventorySlot.Select()
		selectedInventorySlot = inventorySlot
	checkForValidRecipe()
		
func swapInventorySlotContent(inventorySlot1: Node, inventorySlot2: Node):
	var slotImage: Texture2D = inventorySlot2.SlotImage.get_texture()
	var itemCount: String = inventorySlot2.ItemCount.get_text()
	var itemName: String = inventorySlot2.itemName
	inventorySlot2.UpdateSlot(inventorySlot1.SlotImage.get_texture(), inventorySlot1.ItemCount.get_text(), inventorySlot1.itemName)
	inventorySlot1.UpdateSlot(slotImage, itemCount, itemName)

func checkForValidRecipe():
	craftingResultSlot.ClearSlot()
	var slotContent: Array[String] = ["","","",""]
	var count: int = 0
	for itemSlot in craftingSlots:
		slotContent[count] = itemSlot.itemName
		count +=1
	if (slotContent[0] == pickaxeRecipe[0] && slotContent[1] == pickaxeRecipe[1] && slotContent[2] == pickaxeRecipe[2] && slotContent[3] == pickaxeRecipe[3]):
		craftingResultSlot.UpdateSlot(load("res://Assets/_Assets/Items/Axe.png"),1,"Axe")
		currentRecipe = Recipes.pickaxe
	elif (slotContent[0] == swordRecipe[0] && slotContent[1] == swordRecipe[1] && slotContent[2] == swordRecipe[2] && slotContent[3] == swordRecipe[3]):
		craftingResultSlot.UpdateSlot(load("res://Assets/_Assets/Items/Sword.png"),str(1),"Sword")
		currentRecipe = Recipes.sword
	else:
		currentRecipe = Recipes.none
