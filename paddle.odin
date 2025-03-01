package main

import rl "vendor:raylib"

Paddle :: struct {
    position: rl.Vector2,
    size: rl.Vector2,
    color: rl.Color,
}

create_paddle :: proc(screen_height: i32, posX: f32) -> Paddle {
    return Paddle{
        position = rl.Vector2{f32(posX), f32(screen_height)/2 - 200/2},
        size = rl.Vector2{20, 200},
        color = rl.WHITE,
    }
}

draw_paddle :: proc(paddle: Paddle) {
    //rl.DrawRectangleV(rl.Vector2{f32(200/2), f32((screen_height/2) - 200/2)}, rl.Vector2{f32(20), f32(200)}, rl.WHITE)
    rl.DrawRectangleV(paddle.position, paddle.size, paddle.color)
}