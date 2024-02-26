extends Line2D


#region vars
var crust = null
var knots = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	crust = input_.crust
	knots = input_.knots
	
	init_basic_setting()


func init_basic_setting() -> void:
	set_vertexs()
	paint_to_match()


func set_vertexs() -> void:
	points = []
	
	for knot in knots:
		var vertex = knot.position
		add_point(vertex)


func paint_to_match() -> void:
	default_color = Global.color.frontier[crust.slice.aspect]
#endregion
