package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc() {
   
    game := start_game()
    
	for !rl.WindowShouldClose() {
	
        draw_game(&game)
        update_game(&game)
        
	}

	rl.CloseWindow()
}