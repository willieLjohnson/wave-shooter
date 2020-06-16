extends Node2D

var BULLET_SCENE = load("res://Bullet.tscn")

func shoot(damage, direction, color) -> Vector2:
	var bullet = Global.instance_node(BULLET_SCENE, self.global_position, Global.node_creation_parent)
	bullet.init(damage, direction, Color.from_hsv(color.h, color.s, color.v * 0.6))
	Global.node_creation_parent.add_child(bullet)
	return -bullet.recoil
