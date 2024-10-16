extends Control

@onready var chart: Chart = $VBoxContainer/Chart

# This Chart will plot 3 different functions
var f1: Function
var f2: Function
var f3: Function

func _ready():
	SceneManager.add_scene(SceneManager.idSceneGraficador,self)	
	GlobalUtils.ChartControl = self.get_parent()
	var id_signals: Array[int] = [116, 117, 134]
	
	var datos_reportes_n = FileAccess.open("res://Scenes/Plotter/reportes_data_n.json", FileAccess.READ)
	var datos_reportes_p = FileAccess.open("res://Scenes/Plotter/reportes_data_p.json", FileAccess.READ)
	var datos_reportes_g = FileAccess.open("res://Scenes/Plotter/reportes_data_g.json", FileAccess.READ)
	
	var content_n = datos_reportes_n.get_as_text()
	var content_p = datos_reportes_p.get_as_text()
	var content_g = datos_reportes_g.get_as_text()

	var json_data_n = JSON.parse_string(content_n)
	var json_data_p = JSON.parse_string(content_p)
	var json_data_g = JSON.parse_string(content_g)
	
	var dic_reportes: Dictionary = {}
	
	set_data(dic_reportes, json_data_n)
	set_data(dic_reportes, json_data_p)
	set_data(dic_reportes, json_data_g)
		
	# Let's create our @x values
	var x: Array = dic_reportes.get(id_signals[0]).map(func(l: Reportes): return l.tiempo).map(get_minutes_from_date_string)
	
	# And our y values. It can be an n-size array of arrays.
	# NOTE: `x.size() == y.size()` or `x.size() == y[n].size()`
	var y: Array = dic_reportes.get(id_signals[0]).map(func(l: Reportes): return l.valor)
	var y2: Array = dic_reportes.get(id_signals[1]).map(func(l: Reportes): return l.valor)
	var y3: Array = dic_reportes.get(id_signals[2]).map(func(l: Reportes): return l.valor)
	
	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	var cp: ChartProperties = ChartProperties.new()
	cp.colors.frame = Color("#161a1d")
	cp.colors.background = Color.TRANSPARENT
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color.WHITE_SMOKE
	cp.draw_bounding_box = false
	cp.show_legend = true
	cp.title = "VWC Monitoreo del nivel"
	cp.x_label = "Tiempo"
	cp.y_label = "Variables"
	cp.x_scale = 4
	cp.y_scale = 10
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot
	
	# Let's add values to our functions
	f1 = Function.new(
		x, y, "Nivel", # This will create a function with x and y values taken by the Arrays 
						# we have created previously. This function will also be named "Pressure"
						# as it contains 'pressure' values.
						# If set, the name of a function will be used both in the Legend
						# (if enabled thourgh ChartProperties) and on the Tooltip (if enabled).
		# Let's also provide a dictionary of configuration parameters for this specific function.
		{ 
			color = Color("#36a2eb"), 		# The color associated to this function
			marker = Function.Marker.CIRCLE, 	# The marker that will be displayed for each drawn point (x,y)
											# since it is `NONE`, no marker will be shown.
			type = Function.Type.AREA, 		# This defines what kind of plotting will be used, 
											# in this case it will be an Area Chart.
			interpolation = Function.Interpolation.LINEAR	# Interpolation mode, only used for 
															# Line Charts and Area Charts.
		}
	)
	f2 = Function.new(x, y2, "Presion", { color = Color("#ff6384"), type = Function.Type.LINE, marker = Function.Marker.CIRCLE })
	f3 = Function.new(x, y3, "Enlace", { color = Color.GREEN, type = Function.Type.LINE, marker = Function.Marker.CIRCLE })
	
	# Now let's plot our data
	chart.plot([f1, f2, f3], cp)
	
	# Uncommenting this line will show how real time data plotting works
	set_process(false)


var new_val: float = 4.5

func _process(_delta: float):
	# This function updates the values of a function and then updates the plot
	new_val += 5
	
	# we can use the `Function.add_point(x, y)` method to update a function
	f1.add_point(new_val, cos(new_val) * 20)
	f2.add_point(new_val, (sin(new_val) * 20) + 20)
	f3.add_point(new_val, (cos(new_val) * -5) - 3)
	chart.queue_redraw() # This will force the Chart to be updated


func _on_CheckButton_pressed():
	set_process(not is_processing())

func get_minutes_from_date_string(date_time: String):
	
	#"2024-07-18T06:07:00"
	#var time:String = date_time.split("T")[1]
	#var time_splitted = time.split(":")
	#var hours: int = int(time_splitted[0])
	#var minutes: int = int(time_splitted[1])	
	return Time.get_unix_time_from_datetime_string(date_time)
	#return str(hours * 60 + minutes)
	#return "%s:%s" % [hours, minutes]

func set_data(dic: Dictionary, data):
	for d in data:
		var key: int = int(d["idSignal"])
		if not dic.has(key):
			dic[key] = []
			
		dic[key].append(Reportes.new(d))
