extends Node2D

@onready var player_health_bar: TextureProgressBar = $CanvasLayer/PlayerHealthbar
@onready var crusher_1_health_bar: TextureProgressBar = $CanvasLayer/Crusher1Healthbar
@onready var crusher_2_health_bar: TextureProgressBar = $CanvasLayer/Crusher2Healthbar
@onready var win_ui: Button = $CanvasLayer/WinUI
@onready var flawless_ui: Button = $CanvasLayer/FlawlessUI
@onready var lose_ui: Button = $CanvasLayer/LoseUI

func update_player_health(value: float):
	player_health_bar.value = value

var crushers_destroyed : int = 0
func update_crusher_1_health(value: int):
	crusher_1_health_bar.value = value

	if crusher_1_health_bar.value <= 0:
		crushers_destroyed+=1
		check_win()

func update_crusher_2_health(value: int):
	crusher_2_health_bar.value = value

	if crusher_2_health_bar.value <= 0:
		crushers_destroyed+=1
		check_win()

func check_win():
	if crushers_destroyed >= 2:
		enable_win_ui()

func enable_win_ui():
	if player_health_bar.value >= 100:
		flawless_ui.visible = true
	else:
		win_ui.visible = true
func enable_lose_ui():
	lose_ui.visible = true

func _on_lose_ui_pressed():
	reload_game()

func _on_win_ui_pressed():
	reload_game()

func reload_game():
	get_tree().reload_current_scene()
