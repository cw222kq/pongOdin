package main

import rl "vendor:raylib"
import "core:math/rand"
import "core:math"

Ball :: struct {
    position: rl.Vector2,
    velocity: rl.Vector2,
    speed: f32,
    radius: f32,
    color: rl.Color,
}

create_ball :: proc() -> Ball {
    initial_speed : f32= 3.0
    return Ball{
        position = rl.Vector2{f32(rl.GetScreenWidth()/2), f32(rl.GetScreenHeight()/2)}, 
        velocity = get_random_velocity(initial_speed),
        radius = 10.0,
        color = rl.WHITE,
    }
}

draw_ball :: proc(ball: Ball) {
    ball_color := ball.velocity.x > 0 ? rl.BLUE : rl.YELLOW
    rl.DrawCircleV(ball.position, ball.radius, ball_color)
}

colliding_with_wall :: proc(ball: ^Ball) -> bool {
    min_y := ball.radius
    max_y := f32(rl.GetScreenHeight()) - ball.radius

    return ball.position.y < min_y || ball.position.y > max_y
}

update_ball :: proc(ball: ^Ball) {
   
    if colliding_with_wall(ball) {
        ball.velocity.y = -ball.velocity.y
    }

    ball.position.x += ball.velocity.x
    ball.position.y += ball.velocity.y
}

reset_ball :: proc(ball: ^Ball) {
    // Set position to center of screen
    ball.position = rl.Vector2{f32(rl.GetScreenWidth()/2), f32(rl.GetScreenHeight()/2)}
    initial_speed: f32 = 3.0
    ball.velocity = get_random_velocity(initial_speed) 
}

get_random_velocity :: proc(speed: f32) -> rl.Vector2 {
    // Random angle between -45 and 45 degrees, converted to radians
    angle := rand.float32_range(-45.0, 45.0) * math.PI / 180.0

    // Calculate velocity with random direction
    velocity := rl.Vector2{ speed * math.cos(angle), speed * math.sin(angle) }

    // Randomly flip horizontal direction
    if rand.int31() % 2 == 0 {
        velocity.x = -velocity.x
    }

    return velocity
}

