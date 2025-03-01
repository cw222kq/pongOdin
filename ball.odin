package main

import rl "vendor:raylib"

Ball :: struct {
    position: rl.Vector2,
    radius: f32,
    color: rl.Color,
}

create_ball :: proc(screen_width: i32, screen_height: i32, radius: f32) -> Ball {
    return Ball{
        position = rl.Vector2{f32(screen_width/2), f32(screen_height/2)}, 
        radius = radius,
        color = rl.WHITE,
    }
}

draw_ball :: proc(ball: Ball) {
    rl.DrawCircleV(ball.position, ball.radius, ball.color)
}
