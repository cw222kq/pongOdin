package main

import rl "vendor:raylib"

Ball :: struct {
    position: rl.Vector2,
    velocity: rl.Vector2,
    radius: f32,
    color: rl.Color,
}

create_ball :: proc() -> Ball {
    return Ball{
        position = rl.Vector2{f32(rl.GetScreenWidth()/2), f32(rl.GetScreenHeight()/2)}, 
        velocity = rl.Vector2{1, 3},
        radius = 10.0,
        color = rl.WHITE,
    }
}

draw_ball :: proc(ball: Ball) {
    rl.DrawCircleV(ball.position, ball.radius, ball.color)
}

update_ball :: proc(ball: ^Ball) {

    if (ball.position.y - ball.radius) < 0 || (ball.position.y + ball.radius) > f32(rl.GetScreenHeight()) {
        ball.velocity.y = -ball.velocity.y
    }

    ball.position.x += ball.velocity.x
    ball.position.y += ball.velocity.y
}
