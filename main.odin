package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc() {
   
    game, ok := start_game()
    if !ok {
        fmt.println("Failed to start game")
        return
    }

    defer cleanup_game(&game)
    defer rl.CloseWindow()
    defer rl.CloseAudioDevice()
    
	for !rl.WindowShouldClose() {
	
        draw_game(&game)
        update_game(&game)
	}

    fmt.println("Closing game.....")
    //defer rl.CloseWindow()
    //defer rl.CloseAudioDevice()
    //defer unload_sound(&game.sound_manager)
    
	//rl.CloseWindow()
}