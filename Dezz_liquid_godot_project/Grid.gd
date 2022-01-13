extends Node2D

var cell_system = []


var y = 0

class Cell :
	var coord = Vector2(0,0)
	
	func _init(coord):
		self.coord = coord

func _ready():
	pass 

func _process(delta):
	while y != Global.structure_height :
		var x = 0
		var line = []
		var physical_line = []
		while x != Global.structure_width :
			var cell = preload("res://cell.tscn").instance()
			get_parent().add_child(cell)
			var translate_x = x * 32
			var translate_y = y * 32
			cell.translate(Vector2(translate_x,translate_y))
			cell.coord = Vector2(x,y)
				
			var template = Cell.new(cell.coord)
			
			line.append(cell)
			physical_line.append(template)

			x = x + 1
		Global.grid_map.append(line)
		cell_system.append(physical_line)
		y = y + 1
		
	if y == Global.structure_height :
		var guide = preload("res://Guide.tscn").instance()
		get_parent().add_child(guide)
		
	if Global.clicked :
		var a = Global.target_coord.y
		var b = Global.target_coord.x
		
		if !Global.grid_map[a][b].terraformed and Global.grid_map[a][b].fluid != 200:
			Global.grid_map[a][b].fluid += 50
			#print(Global.grid_map[a][b].fluid)
		Global.clicked = false
		
	if Global.terraform :
		var a = Global.target_coord.y
		var b = Global.target_coord.x
		
		if Global.grid_map[a][b].terraformed:
			Global.grid_map[a][b].get_node("Sprite").set_texture(preload("res://black_grid.png"))
			Global.grid_map[a][b].terraformed = false
		else:
			Global.grid_map[a][b].get_node("TextureProgress").visible = false
			Global.grid_map[a][b].get_node("Sprite").set_texture(preload("res://terra.png"))
			Global.grid_map[a][b].fluid = 0
			Global.grid_map[a][b].terraformed = true
		Global.terraform = false
		
	while Global.drop_seq.size() != 0 :
		var target = Global.drop_seq.front()
		Global.grid_map[target.y][target.x].drop(4)
		Global.drop_seq.pop_front()
		
	while Global.splash_west_seq.size() != 0 :
		var west = Global.splash_west_seq.front()
		Global.grid_map[west.y][west.x].splash_west(4)
		Global.splash_west_seq.pop_front()
		
	while Global.splash_east_seq.size() != 0 :
		var east = Global.splash_east_seq.front()
		Global.grid_map[east.y][east.x].splash_east(4)
		Global.splash_east_seq.pop_front()
		
	while Global.pressure_seq.size() != 0 :
		var up = Global.pressure_seq.front()
		Global.grid_map[up.y][up.x].pressure(4)
		Global.pressure_seq.pop_front()
		
	if !Global.south_block.empty():
		var stabilizer = Global.south_block.front()
		if !Global.grid_map[stabilizer.y][stabilizer.x].terraformed:
			Global.south_block.pop_front()
			Global.north_stabilizer.clear()
	if !Global.north_block.empty():
		var stabilizer = Global.north_block.front()
		if !Global.grid_map[stabilizer.y][stabilizer.x].terraformed:
			Global.north_block.pop_front()
			Global.north_stabilizer.clear()
		
#	while Global.equalizer.size() != 0 :
#		var max_fluid = 0
#		var i = 0
#		while i < Global.equalizer.front().size():
#			max_fluid += Global.grid_map[Global.equalizer.front()[i].y][Global.equalizer.front()[i].x].fluid
#			i = i + 1
#		var j = 0
#		while i < Global.equalizer.front().size():
#			var fluid_equalized = max_fluid / Global.equalizer.front().size()
#			Global.grid_map[Global.equalizer.front()[j].y][Global.equalizer.front()[j].x].fluid = fluid_equalized
#			j = j + 1
#		Global.equalizer.pop_front()
		
#	var i = 0
#	while i < Global.grid_map.size() :
#		var j = 0
#		while j < Global.grid_map[i].size() :
#			if Global.grid_map[i][j].ready_to_drop :
#				Global.grid_map[i][j].drop(25*delta)
#				Global.grid_map[i][j].ready_to_drop = false
#			j = j + 1
#		i = i + 1
