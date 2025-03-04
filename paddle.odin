package main

import rl "vendor:raylib"

Paddle :: struct {
    position: rl.Vector2,
    size: rl.Vector2,
    color: rl.Color,
}

create_paddle :: proc(posX: f32) -> Paddle {
    return Paddle{
        position = rl.Vector2{f32(posX), f32(rl.GetScreenHeight())/2 - 200/2},
        size = rl.Vector2{20, 200},
        color = rl.WHITE,
    }
}

draw_paddle :: proc(paddle: Paddle) {
    rl.DrawRectangleV(paddle.position, paddle.size, paddle.color)
}

update_paddle :: proc(paddle: ^Paddle, up, down: rl.KeyboardKey) {
    if rl.IsKeyDown(up) && paddle.position.y > 0 {
        paddle.position.y -= 4
    }

    if rl.IsKeyDown(down) && paddle.position.y < f32(rl.GetScreenHeight()) - f32(paddle.size.y) {
        paddle.position.y += 4
    }
}