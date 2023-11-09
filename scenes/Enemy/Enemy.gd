extends CharacterBody2D

enum States { IDLE, RUN, DAMAGE, DIE, ATTACK }

const SPEED := 70
var life := 100
var _state := States.IDLE

@onready var _timer: Timer = $Timer

func _process(_delta):
	_state_matching()
	move_and_slide()
	
	if $Left.is_colliding() and !is_on_wall():
		velocity.x = -SPEED
		_state = States.RUN
	elif $Right.is_colliding() and !is_on_wall():
		velocity.x = SPEED
		_state = States.RUN
	

func _state_matching():
	match _state:
		States.IDLE:
			idle_action()
		States.RUN:
			run_action()
		States.DAMAGE:
			damage_action()
		States.DIE:
			die_action()
		States.ATTACK:
			attack_action()


func make_damage(damage) -> void:
	var new_life = life - damage
	
	if new_life < life:
		if new_life > 0:
			life = new_life
			_state = States.DAMAGE
		else:
			life = 0
			_state = States.DIE
			

func idle_action():
	$Body.play("Idle")

func run_action():
	if is_on_wall():
		_state = States.IDLE
		_timer.start(5)
		_state = States.ATTACK
	elif _state == States.RUN:
		$Body.play("Run")

func damage_action():
	$Body.play("Damage")

func die_action():
	$Body.play("Died")
	
func attack_action():
	$Body.play("Attack")

func _on_body_animation_finished():
	if $Body.animation == "Damage":
		_state = States.IDLE
	
	if $Body.animation == "Attack":
		GLOBAL.life -= 10
	
	if $Body.animation == "Died":
		GLOBAL.score += 150
		print("GLOBAL ", GLOBAL.score)
		set_process(false)
		queue_free()
