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
        velocity = rl.Vector2{3, 0},
        radius = 10.0,
        color = rl.WHITE,
    }
}

draw_ball :: proc(ball: Ball) {
    rl.DrawCircleV(ball.position, ball.radius, ball.color)
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
