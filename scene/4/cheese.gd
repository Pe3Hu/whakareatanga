extends Polygon2D


#region var
var pizza = null
var crust = null
var knots = {}
var liaisons = []
var mass = null
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
	set_vertexs()
	set_inside_knots()
	update_crust_liaisons()


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
			if !knots.has(knot) and knot.rarity != "rare":
				var point = knot.position# + pizza.corners[3]
				print([knot.grid, point, triangle])
				
				if pizza.check_for_point_inside_triangle(point, triangle):
					knots.inside.append(knot)
					knots.total.append(knot)
					#crust.knots[knot] -= 1
					knot.set_rarity("rare")


func update_crust_liaisons() -> void:
	for knot in knots.total:
		for liaison in knot.liaisons:
			if crust.liaisons.has(liaison):
				var _knot = liaison.get_another_knot(knot)
				
				if knots.total.has(_knot):
					crust.liaisons[liaison] -= 1
					
					if crust.liaisons[liaison] == 0:
						crust.liaisons.erase(liaison)
	
	if crust.liaisons.keys().is_empty():
		for knot in knots.total: 
			knot.set_rarity("rare")
		
		crust.update_anchor()
#endregion
