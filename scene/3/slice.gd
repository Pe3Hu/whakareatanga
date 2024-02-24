extends Polygon2D


#region var
var pizza = null
var aspect = null
var knots = []
var liaisons = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pizza = input_.pizza
	aspect = input_.aspect
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	set_polygon(input_.vertexs)
	color = Global.color.slice[aspect]
#endregion
