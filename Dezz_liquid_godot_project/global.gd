extends Node

var structure_width = 10
var structure_height = 20

var clicked = false
var terraform = false
var grid_map = []
var drop_seq = []
var splash_west_seq = []
var splash_east_seq = []
var pressure_seq = []

var pressure_down_seq = []
var north_stabilizer = []

var south_block = []
var north_block = []
var block = []

var ask_northwest = []
var ask_northeast = []

#var ask_east = []
#var west_flow = []
#
#var equalizer = []

var target_coord = Vector2(0,0)
