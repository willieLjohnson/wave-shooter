extends Node2D

export(Array, Dictionary) var pools = [{
	"tag": "",
	"scene": "",
	"size": 0
}]

var poolDictionary = {}
	
func _ready() -> void:
	for pool in pools:
		var objectPool = []
		var i = 0
		while i < pool.get("size"):
			var obj = create_pool_object(pool.get("scene"))
			deactivate_obj(obj)
			objectPool.push_front(obj)
			i += 1
			
		poolDictionary[pool.get("tag")] = objectPool

func create_pool_object(scene):
	var pool_obj = scene.instance()
	deactivate_obj(pool_obj)
	return pool_obj
	
func find_pool_from_tag(tag):
	var pool_result = null
	for pool in pools:
		if pool.get("tag") == tag:
			pool_result = pool
	return pool_result
	
func spawn_from_pool(tag: String, position: Vector2, rotation: float):
	if !poolDictionary.has(tag):
		print_debug("Pool with tag " + tag + "does not exist")
		return null
		
	var object_to_spawn
	if not poolDictionary[tag].empty():
		object_to_spawn = poolDictionary[tag].pop_back()
	else:
		var pool_to_add = find_pool_from_tag(tag)
		object_to_spawn = create_pool_object(pool_to_add.get("scene"))
		
	enable_obj(object_to_spawn)
	object_to_spawn.position = position
	object_to_spawn.rotation = rotation
	
	if object_to_spawn.has_method('on_object_spawned'):
		object_to_spawn.on_object_spawned()
	
	poolDictionary[tag].push_front(object_to_spawn)
	
	return object_to_spawn
	
func deactivate_obj(obj):
	obj.hide()
	obj.set_process(false)
	obj.set_physics_process(false)
	obj.set_process_input(false)
	obj.set_process_internal(false)
	obj.set_process_unhandled_input(false)
	obj.set_process_unhandled_key_input(false)

func enable_obj(obj):
	obj.show()
	obj.set_process(true)
	obj.set_physics_process(true)
	obj.set_process_input(true)
	obj.set_process_internal(true)
	obj.set_process_unhandled_input(true)
	obj.set_process_unhandled_key_input(true)
