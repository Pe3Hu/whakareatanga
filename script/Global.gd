extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	arr.aspect = ["strength", "dexterity", "intellect", "will"]
	arr.essence = ["flesh", "nerve", "blood", "bone"]
	arr.dimensions = [1, 2, 3]
	arr.windrose = ["nne", "ene", "ese", "sse", "ssw", "wsw", "wnw", "nnw"]
	arr.axis = ["x", "y"]


func init_num() -> void:
	num.index = {}
	num.index.knot = 0
	num.index.liaison = 0
	
	num.area = {}
	num.area.col = 5
	num.area.row = num.area.col
	
	num.knot = {}
	num.knot.r = 4
	num.knot.quartet = 4
	
	num.liaison = {}
	num.liaison.l = 30
	
	num.cliche = {}
	num.cliche.a = num.liaison.l
	
	num.imprint = {}
	num.imprint.a = num.liaison.l# * num.imprint.scale
	
	num.pizza = {}
	num.pizza.n = 3
	num.pizza.m = num.pizza.n * 2 + 1
	num.pizza.a = num.liaison.l * (num.pizza.m - 1)#int(850/2*0.75)
	num.pizza.r = num.pizza.a / sqrt(2)
	
	num.crust = {}
	num.crust.n = 6


func init_dict() -> void:
	init_neighbor()
	init_corner()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_corner() -> void:
	dict.order = {}
	dict.order.pair = {}
	dict.order.pair["even"] = "odd"
	dict.order.pair["odd"] = "even"
	var corners = [3,4,6]
	dict.corner = {}
	dict.corner.vector = {}
	
	for corners_ in corners:
		dict.corner.vector[corners_] = {}
		dict.corner.vector[corners_].even = {}
		
		for order_ in dict.order.pair.keys():
			dict.corner.vector[corners_][order_] = {}
		
			for _i in corners_:
				var angle = 2 * PI * _i / corners_ - PI / 2
				
				if order_ == "odd":
					angle += PI/corners_
				
				var vertex = Vector2(1,0).rotated(angle)
				dict.corner.vector[corners_][order_][_i] = vertex

func init_blank() -> void:
	dict.blank = {}
	dict.blank.title = {}
	
	var path = "res://asset/json/poupou_blank.json"
	var array = load_data(path)
	
	for blank in array:
		var data = {}
		
		for key in blank:
			if key != "title":
				data[key] = blank[key]
		
		dict.blank.title[blank.title] = data


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.planet = load("res://scene/2/planet.tscn")
	scene.area = load("res://scene/2/area.tscn")
	
	scene.slice = load("res://scene/3/slice.tscn")
	scene.cut = load("res://scene/3/cut.tscn")
	scene.knot = load("res://scene/3/knot.tscn")
	scene.liaison = load("res://scene/3/liaison.tscn")
	
	scene.cliche = load("res://scene/4/cliche.tscn")
	scene.imprint = load("res://scene/4/imprint.tscn")
	scene.cheese = load("res://scene/4/cheese.tscn")


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.sixteen = Vector2(16, 16)
	
	vec.size.area = Vector2(96, 96)
	vec.size.cliche = Vector2.ONE * arr.dimensions.back() * num.cliche.a
	#vec.size.imprint = Vector2.ONE * num.imprint.a
	vec.size.knot = Vector2.ONE * num.liaison.l
	
	
	vec.scale = {}
	vec.scale.imprint = Vector2.ONE * 0.5
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.slice = {}
	color.slice.strength = Color.from_hsv(0 / h, 0.4, 0.9)
	color.slice.dexterity = Color.from_hsv(120 / h, 0.4, 0.9)
	color.slice.intellect = Color.from_hsv(210 / h, 0.4, 0.9)
	color.slice.will = Color.from_hsv(270 / h, 0.4, 0.9)
	
	color.cut = {}
	color.cut.flesh = Color.from_hsv(180 / h, 0.6, 0.9)
	color.cut.nerve = Color.from_hsv(240 / h, 0.6, 0.9)
	color.cut.blood = Color.from_hsv(300 / h, 0.6, 0.9)
	color.cut.bone = Color.from_hsv(90 / h, 0.6, 0.9)
	
	color.liaison = {}
	color.liaison.unavailable = Color.from_hsv(30 / h, 0.6, 0.7)
	color.liaison.available = Color.from_hsv(210 / h, 0.9, 0.7)
	color.liaison.incomplete = Color.from_hsv(0 / h,  0.9, 0.7)
	color.liaison.completed = Color.from_hsv(270 / h, 0.9, 0.7)
	
	color.knot = {}
	color.knot.common = Color.from_hsv(0 / h, 0.0, 0.5)
	color.knot.uncommon = Color.from_hsv(120 / h, 0.9, 0.9)
	color.knot.rare = Color.from_hsv(210 / h, 0.9, 0.9)
	color.knot.mythical = Color.from_hsv(270 / h, 0.9, 0.9)
	color.knot.ancient = Color.from_hsv(0 / h, 0.9, 0.9)
	color.knot.legendary = Color.from_hsv(30 / h, 0.9, 0.9)
	color.knot.immortal = Color.from_hsv(60 / h, 0.9, 0.9)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
