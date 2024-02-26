extends Polygon2D


#region vars
@onready var index = $Index

var proprietor = null
var grid = null
var neighbors = {}
var liaisons = {}
var directions = {}
var slices = []
var cuts = []
var crusts = []
var anchors = []
var defects = []
var rarity = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	grid = input_.grid
	
	init_basic_setting()


func init_basic_setting() -> void:
	if grid != null:
		position = grid * Global.vec.size.knot
		proprietor.grids.knot[grid] = self
		
		init_index()
		set_slices()
		set_cuts()
	
	set_vertexs()
	set_rarity("common")


func set_vertexs() -> void:
	var order = "even"
	var corners = 4
	var r = Global.num.knot.r
	var vertexs = []
	
	for corner in corners:
		var vertex = Global.dict.corner.vector[corners][order][corner] * r
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func set_slices() -> void:
	for slice in proprietor.slices.get_children():
		var flag = proprietor.check_for_knot_inside_slice(self, slice)
		
		if flag:
			slices.append(slice)
			slice.knots.append(self)


func set_cuts() -> void:
	for cut in proprietor.cuts.get_children():
		var flag = proprietor.check_for_knot_inside_cut(self, cut)
		
		if flag:
			cuts.append(cut)
			cut.knots.append(self)


func init_index() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.knot
	index.set_attributes(input)
	Global.num.index.knot += 1


func set_rarity(rarity_: String) -> void:
	rarity = rarity_
	
	if rarity == "rare" and crusts.size() > 1:
		rarity = "mythical"
	
	paint_to_match()


func paint_to_match() -> void:
	color = Global.color.knot[rarity]
#endregion
