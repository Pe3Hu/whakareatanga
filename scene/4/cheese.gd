extends Polygon2D


#region var
var proprietor = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	#custom_minimum_size = Vector2(Global.vec.size.cliche)
	set_polygon(input_.vertexs)
#endregion
