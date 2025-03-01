package main

import rl "vendor:raylib"

draw_paddle :: proc(screen_height: i32, posX: f32) {
    size := rl.Vector2{20, 200}
    //rl.DrawRectangleV(rl.Vector2{f32(200/2), f32((screen_height/2) - 200/2)}, rl.Vector2{f32(20), f32(200)}, rl.WHITE)
    rl.DrawRectangleV(rl.Vector2{f32(posX), f32(screen_height)/2 - size.y/2}, size, rl.WHITE)
}