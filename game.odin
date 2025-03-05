package main

import rl "vendor:raylib"
import "core:fmt"
import "core:strings"
import "core:math/rand"

Game_state :: enum {
    MENU,
    PLAYING,
    GAME_OVER,
}

Game :: struct {
    state: Game_state,
    ball: Ball,
    paddle_left: Paddle,
    paddle_right: Paddle,
    score_left: i32,
    score_right: i32,
}

new_game :: proc() -> Game {
    return Game{
        state = .MENU,
        ball = create_ball(),
        paddle_left = create_paddle(100, rl.BLUE),
        paddle_right = create_paddle(1480, rl.YELLOW),
        score_left = 0,
        score_right = 0,
    }
}

start_game :: proc() -> Game {
    screen_width: i32 = 1600
    screen_height: i32 = 900

    // Seed the random number generator
    rand.reset(u64(rl.GetTime() *1000))

    rl.InitWindow(screen_width, screen_height, "Pong")
    rl.SetTargetFPS(60)

    return new_game()
}

update_game :: proc(game: ^Game) {
    # partial switch game.state {
        case .MENU:
            if rl.IsKeyPressed(.P) {
                game.state = .PLAYING
            }
        case .PLAYING:
            update_ball(&game.ball)

            colliding_with_paddle(&game.ball, &game.paddle_left)
            colliding_with_paddle(&game.ball, &game.paddle_right)

            update_paddle(&game.paddle_left, rl.KeyboardKey.W, rl.KeyboardKey.S)
            update_paddle(&game.paddle_right, rl.KeyboardKey.UP, rl.KeyboardKey.DOWN)

            if game.ball.position.x < 0 {
                game.score_right += 1
                reset_ball(&game.ball)
            }

            if game.ball.position.x > f32(rl.GetScreenWidth()) {
                game.score_left += 1
                reset_ball(&game.ball)
            }

            if game.score_left >= 5 || game.score_right >= 5 {
                game.state = .GAME_OVER
            }
        case .GAME_OVER:
            if rl.IsKeyPressed(.R) {
                game^ = new_game()
            }         
    }
}
    
draw_game :: proc(game: ^Game) {
    rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)
        
    draw_ball(game.ball) 
    draw_paddle(game.paddle_left)
    draw_paddle(game.paddle_right)

    left_score := fmt.tprintf("%d", game.score_left)
    right_score := fmt.tprintf("%d", game.score_right)
    rl.DrawText(strings.clone_to_cstring(left_score), rl.GetScreenWidth()/2 - 120, 50, 100, rl.BLUE)
    rl.DrawText(strings.clone_to_cstring("-"), rl.GetScreenWidth()/2 - 25, 50, 100, rl.WHITE)
    rl.DrawText(strings.clone_to_cstring(right_score), rl.GetScreenWidth()/2 + 60, 50, 100, rl.YELLOW)

}

colliding_with_paddle :: proc(ball: ^Ball, paddle: ^Paddle) {
    paddle_area := rl.Rectangle{
        x = paddle.position.x,
        y = paddle.position.y,
        width = paddle.size.x,
        height = paddle.size.y,
    }

    if rl.CheckCollisionCircleRec(ball.position, ball.radius, paddle_area) {
        ball.velocity.x = -ball.velocity.x * 1.4
        ball.velocity.y *= 1.4
    }
}
