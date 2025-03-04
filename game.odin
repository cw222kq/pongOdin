package main

import rl "vendor:raylib"

Game :: struct {
    ball: Ball,
    paddle_left: Paddle,
    paddle_right: Paddle,
}

new_game :: proc() -> Game {
    return Game{
        ball = create_ball(),
        paddle_left = create_paddle(100),
        paddle_right = create_paddle(1480),
    }
}

start_game :: proc() -> Game {
    screen_width: i32 = 1600
    screen_height: i32 = 900

    rl.InitWindow(screen_width, screen_height, "Pong")
    rl.SetTargetFPS(60)

    return new_game()
}

update_game :: proc(game: ^Game) {
    update_ball(&game.ball)

    colliding_with_paddle(&game.ball, &game.paddle_left)
    colliding_with_paddle(&game.ball, &game.paddle_right)
}

draw_game :: proc(game: ^Game) {
    rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
        
    draw_ball(game.ball) 
    draw_paddle(game.paddle_left)
    draw_paddle(game.paddle_right)

    rl.EndDrawing()
}

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
