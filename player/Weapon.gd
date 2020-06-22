extends Node2D

export(PackedScene) var bullet_type

func shoot(damage, direction, color) -> Vector2:
	var bullet = Global.instance_node(bullet_type, self.global_position, Global.node_creation_parent)
	bullet.init(damage, direction, Color.from_hsv(color.h, color.s, color.v * 0.6))
	return -bullet.recoil
