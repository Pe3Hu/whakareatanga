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


func add_cliche() -> void:
	init_cliche()
	distribute_imprints()
	god.pizza.weigh_all_crusts()


func init_cliche() -> void:
	var options = [Vector2(1, 1), Vector2(2, 1), Vector2(1, 2)]
	var input = {}
	input.cheesemaker = self
	input.dimensions = options[0]#.pick_random()
	
	var cliche = Global.scene.cliche.instantiate()
	cliches.add_child(cliche)
	cliche.set_attributes(input)


func add_imprint(cliche_: MarginContainer, angle_: Dictionary) -> void:
	var input = {}
	input.proprietor = self
	input.cliche = cliche_
	input.origin = "original"
	input.grids = []
	var grid = Vector2()
	input.grids.append(grid)
	grid = Vector2(angle_.cathets.front())
	input.grids.append(grid)
	grid = Vector2(angle_.cathets.back())
	input.grids.append(grid)
	
	var imprint = Global.scene.imprint.instantiate()
	imprints.add_child(imprint)
	imprint.set_attributes(input)
	
	if self_repeat_check(imprint):
		imprints.remove_child(imprint)
		imprint.queue_free()


func self_repeat_check(imprint_: MarginContainer) -> bool:
	var cathets = {}
	cathets.child = imprint_.get_cathets()
	
	for _i in range(0, imprints.get_child_count() - 1, 1):
		var imprint = imprints.get_child(_i)
		cathets.parent = imprint.get_cathets()
		
		if cathets.parent == cathets.child:
			return true
	
	return false


func distribute_imprints() -> void:
	while imprints.get_child_count() > 0:
		var imprint = imprints.get_child(0)
		
		for crust in god.pizza.crusts:
			var replica = imprint.create_replica(crust)
			crust.add_imprint(replica)
		
		imprints.remove_child(imprint)
		imprint.queue_free()
	
	print("___")
	for crust in god.pizza.crusts:
		var _imprints = crust.imprints.get_children()
		print([crust.windrose, _imprints.size()])


func recycle_cliche(cliche_: MarginContainer) -> void:
	cliches.remove_child(cliche_)
	cliche_.queue_free()
#endregion
