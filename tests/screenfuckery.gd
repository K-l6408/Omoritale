extends Node2D

var t = 0
var winsize = Vector2i(
	ProjectSettings.get_setting("display/window/size/viewport_width"), \
	ProjectSettings.get_setting("display/window/size/viewport_height"))
var aspect = float(winsize.x) / float(winsize.y)
var winpos = DisplayServer.window_get_position()
var pos : float = winpos.x
var screen = DisplayServer.window_get_current_screen()
var screensize = DisplayServer.screen_get_size(screen)
var screenpos = DisplayServer.screen_get_position(screen)

func _process(delta):
	t += delta
	if t < 2: return
	ProjectSettings.set_setting("display/window/stretch/mode", "disabled")
	if abs(pos - get_window().position.x) > 5:
		pos = get_window().position.x + fmod(pos, 1)
	var F = f(-50, 50, t) * delta
	pos += F
	get_window().position.x = pos
	$Snuuy.global_position.x -= F / float(winsize.x) * float(get_window().size.x)
#	get_viewport().get_camera_2d().zoom = Vector2(f(winsize as Vector2, screensize as Vector2, t).x / winsize.x, f(winsize as Vector2, screensize as Vector2, t).x / winsize.x)

func f(from, to, t):
#	var y = fmod(t, 2)
#	return lerp(from, to, y) if y < 1 else lerp(from, to, 2-y)
	return lerp(from, to, (sin(t) + 1) / 2)
