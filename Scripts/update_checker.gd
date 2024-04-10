extends Button


# Thank you, FaceDev, for creating and open-sourcing GriddyCode, from where I took the code <3
# https://github.com/face-hh/griddycode


const VERSION: String = "v0.1.0"
var is_requesting: bool = false
var update_available: bool = false
@onready var http: HTTPRequest = $HTTPRequest


func _on_pressed() -> void:
	if is_requesting: return

	http.request("https://api.github.com/repos/face-hh/griddycode/releases/latest")
	is_requesting = true

	if not update_available: text = " Loading... "


func _on_request_completed(_result, _response_code, _headers, body):

	var json = JSON.parse_string(body.get_string_from_utf8())
	if update_available:
		OS.shell_open(json["html_url"])
	elif !is_higher_version(json["name"]):
		text = " Up to date "
	else:
		add_theme_color_override("font_color", Color("#66FF99"))
		add_theme_color_override("font_focus_color", Color("#66FF99"))
		add_theme_color_override("font_hover_color", Color("#66FF99"))
		add_theme_color_override("font_hover_pressed_color", Color("#66FF99"))
		text = " Update available! "
		update_available = true

	is_requesting = false


func is_higher_version(new_version: String) -> bool:
	var current_components = VERSION.replace("v", "").split(".")
	var new_components = new_version.replace("v", "").split(".")

	for i in range(3):
		var current_num = current_components[i]
		var new_num = new_components[i]

		if new_num > current_num:
			return true
		elif new_num < current_num:
			return false

	return false  # Same version if we reach here
