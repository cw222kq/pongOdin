package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc() {
    screen_width: i32 = 1600
    screen_height: i32 = 900
    radius: f32 = 10.0

	rl.InitWindow(screen_width, screen_height, "Pong")

    rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
        ball := create_ball(screen_width, screen_height, radius)
        draw_ball(ball)
        paddle_left := create_paddle(screen_height, 100)
        draw_paddle(paddle_left)
        paddle_right := create_paddle(screen_height, 1480)
        draw_paddle(paddle_right)
		rl.EndDrawing()
	}

	rl.CloseWindow()
}