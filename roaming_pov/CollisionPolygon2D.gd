extends Polygon2D

var OutLine = Color(255, 0, 0)
var Width = 30.0

func _ready():
	_draw()
	
func _draw():
	var poly = get_polygon()
	for i in range(1 , poly.size()):
		draw_line(poly[i-1] , poly[i], OutLine , Width)
	draw_line(poly[poly.size() - 1] , poly[0], OutLine , Width)
