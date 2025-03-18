package main

import rl "vendor:raylib"
import fmt "core:fmt"
Paddle :: struct {
    position: rl.Vector2,
    size: rl.Vector2,
    color: rl.Color,
}

create_paddle :: proc(posX: f32, color: rl.Color) -> (paddle: Paddle, ok: bool) {
    if posX <= 0 {
        fmt.println("Error: Invalid position for paddle creation")
        return paddle, false
    }
    return Paddle{
        position = rl.Vector2{f32(posX), f32(rl.GetScreenHeight())/2 - PADDLE_HEIGHT/2},
        size = rl.Vector2{PADDLE_WIDTH, PADDLE_HEIGHT},
        color = color,
    }, true
}

draw_paddle :: proc(paddle: Paddle) {
    rl.DrawRectangleV(paddle.position, paddle.size, paddle.color)
}

update_paddle :: proc(paddle: ^Paddle, up, down: rl.KeyboardKey) -> (ok: bool) {
    if paddle == nil {
        fmt.println("Error: Attempting to update nil paddle")
        return false
    }
    if rl.IsKeyDown(up) && paddle.position.y > 0 {
        paddle.position.y -= PADDLE_SPEED
    }

    if rl.IsKeyDown(down) && paddle.position.y < f32(rl.GetScreenHeight()) - f32(paddle.size.y) {
        paddle.position.y += PADDLE_SPEED
    }
    return true
}