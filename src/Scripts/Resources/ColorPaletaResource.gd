extends Resource

class_name paleta_colores

#var morado: Color = Color("#9F2241")
#var oro: Color = Color("#B3B05D")
#var azul_claro: Color = Color("#3D7CC9")
#var azul_oscuro: Color = Color("#1C355E")
#var gris: Color = Color("#4F4F4F")

@export var paleta_activa: E_PALETA = E_PALETA.PALETA_1
@export var paleta_1: Array[Color]
@export var paleta_2: Array[Color]

enum E_PALETA {
	PALETA_1,
	PALETA_2
}

func set_paleta_actiba(tipo_paleta: E_PALETA):
	paleta_activa = tipo_paleta

func get_paleta_activa():
	match paleta_activa:
		E_PALETA.PALETA_1:
			return paleta_1
		E_PALETA.PALETA_2:
			return paleta_2

func get_color_texture(index: int):
	var current_paleta = get_paleta_activa()
	return current_paleta[index]


func set_color_at_pos(index,color):
	var current_paleta = get_paleta_activa()
	current_paleta[index] = color
