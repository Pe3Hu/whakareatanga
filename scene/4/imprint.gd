extends MarginContainer


#region var
@onready var bg = $BG
@onready var trigon = $Trigon
@onready var knot = $Knot

var proprietor = null
var cliche = null
var grids = null
var origin = null
var verification = null
var integrity = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	for key in input_:
		set(key, input_[key])
	
	init_basic_setting()


func init_basic_setting() -> void:
	set_vertexs()
	align_trigon()
	init_knot()
	init_bg()


func set_vertexs() -> void:
	var vertexs = []
	
	for grid in grids:
		var vertex = grid * Global.num.imprint.a
		vertexs.append(vertex)
	
	trigon.set_polygon(vertexs)


func init_knot() -> void:
	var input = {}
	input.proprietor = self
	input.grid = null
	
	knot.set_attributes(input)
	knot.position = trigon.position + grids[0] * Global.num.imprint.a
	knot.set_rarity("ancient")


func align_trigon() -> void:
	custom_minimum_size = Vector2(Global.vec.size.cliche)
	var dimensions = {}
	dimensions.leftop = Vector2(grids.front())
	dimensions.rightbot = Vector2(grids.front())
	
	for grid in grids:
		dimensions.leftop.x = min(dimensions.leftop.x, grid.x)
		dimensions.leftop.y = min(dimensions.leftop.y, grid.y)
		dimensions.rightbot.x = max(dimensions.rightbot.x, grid.x)
		dimensions.rightbot.y = max(dimensions.rightbot.y, grid.y)
	
	dimensions.size = dimensions.rightbot - dimensions.leftop
	dimensions.center =  dimensions.size / 2
	dimensions.shift = dimensions.leftop + dimensions.center - grids.front()
	trigon.position = Global.vec.size.cliche / 2 - dimensions.shift * Global.num.cliche.a


func init_bg() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)


func create_replica(crust_: MarginContainer) -> MarginContainer:
	var input = {}
	input.proprietor = crust_
	input.cliche = cliche
	input.origin = "replica"
	input.grids = grids
	input.verification = "doubtful"
	
	var imprint = Global.scene.imprint.instantiate()
	add_child(imprint)
	imprint.set_attributes(input)
	remove_child(imprint)
	return imprint


func get_cathets() -> Array:
	var cathets = []
	var n = grids.size()
	
	for _i in range(1, n - 1, 1):
		var index = _i 
		var cathet = grids[index] - grids[0]
		
		for axis in Global.arr.axis:
			cathet[axis] = round(cathet[axis])
			
			if abs(cathet[axis]) == 0:
				cathet[axis] = 0
		
		cathets.append(cathet)
		index = _i + 1
		cathet = grids[index] - grids[0]
		
		for axis in Global.arr.axis:
			cathet[axis] = round(cathet[axis])
			
			if abs(cathet[axis]) == 0:
				cathet[axis] = 0
		
		cathets.append(cathet)
	
	cathets.sort_custom(func(a, b): return a.y * Global.num.pizza.m + a.x < b.y * Global.num.pizza.m + b.x)
	return cathets
#endregion
