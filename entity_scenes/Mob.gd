extends "res://entity_scenes/AnimatedEntity.gd"

onready var entities = get_node("/root/World/entities")

func _ready():
	health = MAX_HEALTH
	mana = MAX_MANA
	stamina = MAX_STAMINA
	defense = MAX_DEFENSE
	speed = MAX_SPEED
	damage = MAX_DAMAGE

	update_state("walking")	
	who = "mob"

remote func remote_move(p, v):
	position = p
	velocity = v
	flip_state(velocity.x < 0)
	if (abs(velocity.x) > 0):
		update_state("walking")
	
#TODO: Server should manage attacks
func _on_Area2D_body_entered(body):
	if body.collision_layer == Base.PLAYER_COLLISION_LAYER:
		update_state("attacking")

func _on_Area2D_body_exited(body):
	if body.collision_layer == Base.PLAYER_COLLISION_LAYER:
		update_state("walking")

func take_damage(x):
	rpc_id(1, "take_damage", x)

remote func set_health(h):
	health = h
	get_node("Health").update(health)

remote func delete():
	queue_free()

func check_health():
	if (health <= 0):
		queue_free()