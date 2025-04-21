extends Node2D

@onready var stats_panel = $CanvasLayer/statsPanel
@onready var health_label = stats_panel.get_node("health")
@onready var attack_label = stats_panel.get_node("attackDamage")

func _ready():
	stats_panel.visible = false

func _process(delta):
	if Input.is_action_just_pressed("stats"):
		stats_panel.visible = not stats_panel.visible
		if stats_panel.visible:
			update_stats()

func update_stats():
	health_label.text = "Health: %d" % player_level_global.health
	attack_label.text = "Attack Damage: %d" % player_level_global.attackDamage
