# SPDX-FileCopyrightText: The Threadbare Authors
# SPDX-License-Identifier: MPL-2.0
extends Node

## The area to interact with the pet.
@export var interact_area: InteractArea

## Sound effect to play when interacted.
@export var sound_effect_player: AudioStreamPlayer2D

## If set, it will shake when interacted.
@export var shaker: Shaker

## If set, it will increment when interacted.
@export var fact_counter: FactCounter

## If set, it will play the sheep animation when interacted.
@export var pet_animation: AnimatedSprite2D

@export var pet_sprite_behavior: CharacterSpriteBehavior


func _ready() -> void:
	interact_area.interaction_started.connect(_on_interact_area_interaction_started)


func _on_interact_area_interaction_started(player: Player, _from_right: bool) -> void:
	interact_area.end_interaction()
	interact_area.disabled = true
	sound_effect_player.play()
	if shaker:
		shaker.shake()
	if fact_counter:
		fact_counter.increment()
	var player_is_on_right := player.global_position.x > pet_animation.global_position.x
	var base_sprite_looks_left := pet_animation.global_transform.x.x < 0.0
	pet_animation.flip_h = player_is_on_right != base_sprite_looks_left
	pet_animation.play(&"annoy")
	await pet_animation.animation_finished
	pet_animation.play(&"idle")
	if sound_effect_player.playing:
		await sound_effect_player.finished
	interact_area.disabled = false
