extends MarginContainer


#region var
@onready var bg = $BG
@onready var slices = $Slices
@onready var cuts = $Cuts
@onready var liaisons = $Liaisons
@onready var knots = $Knots
@onready var nne = $NNE
@onready var ene = $ENE
@onready var ese = $ESE
@onready var sse = $SSE
@onready var ssw = $SSW
@onready var wsw = $WSW
@onready var wnw = $WNW
@onready var nnw = $NNW

var god = null
var corners = []
var crusts = []
var grids = {}
var center = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_cornres()
	init_slices()
	init_cuts()
	init_knots()
	init_liaisons()
	init_crusts()


func init_cornres() -> void:
	var order = "odd"
	var n = 4
	var r = Global.num.pizza.r
	
	for _i in n:
		var corner = Global.dict.corner.vector[n][order][_i] * r
		corners.append(corner)
	
	custom_minimum_size = corners[1] - corners[3]
	custom_minimum_size += Global.vec.size.cliche * 2
	center = custom_minimum_size / 2


func init_slices() -> void:
	slices.position = center
	var n = corners.size()
	
	for _i in n:
		var input = {}
		input.pizza = self
		input.aspect = Global.arr.aspect[_i]
		input.vertexs = [Vector2()]
		
		for _j in 2:
			var index = (_i + _j + n - 1) % n
			var vertex = corners[index]
			input.vertexs.append(vertex)
	
		var slice = Global.scene.slice.instantiate()
		slices.add_child(slice)
		slice.set_attributes(input)


func init_cuts() -> void:
	cuts.position = center
	var n = corners.size()
	
	for _i in n:
		var input = {}
		input.pizza = self
		input.essence = Global.arr.essence[_i]
		#input.vertexs = []
		#var vertex = Vector2()
		#input.vertexs.append(vertex)
		#vertex = Vector2()
		#var index = (_i + n ) % n
		#vertex = Vector2(corners[index])
		#input.vertexs.append(vertex)
		input.vertexs = [Vector2(), corners[_i]]
	
		var cut = Global.scene.cut.instantiate()
		cuts.add_child(cut)
		cut.set_attributes(input)


func init_knots() -> void:
	grids.knot = {}
	knots.position = Global.vec.size.cliche
	
	for _i in Global.num.pizza.m:
		for _j in Global.num.pizza.m:
			var input = {}
			input.proprietor = self
			input.grid = Vector2(_j, _i)
			
			var knot = Global.scene.knot.instantiate()
			knots.add_child(knot)
			knot.set_attributes(input)
	
	for cut in cuts.get_children():
		cut.order_knots()
		
		for knot in cut.knots:
			knot.set_rarity("uncommon")
		
		#cut.knots[0].set_rarity("rare")
		#cut.knots[1].set_rarity("mythical")


func init_liaisons() -> void:
	liaisons.position = Global.vec.size.cliche
	
	for knot in knots.get_children():
		for direction in Global.dict.neighbor.linear2:
			var grid = knot.grid + direction
			
			if grids.knot.has(grid):
				var neighbor = grids.knot[grid]
				
				if !knot.neighbors.has(neighbor):
					add_liaison(knot, neighbor, direction)


func add_liaison(first_: Polygon2D, second_: Polygon2D, direction_: Vector2) -> void:
	var input = {}
	input.proprietor = self
	input.knots = [first_, second_]
	
	var liaison = Global.scene.liaison.instantiate()
	liaisons.add_child(liaison)
	liaison.set_attributes(input)
	
	first_.neighbors[second_] = liaison
	second_.neighbors[first_] = liaison
	first_.liaisons[liaison] = second_
	second_.liaisons[liaison] = first_
	first_.directions[direction_] = liaison
	var index = Global.dict.neighbor.linear2.find(direction_)
	index = (index + Global.num.knot.quartet / 2) % Global.num.knot.quartet
	second_.directions[Global.dict.neighbor.linear2[index]] = liaison


func init_crusts() -> void:
	for _i in Global.arr.windrose.size():
		var input = {}
		input.pizza = self
		input.windrose = Global.arr.windrose[_i]
		var multiplicity = ((_i + 1) / 2) % 2
		var crust = get(input.windrose)
		
		if multiplicity == 0:
			crust.imprints.columns = Global.num.crust.n
		
		var index = (floor(_i + 1) / 2) % Global.arr.aspect.size()
		input.slice = slices.get_child(index)
		index = floor(_i / 2)
		var cut = cuts.get_child(index)
		input.cut = cuts.get_child(index)
		crust.set_attributes(input)
		crusts.append(crust)
	
	#var crust = get("wsw")
	#
	#for knot in crust.knots:
		#knot.set_rarity("mythical")
		#print(knot.grid)


func check_for_knot_inside_slice(knot_: Polygon2D, slice_: Polygon2D) -> bool:
	var triangle = slice_.get_polygon()
	var point = knot_.position + corners[3]
	return check_for_point_inside_triangle(point, triangle)


func check_for_point_inside_triangle(point_: Vector2, triangle_: Array) -> bool:
	var a = point_
	var b = triangle_[0]
	var c = triangle_[1]
	var d = triangle_[2]
	var flags = {}
	flags.b = (b.x - a.x) * (c.y - b.y) - (c.x - b.x) * (b.y - a.y)
	flags.c = (c.x - a.x) * (d.y - c.y) - (d.x - c.x) * (c.y - a.y)
	flags.d = (d.x - a.x) * (b.y - d.y) - (b.x - d.x) * (d.y - a.y)
	
	var edge = false
	
	for _i in triangle_.size():
		var segment = []
		
		for _j in 2:
			var index = (_i + _j) % triangle_.size()
			var vertex = triangle_[index]
			segment.append(vertex)
		
		if check_for_point_inside_segment(point_, segment):
			edge = true
			break
	
	var inside = sign(flags.b) == sign(flags.c) and sign(flags.c) == sign(flags.d) #and sign(flags.c) == sign(flags.d)
	#print([inside, edge])
	return edge or inside


func check_for_point_inside_segment(point_: Vector2, segment_: Array) -> bool:
	var a = point_
	var b = segment_[0]
	var c = segment_[1]
	
	var distances = {}
	distances.a = sqrt(pow(c.x - b.x, 2) + pow(c.y - b.y, 2))
	distances.b = sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2))
	distances.c = sqrt(pow(c.x - a.x, 2) + pow(c.y - a.y, 2))
	var gap = abs(distances.b + distances.c - distances.a)
	return gap <= 1


func check_for_knot_inside_cut(knot_: Polygon2D, cut_: Line2D) -> bool:
	var segment = cut_.points
	var point = knot_.position + corners[3]
	return check_for_point_inside_segment(point, segment)
#endregion


#region bg
func init_bg() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)


func set_bg_color(color_: Color) -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = color_
#endregion
