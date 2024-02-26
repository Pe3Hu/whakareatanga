extends Line2D


#region vars
@onready var index = $Index
@onready var charge = $Charge

var proprietor = null
var knots = []
var crusts = {}
var type = null
var side = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	knots = input_.knots
	type = input_.type
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_icons()
	set_vertexs()
	paint_to_match()


func init_icons() -> void:
	var input = {}
	input.type = "number"
	input.subtype = Global.num.index.liaison
	index.set_attributes(input)
	Global.num.index.liaison += 1
	
	input.subtype = 0
	charge.set_attributes(input)


func set_vertexs() -> void:
	for knot in knots:
		var vertex = knot.position
		add_point(vertex)
		index.position += vertex
	
	index.position /= knots.size()
	index.position.x -= index.custom_minimum_size.x * 0.5
	index.position.y -= index.custom_minimum_size.y * 0.5
	charge.position = index.position


func paint_to_match() -> void:
	default_color = Global.color.liaison[type]
#endregion


func get_another_knot(knot_: Polygon2D) -> Variant:
	if knots.has(knot_):
		for knot in knots:
			if knot != knot_:
				return knot
	
	return null


func update_axis() -> void:
	for axis in Global.arr.axis:
		var flag = true
		
		for knot in knots:
			flag = flag and proprietor.axises.knot[axis].has(knot)
		
		if flag:
			proprietor.axises.liaison[axis].append(self)
			update_side()


func update_side() -> void:
	var sides = {}
	
	for knot in knots:
		for _side in knot.sides:
			if !sides.has(_side):
				sides[_side] = 0
			
			sides[_side] += 1
	
	for _side in sides:
		if sides[_side] == 2:
			side = _side
			proprietor.sides.liaison[side].append(self)


func change_charge(value_: int) -> void:
	charge.change_number(value_)


func add_crust(crust_: MarginContainer) -> void:
	var value = 2
	
	if type != "center":
		value = 1
	
	crust_.liaisons[self] = value * 2
	crusts[self] = value
	change_charge(value)


func discharge(crust_: MarginContainer) -> void:
	crust_.liaisons[self] -= 1
	crusts[self] -= 1
	
	if crust_.liaisons[self] == 0:
		crust_.liaisons.erase(self)
	
	change_charge(-1)
