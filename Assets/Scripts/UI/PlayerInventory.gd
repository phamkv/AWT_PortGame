extends Control

class_name PlayerInventory

var GameManager: Node

enum SlotType {
	Storage,
	Mainhand,
	Crafting,
	CraftingResult
}

var storageSlots: Array[Node]
var mainHandSlot: Node
var craftingSlots: Array[Node]
var craftingResultSlot: Node

var selectedInventorySlot: Node = null

func _ready():
	self.hide()
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
			#Add: Drop Items
			mainHandSlot.ClearSlot()
			#Add: Update MainHand
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

func SelectSlot(inventorySlot: Node):
	if (selectedInventorySlot != null):
		if (inventorySlot == selectedInventorySlot):
			inventorySlot.Deselect()
			selectedInventorySlot = null
			return
		if (inventorySlot.IsSlotEmpty() and selectedInventorySlot.IsSlotEmpty()):
			return
		
		#Add: Crafting and SlotSwapping
	else:
		inventorySlot.Select()
		selectedInventorySlot = inventorySlot
