extends MarginContainer


#region var
@onready var bg = $BG
@onready var cliches = $HBox/Cliches
@onready var imprints = $HBox/Imprints

var god = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Vector2(Global.vec.size.cliche)
	init_cliche()
	distribute_imprints()


func init_cliche() -> void:
	var input = {}
	input.cheesemaker = self
	input.dimensions = Vector2(2, 1)
	
	var cliche = Global.scene.cliche.instantiate()
	cliches.add_child(cliche)
	cliche.set_attributes(input)


func add_imprint(cliche_: MarginContainer, angle_: Dictionary) -> void:
	var input = {}
	input.proprietor = self
	input.cliche = cliche_
	input.origin = "original"
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


func distribute_imprints() -> void:
	while imprints.get_child_count() > 0:
		var imprint = imprints.get_child(0)
		
		for crust in god.pizza.crusts:
			var replica = imprint.create_replica()
			crust.add_imprint(replica)
		
		imprints.remove_child(imprint)
		imprint.queue_free()
#endregion
