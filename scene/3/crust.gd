extends MarginContainer


#region var
@onready var imprints = $Imprints
@onready var blank = $Imprints/Blank

var pizza = null
var windrose = null
var slice = null
var cut = null
var knots = []
var liaisons = {}
var anchor = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	for key in input_:
		set(key, input_[key])
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_knots()
	init_liaisons()
	blank.custom_minimum_size = Vector2(Global.vec.size.cliche)


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
			knot.crusts.append(self)


func init_liaisons() -> void:
	for knot in knots:
		for liaison in knot.liaisons:
			var _knot = liaison.get_another_knot(knot)
			
			if knots.has(_knot):
				liaisons[liaison] = 4
				
				if liaison.type != "center":
					liaisons[liaison] = 2
	
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
	if liaisons.keys().is_empty():
		anchor = null
		return
	
	if anchor != null:
		anchor.anchors.erase(self)
		
		if anchor.anchors.is_empty():
			anchor.set_rarity("rare")
		
		for liaison in anchor.liaisons:
			if liaisons.has(liaison):
				anchor.set_rarity("uncommon")
				var another = liaison.get_another_knot(anchor)
				#print([liaisons[liaison], anchor.grid, another.grid])
	
	for knot in knots:
		if check_anchor_knot(knot):
			#print(knot.grid)
			anchor = knot
			break
	
	anchor.set_rarity("ancient")
	anchor.anchors.append(self)


func check_anchor_knot(knot_: Polygon2D) -> bool:
	var rarities = ["uncommon", "mythical", "ancient"]
	
	if rarities.has(knot_.rarity):
		for liaison in knot_.liaisons:
			if liaisons.has(liaison):
				return true
	
	return false


func reset() -> void:
	for _i in range(imprints.get_child_count()-1, -1, -1):
		var imprint = imprints.get_child(_i)
		
		if imprint != blank:
			imprints.remove_child(imprint)
			imprint.queue_free()
#endregion


func add_imprint(imprint_: MarginContainer) -> void:
	if anchor != null:
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
	var rarities = ["common", "uncommon", "mythical", "ancient"]
	var counts = {}
	
	for rarity in rarities:
		counts[rarity] = 0
	
	for _grid in imprint_.grids:
		if _grid != imprint_.grids.front():
			var grid = _grid - imprint_.grids.front()
			grid += anchor.grid
			
			for axis in Global.arr.axis:
				grid[axis] = round(grid[axis])
			
			if !pizza.grids.knot.has(grid):
				return false
			else:
				var knot = pizza.grids.knot[grid]
				
				if !knots.has(knot):
					return false
				else:
					
					if !rarities.has(knot.rarity):
						return false 
					else:
						counts[knot.rarity] += 1
	
	if counts["uncommon"] + counts["mythical"] == 0:
		return false
	
	if counts["common"] + counts["uncommon"] + counts["mythical"] < 2:
		return false
	
	return true


func pop_all_imprints() -> Array:
	var result = []
	
	for _i in range(imprints.get_child_count() - 1, -1, -1):
		var imprint = imprints.get_child(_i)
		
		if imprint != blank:
			result.append(imprint)
			imprints.remove_child(imprint)
	
	return result
