extends Node

signal repintar_ui

const CR_PALETA_COLORES = preload("res://Scripts/Resources/CR_Paleta_Colores.tres")

func set_paleta(tipo_paleta):
	CR_PALETA_COLORES.set_paleta_actiba(tipo_paleta)	
