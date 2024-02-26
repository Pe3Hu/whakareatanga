extends Polygon2D


#region var
var pizza = null
var crust = null
var knots = {}
var liaisons = []
var mass = null
var base = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pizza = input_.pizza
	crust = input_.imprint.proprietor
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	var dimensions = input_.imprint.cliche.dimensions
	mass = dimensions.x * dimensions.y
	set_outside_knots(input_.imprint)
	set_base()
	set_vertexs()
	set_inside_knots()
	update_crust_liaisons()
	accept_defect(input_.imprint)


func set_outside_knots(imprint_: MarginContainer) -> void:
	knots.total = []
	knots.outside = []
	knots.inside = []
	var anchor = imprint_.proprietor.anchor
	
	for grid in imprint_.grids:
		var _grid = anchor.grid + grid
		
		for axis in Global.arr.axis:
			_grid[axis] = round(_grid[axis])
		
		var knot = pizza.grids.knot[_grid]
		knots.outside.append(knot)
		knots.total.append(knot)
		#crust.knots[knot] -= 1
		
		if knot.rarity == "common":
			knot.set_rarity("uncommon")


func set_base() -> void:
	var counters = {}
	counters.x = {}
	counters.y = {}
	var datas = []
	
	for knot in knots.outside:
		for axis in Global.arr.axis:
			var value = knot.grid[axis]
			
			if !counters[axis].has(value):
				counters[axis][value] = 0
			
			counters[axis][value] += 1
	
	for knot in knots.outside:
		var data = {}
		data.knot = knot
		data.count = 0
		
		for axis in Global.arr.axis:
			var value = knot.grid[axis]
			data.count += counters[axis][value]
		
		datas.append(data)
	
	datas.sort_custom(func(a, b): return a.count > b.count)
	base = datas.front().knot


func set_vertexs() -> void:
	var vertexs = []
	
	for knot in knots.outside:
		var vertex = knot.position
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func set_inside_knots() -> void:
	if mass > 1:
		var triangle = get_polygon()
		
		for knot in crust.knots:
			if !knots.outside.has(knot):
				var point = knot.position# + pizza.corners[3]
				#print([knot.grid, point, triangle])
				
				if pizza.check_for_point_inside_triangle(point, triangle):
				#	if !knots.outside.has(knot):
					knots.inside.append(knot)
					knots.total.append(knot)
					#crust.knots[knot] -= 1
					knot.set_rarity("mythical")
					
					var charges = 0
					
					for liaison in knot.liaisons:
						if crust.liaisons.has(liaison):
							charges +=  crust.liaisons[liaison]
					
					if charges < 3:
						knot.set_rarity("rare")


func update_crust_liaisons() -> void:
	for knot in knots.total:
		for liaison in knot.liaisons:
			if crust.liaisons.has(liaison):
				var _knot = liaison.get_another_knot(knot)
				
				if knots.total.has(_knot):
					liaison.discharge(crust)
	
	if crust.liaisons.keys().is_empty():
		for knot in knots.total: 
			knot.set_rarity("rare")
		
		crust.update_anchor()


func accept_defect(imprint_: MarginContainer) -> void:
	print(imprint_.integrity)#, imprint_.integrity)
	if imprint_.integrity != "perfect":
		var triangle = []
		var base_mirror = Vector2(base.grid)
		
		for knot in knots.outside:
			if knot != base:
				var grid = knot.grid - base.grid
				base_mirror += grid
				triangle.append(knot.position)
		
		for axis in Global.arr.axis:
			base_mirror[axis] = round(base_mirror[axis])
		
		var _knot = pizza.grids.knot[base_mirror]
		triangle.append(_knot.position)
		
		for knot in crust.knots:#pizza.knots.get_children():
			if !knots.total.has(knot):
				var point = knot.position
				
				if pizza.check_for_point_inside_triangle(point, triangle):
					for liaison in knot.liaisons:
						while crust.liaisons.has(liaison):
							liaison.discharge(crust)
						
						knot.defects.append(crust)
					
					print(knot.grid)
#endregion
