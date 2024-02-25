extends MarginContainer


#region vars
@onready var pizza = $HBox/Pizza
@onready var cheesemaker = $HBox/Cheesemaker

var pantheon = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pantheon = input_.pantheon
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.god = self
	pizza.set_attributes(input)
	cheesemaker.set_attributes(input)
	
	for _i in 5:
		cheesemaker.add_cliche()
		pizza.make_cheese("nnw")
	
	#for _i in 3:
		#cheesemaker.add_cliche()
		#pizza.make_cheese("nne")
	
	#cheesemaker.add_cliche()
#endregion
