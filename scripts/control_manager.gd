extends Control

class_name ControlManager

@onready var label: Label = $Label
@onready var shelf_modal: Panel = $ShelfPanel
@onready var shelf_name: Label = $ShelfPanel/GridContainer/ShelfName
@onready var shelf_amount: Label = $ShelfPanel/GridContainer/ShelfAmount
@onready var shelf_cost: Label = $ShelfPanel/GridContainer/ShelfCost
@onready var updgrade_cost: Label = $ShelfPanel/UpgradeCost
@onready var upgrade_button: Button = $ShelfPanel/UpgradeButton

var _shelf: Shelf

func _ready():
	Events.connect("open_shelf_modal", open_modal)

func set_text(new_text):
	label.text = new_text

func _on_upgrade_button_pressed():
	_shelf.upgrade_shelf(self)

func _on_close_button_pressed():
	shelf_modal.visible = false
	_shelf = null

func open_modal(shelf: Shelf):
	shelf_modal.visible = true
	_shelf = shelf
	show_shelf_values()

func show_shelf_values():
	var item: ItemStats = _shelf.get_item_stats()
	shelf_name.text = "Plateleira " + item.item_name + " - LV: " + str(_shelf.get_level())
	shelf_amount.text = "Quantidade máxima: " + str(_shelf.get_max_amount())
	shelf_cost.text = "Valor produto: " + str(_shelf.get_item_value())
	updgrade_cost.text = "Level up: " + str(_shelf.get_upgrade_cost())
	var button_text = ""
	if _shelf.get_level() > 0:
		button_text = "Upgrade"
	else:
		button_text = "Buy"
	upgrade_button.text = button_text
