tool
extends Node2D

export(float) var radius setget set_radius
export(Color) var color setget set_color

func _draw() -> void:
	draw_circle(position, radius, color)

func set_radius(new_radius):
	if radius != new_radius:
		radius = new_radius
		update()

func set_color(new_color):
	if color != new_color:
		color = new_color
		update()
