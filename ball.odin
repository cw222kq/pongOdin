package main

import rl "vendor:raylib"

Ball :: struct {
    position: rl.Vector2,
    velocity: rl.Vector2,
    radius: f32,
    color: rl.Color,
}

create_ball :: proc(screen_width: i32, screen_height: i32) -> Ball {
    return Ball{
        position = rl.Vector2{f32(screen_width/2), f32(screen_height/2)}, 
        velocity = rl.Vector2{3, 3},
        radius = 10.0,
        color = rl.WHITE,
    }
}

draw_ball :: proc(ball: Ball) {
    rl.DrawCircleV(ball.position, ball.radius, ball.color)
}

update_ball :: proc(ball: ^Ball) {
    ball.position.x += ball.velocity.x
    ball.position.y += ball.velocity.y
}
