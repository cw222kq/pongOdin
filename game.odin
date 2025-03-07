package main

import rl "vendor:raylib"
import "core:fmt"
import "core:strings"
import "core:math/rand"         // TODO: Add sounds and error handling

Game_state :: enum {
    MENU,
    PLAYING,
    GAME_OVER,
}

Game :: struct {
    state: Game_state,
    ball: Ball,
    sound_manager: Sound_Manager,
    paddle_left: Paddle,
    paddle_right: Paddle,
    score_left: i32,
    score_right: i32,
}

new_game :: proc() -> Game {
    return Game{
        state = .MENU,
        ball = create_ball(),
        sound_manager = create_sound_manager(),
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
    rl.InitAudioDevice()

    game := new_game()

    load_sound(&game.sound_manager, "start", "assets/sounds/start.mp3")
    load_sound(&game.sound_manager, "hit", "assets/sounds/hit.wav")
    load_sound(&game.sound_manager, "goal", "assets/sounds/goal.wav")
    load_sound(&game.sound_manager, "game_over", "assets/sounds/game_over.mp3")

    return game
}

update_game :: proc(game: ^Game) {
    # partial switch game.state {
        case .MENU:
            if rl.IsKeyPressed(.P) {
                game.state = .PLAYING
                play_sound(&game.sound_manager, "start")
            }

        case .PLAYING:
            update_ball(&game.ball, &game.sound_manager)

            colliding_with_paddle(&game.ball, &game.paddle_left, &game.sound_manager)
            colliding_with_paddle(&game.ball, &game.paddle_right, &game.sound_manager)

            update_paddle(&game.paddle_left, rl.KeyboardKey.W, rl.KeyboardKey.S)
            update_paddle(&game.paddle_right, rl.KeyboardKey.UP, rl.KeyboardKey.DOWN)

            if game.ball.position.x < 0 {
                play_sound(&game.sound_manager, "goal")
                game.score_right += 1
                reset_ball(&game.ball)
            }

            if game.ball.position.x > f32(rl.GetScreenWidth()) {
                play_sound(&game.sound_manager, "goal")
                game.score_left += 1
                reset_ball(&game.ball)
            }

            if game.score_left >= 5 || game.score_right >= 5 {
                play_sound(&game.sound_manager, "game_over")
                game.state = .GAME_OVER
            }
        case .GAME_OVER:
            if rl.IsKeyPressed(.R) {
                play_sound(&game.sound_manager, "start")
                game^ = new_game()
                game.state = .PLAYING
            }         
    }

    if rl.IsKeyPressed(.ESCAPE) {
        unload_sound(&game.sound_manager)
    }
}
    
draw_game :: proc(game: ^Game) {
    rl.BeginDrawing()
	rl.ClearBackground(rl.BLACK)

    # partial switch game.state {
        
        case .MENU:
            title := "PONG"
            instructions := "Press 'P' to play"
            quit_text := "Press 'ESC' to quit"

            // Calculate center positions for each text
            screen_center_x := rl.GetScreenWidth()/2
            base_y : i32 = rl.GetScreenHeight()/3
            spacing : i32 = 80

             // Title (centered, at the top)
            rl.DrawText(strings.clone_to_cstring(title),
                screen_center_x - rl.MeasureText(strings.clone_to_cstring(title), 100)/2,
                base_y,
                100,
                rl.WHITE)

            // Play instruction
            rl.DrawText(strings.clone_to_cstring(instructions),
                screen_center_x - rl.MeasureText(strings.clone_to_cstring(instructions), 40)/2,
                base_y + spacing * 2,
                40,
                rl.WHITE)

            // Quit instruction
            rl.DrawText(strings.clone_to_cstring(quit_text),
                screen_center_x - rl.MeasureText(strings.clone_to_cstring(quit_text), 40)/2,
                base_y + spacing * 3,
                40,
                rl.WHITE)

        case .PLAYING:
            left_score := fmt.tprintf("%d", game.score_left)
            right_score := fmt.tprintf("%d", game.score_right)

            rl.DrawText(strings.clone_to_cstring(left_score), 
                rl.GetScreenWidth()/2 - 120, 
                50, 
                100, 
                rl.BLUE)
            rl.DrawText(strings.clone_to_cstring("-"), 
                rl.GetScreenWidth()/2 - 25, 
                50, 
                100, 
                rl.WHITE)
            rl.DrawText(strings.clone_to_cstring(right_score), 
                rl.GetScreenWidth()/2 + 60, 
                50, 
                100, 
                rl.YELLOW)

            draw_ball(game.ball) 
            draw_paddle(game.paddle_left)
            draw_paddle(game.paddle_right)
        
        case .GAME_OVER:
            winner_color := game.score_left > game.score_right ? rl.BLUE : rl.YELLOW
            winner_name := game.score_left > game.score_right ? "BLUE" : "YELLOW"
            winning_score := max(game.score_left, game.score_right)
            winner_text := fmt.tprintf("%s PLAYER WINS!!!", winner_name)
            score_text := fmt.tprintf("SCORE: %d", winning_score)
            game_over_text := "Game Over"
            play_again_text := "Press 'R' to play again"
            quit_text := "Press 'ESC' to quit"

            // Calculate center positions for each text
            screen_center_x := rl.GetScreenWidth()/2
            base_y : i32 = rl.GetScreenHeight()/3
            spacing : i32 = 80

            // Game Over (centered, at the top)
            rl.DrawText(strings.clone_to_cstring(game_over_text),
                screen_center_x - rl.MeasureText(strings.clone_to_cstring(game_over_text), 100)/2,
                base_y,
                100,
                rl.WHITE)

            // Winner announcement
            rl.DrawText(strings.clone_to_cstring(winner_text),
                screen_center_x - rl.MeasureText(strings.clone_to_cstring(winner_text), 60)/2,
                base_y + spacing * 2,
                60,
                winner_color)

            // Score
            rl.DrawText(strings.clone_to_cstring(score_text),
                screen_center_x - rl.MeasureText(strings.clone_to_cstring(score_text), 100)/2,
                base_y + spacing * 3,
                100,
                winner_color)

            // Play again instruction
            rl.DrawText(strings.clone_to_cstring(play_again_text),
                screen_center_x - rl.MeasureText(strings.clone_to_cstring(play_again_text), 40)/2,
                base_y + spacing * 5,
                40,
                rl.WHITE)

            // Quit instruction
            rl.DrawText(strings.clone_to_cstring(quit_text),
                screen_center_x - rl.MeasureText(strings.clone_to_cstring(quit_text), 40)/2,
                base_y + spacing * 6,
                40,
                rl.WHITE)
    }
        
    rl.EndDrawing()
}

colliding_with_paddle :: proc(ball: ^Ball, paddle: ^Paddle, sound_manager: ^Sound_Manager) {
    paddle_area := rl.Rectangle{
        x = paddle.position.x,
        y = paddle.position.y,
        width = paddle.size.x,
        height = paddle.size.y,
    }

    if rl.CheckCollisionCircleRec(ball.position, ball.radius, paddle_area) {
        play_sound(sound_manager, "hit")
        ball.velocity.x = -ball.velocity.x * 1.4
        ball.velocity.y *= 1.4
    }
}
