package main

import rl "vendor:raylib"

create_ball :: proc(screen_width: i32, screen_height: i32, radius: f32) {
    rl.DrawCircleV(rl.Vector2{f32(screen_width/2), f32(screen_height/2)}, radius, rl.WHITE)
}
