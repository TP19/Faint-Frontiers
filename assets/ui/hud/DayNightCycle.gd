extends CanvasModulate

const DAY_COLOR = Color("#ffffff")
const NIGHT_COLOR = Color("#4f408b")
const TIME_SCALE = 0.1

var time = 0

func _process(delta:float) -> void:
	self.time += delta * TIME_SCALE
	self.color = NIGHT_COLOR.linear_interpolate(DAY_COLOR, abs(cos(time)))
	if Global.elapsed_time <= 5:
		self.color = DAY_COLOR.linear_interpolate(NIGHT_COLOR, 1)
	if Global.elapsed_time <= 0:
		self.color = DAY_COLOR.linear_interpolate(NIGHT_COLOR, 2)
	if Global.elapsed_time >= 15:
		self.color = NIGHT_COLOR.linear_interpolate(DAY_COLOR, 1)
