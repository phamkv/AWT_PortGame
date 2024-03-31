## Manages a single inventory slot
## This includes updating and clearing the slot

extends Button

var Inventory: Node

var SlotImage: TextureRect
var ItemCount: Label

var slotIndex: int = 0
var itemName = ""
var slotType: PlayerInventory.SlotType

func _ready():
	Inventory = get_node("%Inventory")
	SlotImage = $Image
	ItemCount = $ItemCount
	pressed.connect(func():
		Inventory.SelectSlot(self)
	)
	
func Select():
	SlotImage.modulate = Color.WHITE.lerp(Color.GRAY,0.3)
func Deselect():
	SlotImage.modulate = Color.WHITE
	
func GetItemCount():
	return int(ItemCount.get_text())
	
func GetItemName():
	return itemName
	
func IsSlotEmpty():
	return itemName == ""

func ClearSlot():
	SlotImage.set_texture(load("res://Assets/_Assets/Items/empty_slot.png"))
	ItemCount.set_text("")
	itemName = ""
	pass
	
func UpdateSlot(texture: Texture2D, itemCount: String, newItemName: String):
	if (texture != null):
		SlotImage.set_texture(texture)
	itemName = newItemName
	ItemCount.set_text(itemCount)

func ModifyItemCount(value: int):
	if (int(ItemCount.get_text())+value <= 0):
		ClearSlot()
		return
	ItemCount.set_text(str(GetItemCount()+value))
