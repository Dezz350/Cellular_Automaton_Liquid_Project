extends Area2D

var coord = Vector2(0,0)
var mouse_in = false

var to_equalize = []

var south_neighb
var south_neighb_exist = true

var north_neighb
var north_neighb_exist = true

var west_neighb
var west_neighb_exist = true

var east_neighb
var east_neighb_exist = true

var fluid = 0
var terraformed = false

var drop = 25
var ready_to_drop = false

func _ready():
	pass 
	
func _process(delta):
	if Input.is_action_just_pressed("mouse_button_left") and mouse_in == true:
		#print(coord)
		Global.target_coord = coord
		Global.clicked = true
	if Input.is_action_just_pressed("mouse_button_right") and mouse_in == true:
		Global.target_coord = coord
		Global.terraform = true
		
	if coord.y + 1 > Global.structure_height - 1 :
		south_neighb_exist = false
	else:
		south_neighb = Global.grid_map[coord.y + 1][coord.x]
	if coord.y - 1 < 0 :
		north_neighb_exist = false
	else:
		north_neighb = Global.grid_map[coord.y - 1][coord.x]
	if coord.x - 1 < 0 :
		west_neighb_exist = false
	else:
		west_neighb = Global.grid_map[coord.y][coord.x - 1]
	if coord.x + 1 > Global.structure_width - 1 :
		east_neighb_exist = false
	else:
		east_neighb = Global.grid_map[coord.y][coord.x + 1]
		
	if north_neighb_exist:
		if fluid > 0 and north_neighb.fluid > 0:
			$TextureProgress.visible = false
			$Sprite.set_texture(preload("res://fluid.png"))
		elif fluid > 0 and north_neighb.fluid <= 0:
			$Sprite.set_texture(preload("res://black_grid.png"))
			$TextureProgress.value = fluid
			$TextureProgress.visible = true
		elif fluid <= 0 and !terraformed:
			fluid = 0
			$TextureProgress.visible = false
			$Sprite.set_texture(preload("res://black_grid.png"))
		if fluid > 90 and north_neighb.terraformed:
			$TextureProgress.visible = false
			$Sprite.set_texture(preload("res://fluid.png"))
	else:
		if fluid > 0:
			$Sprite.set_texture(preload("res://black_grid.png"))
			$TextureProgress.value = fluid
			$TextureProgress.visible = true
		elif fluid <= 0 and !terraformed:
			fluid = 0
			$TextureProgress.visible = false
			$Sprite.set_texture(preload("res://black_grid.png"))

