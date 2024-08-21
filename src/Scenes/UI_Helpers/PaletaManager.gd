extends Control

@onready var window: Window = $Window
@onready var option_button: OptionButton = $Window/OptionButton
@onready var v_box_container: VBoxContainer = $Window/VBoxContainer

func set_paleta():	
	GlobalPaletaColores.set_paleta(option_button.get_selected_id())
	print_pallete()
	
func _ready() -> void:
	print_pallete()
		

func _on_button_pressed() -> void:	
	change_colors()	
	GlobalPaletaColores.emit_signal("repintar_ui")

func change_visibility(visible):
	window.visible =visible
	
func print_pallete():	
	var current = GlobalPaletaColores.CR_PALETA_COLORES.get_paleta_activa()
	for index in range(5):
		var c_picker : ColorPickerButton = v_box_container.get_child(index).get_child(1)		
		c_picker.color = current[index]

func change_colors():
	var current = GlobalPaletaColores.CR_PALETA_COLORES.get_paleta_activa()
	for index in range(5):
		var c_picker : ColorPickerButton = v_box_container.get_child(index).get_child(1)
		GlobalPaletaColores.CR_PALETA_COLORES.set_color_at_pos(index,c_picker.color)


func _on_option_button_item_selected(index: int) -> void:
	set_paleta()
	GlobalPaletaColores.emit_signal("repintar_ui")
