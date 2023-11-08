extends CharacterBody2D
class_name Player

const SPEED := 80;
var is_on_attack := false
var attack_damage = 55

@onready var screensize = get_viewport_rect().size

func _process(_delta):
	if Input.is_action_just_pressed("attack_soft") and !is_on_attack:
		is_on_attack = true
		$Settings/Hit.play()
		$Body.play("Attack_Soft")
	
	motion_ctrl()
	anim_ctrl()
	flip_shapes()
	

func anim_ctrl() -> void:
	var AXIS_X = GLOBAL.get_axis().x;
	var AXIS_Y = GLOBAL.get_axis().y;
	
	if !is_on_attack:
		if AXIS_X != 0 or AXIS_Y != 0:
			$Body.play("Walk")
		else:
			$Body.play("Idle")


func flip_shapes() -> void:
	var AXIS_X = GLOBAL.get_axis().x;
	var is_flip = AXIS_X < 0 if AXIS_X != 0 else $Body.flip_h
	$Body.flip_h = is_flip
	
	if is_flip:
		$Collision.position.x = 5
		$HitAttack/CollisionHit.position.x = -21
	else:
		$Collision.position.x = -5
		$HitAttack/CollisionHit.position.x = 21


func motion_ctrl() -> void:
	if !is_on_attack:
		velocity.x = GLOBAL.get_axis().x * SPEED
		velocity.y = GLOBAL.get_axis().y * -SPEED
		
		move_and_slide()
	
		position.x = clamp(position.x, 0, screensize.x)
		position.y = clamp(position.y, 0, screensize.y)


func _on_body_animation_finished():
	if $Body.animation == "Attack_Soft":
		is_on_attack = false


func _on_body_animation_changed():
	$HitAttack/CollisionHit.disabled = $Body.animation != "Attack_Soft"


func _on_hit_attack_body_entered(body: Node2D):
	print(body.name)
	if body.is_in_group("Enemy"):
		body.make_damage(attack_damage)
