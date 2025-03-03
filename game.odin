package main

import rl "vendor:raylib"

colliding_with_paddle :: proc(ball: ^Ball, paddle: ^Paddle) {
    paddle_area := rl.Rectangle{
        x = paddle.position.x,
        y = paddle.position.y,
        width = paddle.size.x,
        height = paddle.size.y,
    }

    if rl.CheckCollisionCircleRec(ball.position, ball.radius, paddle_area) {
        ball.velocity.x = -ball.velocity.x
    }
}
