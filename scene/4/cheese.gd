extends Polygon2D


#region var
var pizza = null
var imprint = null
var crust = null
var knots = {}
var liaisons = []
var mass = null
var base = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pizza = input_.pizza
	imprint = input_.imprint
	
	init_basic_setting()


func init_basic_setting() -> void:
	crust = imprint.proprietor
	var dimensions = imprint.cliche.dimensions
	mass = dimensions.x * dimensions.y
	set_outside_knots()
	set_base()
	set_vertexs()
	set_inside_knots()
	update_crust_liaisons()
	update_defect_status()
	accept_defect()
	update_crust_frontier()
	update_inside_knots()


func set_outside_knots() -> void:
	knots.total = []
	knots.outside = []
	knots.inside = []
	var anchor = imprint.proprietor.anchor
	
	for grid in imprint.grids:
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
					#
					#var charges = 0
					#
					#for liaison in knot.liaisons:
						#if crust.liaisons.has(liaison):
							#charges += crust.liaisons[liaison]
					#
					#print([Global.num.index.cliche, knot.grid, charges])
					#if charges < 3:
						#knot.set_rarity("rare")


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


func accept_defect() -> void:
	print(imprint.integrity)#, imprint.integrity)
	if imprint.integrity != "perfect":
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
						#_knot = liaison.get_another_knot(knot)
						#
						#if knots.inside.has(_knot):
							#_knot.set_rarity("rare")


func update_defect_status() -> void:
	var segment = []
	
	for knot in crust.frontier.knots:
		segment.append(knot.position)
	
	var counter = 0
	
	for knot in knots.outside:
		var point = knot.position
	
		if pizza.check_for_point_inside_segment(point, segment):
			counter += 1
	
	if counter < 2:
		imprint.integrity = "frontier defect"


func update_crust_frontier() -> void:
	var datas = []
	
	for _i in knots.outside.size():
		var data = {}
		data.knots = []
		data.weight = 0
		var knot = knots.outside[_i]
		data.knots.append(knot)
		var _j = (_i + 1) % knots.outside.size()
		knot = knots.outside[_j]
		data.knots.append(knot)
		
		for _knot in data.knots:
			var flag = false
			
			for liaison in _knot.liaisons:
				if crust.liaisons.has(liaison):
					if liaison.charge.get_number() > 0:
						flag = true
						break
			
			if !flag:
				data.knots.erase(_knot)
				break
			
			var index = crust.knots.find(_knot)
			data.weight += index
		
		if data.knots.size() == 2:
			_j = (_i + 2) % knots.outside.size()
			knot = knots.outside[_j]
			var grid = Vector2(knot.grid)
			
			if base == knot:
				for _knot in data.knots:
					var shift = _knot.grid - base.grid
					grid += shift
			else:
				var shift = base.grid - knot.grid
				grid += shift * 2
			
			for axis in Global.arr.axis:
				grid[axis] = round(grid[axis])
			
			if pizza.grids.knot.has(grid):
				knot = pizza.grids.knot[grid]
				
				if knot.rarity != "rare":
					#print(["#", _i, data.weight, grid, knot.rarity])
					datas.append(data)
	
	if !datas.is_empty():
		datas.sort_custom(func(a, b): return a.weight < b.weight)
		crust.frontier.knots = datas.front().knots
		crust.frontier.set_vertexs()
	else:
		pass


func update_inside_knots() -> void:
	for knot in knots.inside:
		var charges = 0
		
		for liaison in knot.liaisons:
			if crust.liaisons.has(liaison):
				#liaison.discharge(crust)
				charges += crust.liaisons[liaison]
		
		print([Global.num.index.cliche, knot.grid, charges])
		if charges < 3:
			knot.set_rarity("rare")
#endregion
