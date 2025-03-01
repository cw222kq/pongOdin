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
		// rl.DrawCircleV(rl.Vector2{f32(screen_width/2), f32(screen_height/2)}, radius, rl.WHITE)
        create_ball(screen_width, screen_height, radius)
        create_paddle(screen_height, 100)
        create_paddle(screen_height, 1480)
		rl.EndDrawing()
	}

	rl.CloseWindow()
}