#	if fluid > 0 :
#		$Sprite.set_texture(preload("res://fluid.png"))
#	elif fluid <= 0 and !terraformed:
#		fluid = 0
#		$Sprite.set_texture(preload("res://black_grid.png"))
		
	var depth = float(fluid)/400
	if depth > 0 :
		$Sprite.set_modulate(Color(1*(1-depth)+0.1,1*(1-depth)+0.1,1*(1-depth)+0.1))
	if terraformed:
		$Sprite.set_modulate(Color(1,1,1))
		
	if south_neighb_exist :
		if fluid > 0 and !south_neighb.terraformed and south_neighb.fluid < 90 :
			Global.drop_seq.append(coord)
			#ready_to_drop = true
		if south_neighb.fluid > 85 or south_neighb.terraformed:
			if west_neighb_exist and fluid > 4 :
				if !west_neighb.terraformed and west_neighb.fluid <= fluid:
					Global.splash_west_seq.append(coord)
			if east_neighb_exist and fluid > 4 :
				if !east_neighb.terraformed and east_neighb.fluid <= fluid:
					Global.splash_east_seq.append(coord)
	if !south_neighb_exist :
		if west_neighb_exist and fluid > 4 :
			if !west_neighb.terraformed and west_neighb.fluid <= fluid:
				Global.splash_west_seq.append(coord)
		if east_neighb_exist and fluid > 4 :
			if !east_neighb.terraformed and east_neighb.fluid <= fluid:
				Global.splash_east_seq.append(coord)
	
	if north_neighb_exist:
		if fluid > 100 and !north_neighb.terraformed:
			Global.pressure_seq.append(coord)
		if fluid > 100 and north_neighb.terraformed:
			if south_neighb_exist and west_neighb_exist and east_neighb_exist:
				if !west_neighb.terraformed and !east_neighb.terraformed:
					if south_neighb.fluid > west_neighb.fluid or south_neighb.fluid > east_neighb.fluid:
						if fluid > 130 :
							fluid = fluid - 30
							west_neighb.fluid = west_neighb.fluid + 15
							east_neighb.fluid = east_neighb.fluid + 15
					else:
						if fluid > 130 and !south_neighb.terraformed and coord != Global.block.front():
							Global.pressure_down_seq.append(south_neighb.coord)
							fluid = fluid - 30
							south_neighb.fluid = south_neighb.fluid + 30
				elif !west_neighb.terraformed and east_neighb.terraformed:
					if south_neighb.fluid > west_neighb.fluid:
						if fluid > 130 :
							fluid = fluid - 30
							west_neighb.fluid = west_neighb.fluid + 30
					else:
						if fluid > 130 and !south_neighb.terraformed and coord != Global.block.front():
							Global.pressure_down_seq.append(south_neighb.coord)
							fluid = fluid - 30
							south_neighb.fluid = south_neighb.fluid + 30
				elif west_neighb.terraformed and !east_neighb.terraformed:
					if south_neighb.fluid > east_neighb.fluid:
						if fluid > 130 :
							fluid = fluid - 30
							east_neighb.fluid = east_neighb.fluid + 30
					else:
						if fluid > 130 and !south_neighb.terraformed and coord != Global.block.front():
							Global.pressure_down_seq.append(south_neighb.coord)
							fluid = fluid - 30
							south_neighb.fluid = south_neighb.fluid + 30
				elif west_neighb.terraformed and east_neighb.terraformed:
					if fluid > 130 and !south_neighb.terraformed and coord != Global.block.front():
						Global.pressure_down_seq.append(south_neighb.coord)
						fluid = fluid - 30
						south_neighb.fluid = south_neighb.fluid + 30
			if south_neighb_exist and west_neighb_exist and !east_neighb_exist:
				if !west_neighb.terraformed:
					if south_neighb.fluid > west_neighb.fluid:
						if fluid > 130 :
							fluid = fluid - 30
							west_neighb.fluid = west_neighb.fluid + 30
					else:
						if fluid > 130 and !south_neighb.terraformed and coord != Global.block.front():
							Global.pressure_down_seq.append(south_neighb.coord)
							fluid = fluid - 30
							south_neighb.fluid = south_neighb.fluid + 30
				if west_neighb.terraformed:
					if fluid > 130 and !south_neighb.terraformed and coord != Global.block.front():
						Global.pressure_down_seq.append(south_neighb.coord)
						fluid = fluid - 30
						south_neighb.fluid = south_neighb.fluid + 30
			if south_neighb_exist and !west_neighb_exist and east_neighb_exist:
				if !east_neighb.terraformed:
					if south_neighb.fluid > east_neighb.fluid:
						if fluid > 130 :
							fluid = fluid - 30
							east_neighb.fluid = east_neighb.fluid + 30
					else:
						if fluid > 130 and !south_neighb.terraformed and coord != Global.block.front():
							Global.pressure_down_seq.append(south_neighb.coord)
							fluid = fluid - 30
							south_neighb.fluid = south_neighb.fluid + 30
				if east_neighb.terraformed:
					if fluid > 130 and !south_neighb.terraformed and coord != Global.block.front():
						Global.pressure_down_seq.append(south_neighb.coord)
						fluid = fluid - 30
						south_neighb.fluid = south_neighb.fluid + 30
	if !Global.pressure_down_seq.empty():
		if Global.pressure_down_seq.front() == coord :
			#print("in")
			if south_neighb_exist:
				if !south_neighb.terraformed:
					Global.pressure_down_seq.append(south_neighb.coord)
					fluid = fluid - 30
					south_neighb.fluid = south_neighb.fluid + 30
				if south_neighb.terraformed:
					if west_neighb_exist and east_neighb_exist:
						if !west_neighb.terraformed and !east_neighb.terraformed:
							fluid = fluid - 30
							west_neighb.fluid = west_neighb.fluid + 15
							east_neighb.fluid = east_neighb.fluid + 15
						elif west_neighb.terraformed and !east_neighb.terraformed:
							fluid = fluid - 30
							east_neighb.fluid = east_neighb.fluid + 30
						elif !west_neighb.terraformed and east_neighb.terraformed:
							fluid = fluid - 30
							west_neighb.fluid = west_neighb.fluid + 30
						elif west_neighb.terraformed and east_neighb.terraformed:
							Global.north_stabilizer.append(north_neighb.coord)
							Global.south_block.append(south_neighb.coord)
					elif !west_neighb_exist and east_neighb_exist:
						if !east_neighb.terraformed:
							fluid = fluid - 30
							east_neighb.fluid = east_neighb.fluid + 30
						elif !east_neighb.terraformed:
							Global.north_stabilizer.append(north_neighb.coord)
							Global.south_block.append(south_neighb.coord)
					elif west_neighb_exist and !east_neighb_exist:
						if !west_neighb.terraformed:
							fluid = fluid - 30
							west_neighb.fluid = west_neighb.fluid + 30
						elif !west_neighb.terraformed:
							Global.north_stabilizer.append(north_neighb.coord)
							Global.south_block.append(south_neighb.coord)
			elif !south_neighb_exist:
				if west_neighb_exist and east_neighb_exist:
					if !west_neighb.terraformed and !east_neighb.terraformed:
						fluid = fluid - 30
						west_neighb.fluid = west_neighb.fluid + 15
						east_neighb.fluid = east_neighb.fluid + 15
					elif west_neighb.terraformed and !east_neighb.terraformed:
						fluid = fluid - 30
						east_neighb.fluid = east_neighb.fluid + 30
					elif !west_neighb.terraformed and east_neighb.terraformed:
						fluid = fluid - 30
						west_neighb.fluid = west_neighb.fluid + 30
					elif west_neighb.terraformed and east_neighb.terraformed:
						Global.north_stabilizer.append(north_neighb.coord)
				elif !west_neighb_exist and east_neighb_exist:
					if !east_neighb.terraformed:
						fluid = fluid - 30
						east_neighb.fluid = east_neighb.fluid + 30
					elif !east_neighb.terraformed:
						Global.north_stabilizer.append(north_neighb.coord)
				elif west_neighb_exist and !east_neighb_exist:
					if !west_neighb.terraformed:
						fluid = fluid - 30
						west_neighb.fluid = west_neighb.fluid + 30
					elif !west_neighb.terraformed:
						Global.north_stabilizer.append(north_neighb.coord)
			Global.pressure_down_seq.pop_front()
		if !Global.north_stabilizer.empty():
			if Global.north_stabilizer.front() == coord :
				if !north_neighb.terraformed:
					Global.north_stabilizer.append(north_neighb.coord)
				elif north_neighb.terraformed:
					Global.north_block.append(north_neighb.coord)
					Global.block.append(coord)
				Global.north_stabilizer.pop_front()
				
	if  west_neighb_exist and south_neighb_exist and fluid > 1 :
		if south_neighb.west_neighb_exist :
			if south_neighb.west_neighb.west_neighb_exist :
				if west_neighb.terraformed and south_neighb.fluid > 85 and south_neighb.west_neighb.fluid > 85 and south_neighb.west_neighb.west_neighb.fluid > 85 :
					var u_equalized = west_neighb.west_neighb
					if !u_equalized.terraformed and u_equalized.fluid <= fluid :
						fluid = fluid - 1
						u_equalized.fluid = u_equalized.fluid + 1
					if fluid > 85 and north_neighb_exist :
						Global.ask_northwest.append(north_neighb.coord)
	if  east_neighb_exist and south_neighb_exist and fluid > 1 :
		if south_neighb.east_neighb_exist :
			if south_neighb.east_neighb.east_neighb_exist :
				if east_neighb.terraformed and south_neighb.fluid > 85 and south_neighb.east_neighb.fluid > 85 and south_neighb.east_neighb.east_neighb.fluid > 85 :
					var u_equalized = east_neighb.east_neighb
					if !u_equalized.terraformed and u_equalized.fluid <= fluid :
						fluid = fluid - 1
						u_equalized.fluid = u_equalized.fluid + 1
					if fluid > 85 and north_neighb_exist :
						Global.ask_northeast.append(north_neighb.coord)
						
	if !Global.ask_northwest.empty():
		if Global.ask_northwest.front() == coord :
			if west_neighb.terraformed and fluid > 1 and !west_neighb.west_neighb.terraformed and west_neighb.west_neighb.fluid <= fluid :
				fluid = fluid - 1
				west_neighb.west_neighb.fluid = west_neighb.west_neighb.fluid + 1
			if north_neighb_exist :
				if north_neighb.fluid > 1:
					Global.ask_northwest.append(north_neighb.coord)
			Global.ask_northwest.pop_front()
	if !Global.ask_northeast.empty():
		if Global.ask_northeast.front() == coord :
			if east_neighb.terraformed and fluid > 1 and !east_neighb.east_neighb.terraformed and east_neighb.east_neighb.fluid <= fluid :
				fluid = fluid - 1
				east_neighb.east_neighb.fluid = east_neighb.east_neighb.fluid + 1
			if north_neighb_exist :
				if north_neighb.fluid > 1:
					Global.ask_northeast.append(north_neighb.coord)
			Global.ask_northeast.pop_front()
						
