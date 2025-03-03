package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc() {
    screen_width: i32 = 1600
    screen_height: i32 = 900

	rl.InitWindow(screen_width, screen_height, "Pong")

    rl.SetTargetFPS(60)

    ball := create_ball()
    paddle_left := create_paddle(100)
    paddle_right := create_paddle(1480)
    
	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
        
        draw_ball(ball)
        update_ball(&ball)
       
        draw_paddle(paddle_left)
        draw_paddle(paddle_right)

        colliding_with_paddle(&ball, &paddle_left)
        colliding_with_paddle(&ball, &paddle_right)
        
		rl.EndDrawing()
	}

	rl.CloseWindow()
}