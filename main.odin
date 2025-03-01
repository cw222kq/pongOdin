package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(800, 600, "Raylib in Odin")

    rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		rl.DrawText("Hello, World!", 20, 20, 20, rl.WHITE)
		rl.EndDrawing()
	}

	rl.CloseWindow()
}