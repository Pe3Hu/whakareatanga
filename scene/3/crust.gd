extends MarginContainer


#region var
@onready var imprints = $Imprints
@onready var blank = $Imprints/Blank

var pizza = null
var windrose = null
var slice = null
var cut = null
var knots = []
var anchor = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	for key in input_:
		set(key, input_[key])
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_knots()
	init_blank()


func init_knots() -> void:
	var triangle = []
	triangle.append_array(cut.points)
	var points = slice.get_polygon()
	var middle = (points[1] + points[2]) / 2
	triangle.append(middle)
	
	for knot in slice.knots:
		var point = knot.position + pizza.corners[3]
		
		if pizza.check_for_point_inside_triangle(point, triangle):
			knots.append(knot)
			
			#if windrose == "nnw":
			#	knot.set_rarity("rare")
	
	order_knots()


func order_knots() -> void:
	var corner = cut.points[1]
	var center = cut.points[0]
	var datas = []
	var aspects = ["dexterity", "will"]
	
	while !knots.is_empty():
		var data = {}
		data.knot = knots.pop_front()
		var vertex = data.knot.position + pizza.corners[3]
		data.distance = {}
		data.distance.corner = abs(corner.x - vertex.x)
		data.distance.center = abs(center.y - vertex.y)
		
		if aspects.has(slice.aspect):
			data.distance.corner = abs(corner.y - vertex.y)
			data.distance.center = abs(center.x - vertex.x)
		
		datas.append(data)
	
	while !datas.is_empty():
		datas.sort_custom(func(a, b): return a.distance.center > b.distance.center)
		
		var distance = datas.front().distance.center
		var row = []
		
		for _i in range(datas.size()-1,-1,-1):
			var data = datas[_i]
			
			if data.distance.center == distance:
				row.append(data)
				datas.erase(data)
		
		row.sort_custom(func(a, b): return a.distance.corner < b.distance.corner)
		
		while !row.is_empty():
			var data = row.pop_front()
			knots.append(data.knot)
	
	update_anchor()


func update_anchor() -> void:
	if anchor != null:
		anchor.set_rarity("rare")
	else:
		for knot in knots:
			if knot.rarity == "uncommon" or knot.rarity == "ancient":
				anchor = knot
				break
	
	anchor.set_rarity("ancient")


func init_blank() -> void:
	blank.custom_minimum_size = Vector2(Global.vec.size.cliche)
#endregion


func add_imprint(imprint_: MarginContainer) -> void:
	imprints.add_child(imprint_)
	var windroses = ["nne", "sse", "ese", "wsw"]
	
	if windroses.has(windrose):
		imprints.move_child(blank, imprints.get_child_count() - 1)
	
	if !knots_check(imprint_):
		imprints.remove_child(imprint_)
		imprint_.queue_free()
	
	#if imprints.get_child_count() > 2:
	#	imprints.remove_child(imprint_)
	#	imprint_.queue_free()



func knots_check(imprint_: MarginContainer) -> bool:
	var vertexs = []
	
	for _grid in imprint_.grids:
		if _grid != imprint_.grids.front():
			var grid = _grid - imprint_.grids.front()
			grid += anchor.grid
			
			for axis in Global.arr.axis:
				grid[axis] = round(grid[axis])
			
			var flag = pizza.grids.knot.keys().has(grid)
			
			#if windrose == "wsw":
			#	print([grid, flag])
			
			if !flag:
				return false
			else:
				var knot = pizza.grids.knot[grid]
				
				if !knots.has(knot):
					return false
	
	return true

