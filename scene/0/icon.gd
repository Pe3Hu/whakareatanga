extends MarginContainer


@onready var number = $Number
@onready var textureRect = $TextureRect

var type = null
var subtype = null


func set_attributes(input_: Dictionary) -> void:
	type = input_.type
	subtype = input_.subtype
	
	custom_minimum_size = Vector2(Global.vec.size.sixteen)
	var path = "res://asset/png/"
	var exceptions = ["number"]
	
	if !exceptions.has(type):
		#custom_minimum_size = Vector2(Global.vec.size.icon)
		path += type + "/" + subtype + ".png"
		textureRect.texture = load(path)
	
	match type:
		"number":
			textureRect.visible = false
			number.visible = true
			set_number(subtype)


func get_number():
	return subtype


func change_number(value_) -> void:
	subtype += value_
	var value = subtype + 0
	
	match typeof(value_):
		TYPE_INT:
			var suffix = ""
			
			while value >= 1000:
				value /= 1000
				suffix = Global.dict.thousand[suffix]
			
			number.text = str(value) + suffix
		TYPE_FLOAT:
			value = snapped(value, 0.01)
			number.text = str(value)


func set_number(value_) -> void:
	subtype = value_
	var value = subtype + 0
	
	match typeof(value_):
		TYPE_INT:
			var suffix = ""
			
			while value >= 1000:
				value /= 1000
				suffix = Global.dict.thousand[suffix]
			
			number.text = str(value) + suffix
		TYPE_FLOAT:
			value = snapped(value, 0.01)
			number.text = str(value)

