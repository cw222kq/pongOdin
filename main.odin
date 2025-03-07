package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc() {
   
    game := start_game()
    defer rl.CloseWindow()
    defer rl.CloseAudioDevice()
    defer unload_sound(&game.sound_manager)
    
	for !rl.WindowShouldClose() {
	
        draw_game(&game)
        update_game(&game)
	}

	rl.CloseWindow()
}