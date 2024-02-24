extends Line2D


#region var
var pizza = null
var essence = null
var knots = []
#endregion


func set_attributes(input_: Dictionary) -> void:
	pizza = input_.pizza
	essence = input_.essence
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	for vertex in input_.vertexs:
		add_point(vertex)
	
	default_color = Global.color.cut[essence]


func order_knots() -> void:
	var corner = points[1]
	var datas = []
	
	while !knots.is_empty():
		var data = {}
		data.knot = knots.pop_front()
		var vertex = data.knot.position + pizza.corners[3]
		data.distance = corner.distance_to(vertex)
		datas.append(data)
	
	datas.sort_custom(func(a, b): return a.distance < b.distance)
	
	while !datas.is_empty():
		var data = datas.pop_front()
		knots.append(data.knot)
#endregion