#	if west_neighb_exist and fluid > 0 :
#		if west_neighb.terraformed:
#			if east_neighb_exist:
#				Global.ask_east.append(east_neighb.coord)
#	elif !west_neighb_exist:
#		if east_neighb_exist:
#				Global.ask_east.append(east_neighb.coord)
#	if Global.ask_east.pop_front() == coord and fluid > 0:
#		if east_neighb_exist:
#			if east_neighb.terraformed:
#				to_equalize.append(coord)
#				Global.west_flow.append(west_neighb.coord)
#			elif !east_neighb.terraformed:
#				Global.ask_east.append(east_neighb.coord)
#		elif !east_neighb_exist:
#			to_equalize.append(coord)
#			Global.west_flow.append(west_neighb.coord)
#	if Global.west_flow.pop_front() == coord :
#		to_equalize.append(east_neighb.to_equalize.pop_front())
#		if west_neighb_exist:
#			if west_neighb.terraformed:
#				Global.equalizer.append(to_equalize)
#				to_equalize.clear()
#			elif !west_neighb.terraformed:
#				Global.west_flow.append(west_neighb.coord)
#		elif !west_neighb_exist:
#			Global.equalizer.append(to_equalize)
#			to_equalize.clear()

func drop(drop_amount):
	fluid = fluid - drop_amount
	south_neighb.fluid = south_neighb.fluid + drop_amount

func splash_west(splash_amount):
	fluid = fluid - splash_amount
	west_neighb.fluid = west_neighb.fluid + splash_amount

func splash_east(splash_amount):
	fluid = fluid - splash_amount
	east_neighb.fluid = east_neighb.fluid + splash_amount
	
func pressure(up_amount):
	fluid = fluid - up_amount
	north_neighb.fluid = north_neighb.fluid + up_amount
	
func pressure_down(pressure_amount):
	fluid = fluid - pressure_amount
	south_neighb.fluid = south_neighb.fluid + pressure_amount
	
func _on_cell_mouse_entered():
	mouse_in = true

func _on_cell_mouse_exited():
	mouse_in = false

