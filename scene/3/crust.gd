extends MarginContainer


#region var
@onready var imprints = $Imprints

var pizza = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pizza = input_.pizza
	
	init_basic_setting()


func init_basic_setting() -> void:
	pass


func add_imprint(angle_: Dictionary) -> void:
	var input = {}
	input.crust = self
	input.vertexs = []
	var vertex = Vector2(angle_.point)
	input.vertexs.append(vertex)
	vertex = Vector2(angle_.point + angle_.cathets.front())
	input.vertexs.append(vertex)
	vertex = Vector2(angle_.point + angle_.cathets.back())
	input.vertexs.append(vertex)
	
	var imprint = Global.scene.imprint.instantiate()
	imprints.add_child(imprint)
	imprint.set_attributes(input)
#endregion
