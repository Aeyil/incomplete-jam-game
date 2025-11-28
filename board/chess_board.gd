extends GridContainer

class_name ChessBoard

@export var cell_columns : int = 10
@export var cell_rows : int = 10
@export var board_length : int = 800

@export var cell_object : PackedScene

var black : Color = Color(0,0,0)
var white : Color = Color(255,255,255)

var all_cells : Array[Cell] =[]

func _ready():
	columns = cell_columns
	fill_board_with_cells()
	
	
func fill_board_with_cells():
	all_cells = []
	var cell_length : float = board_length / (max(cell_columns,cell_rows))
	var last_black: bool = true
	for i in cell_rows:
		for j in cell_columns:
			var new_cell : Cell = cell_object.instantiate()
			if last_black:
				new_cell.set_color(white)
				last_black = false
			else:
				new_cell.set_color(black)
				last_black = true
			new_cell.set_length(cell_length)
			new_cell.cell_number = i*cell_columns + j
			add_child(new_cell)
			all_cells.push_back(new_cell)
		if cell_columns % 2 == 0:
			last_black = !last_black
