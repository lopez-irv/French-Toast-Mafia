extends CharacterBody2D


const SPEED = 300.0
var vel: float
var direction  := Vector2.ZERO


	

func _physics_process(delta: float) -> void:
	move_local_x(vel * SPEED * delta)


	

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("Sword hit:", body.name)
	if body and body.has_method("take_damage"):
		#print("Calling take_damage on", body.name)
		body.take_damage(player_level_global.attackDamage)
		player_level_global.xp += 50 #NEW XP STUFF
		#print("XP increased to ", player_level_global.xp)
		queue_free()
		if player_level_global.xp %100 == 0: 
			player_level_global.level_up()
			#print ("Player Level is: ", player_level_global.playerLevel)
	
