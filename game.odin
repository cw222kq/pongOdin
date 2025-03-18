package main

import rl "vendor:raylib"
import "core:fmt"
import "core:strings"
import "core:math/rand"
import "core:os"

Game_State :: enum {
    MENU,
    PLAYING,
    GAME_OVER,
}

Game_State_Transition :: struct {
    from: Game_State,
    to: Game_State,
}

VALID_TRANSITIONS :: []Game_State_Transition { // TODO: LOOK THROUGH THIS AND THE TWO PROC BELOW
    {.MENU, .PLAYING},
    {.PLAYING, .GAME_OVER},
    {.GAME_OVER, .PLAYING},
}

is_valid_state_transition :: proc(from: Game_State, to: Game_State) -> bool {
    for transition in VALID_TRANSITIONS {
        if transition.from == from && transition.to == to {
            return true
        }
    }
    return false
}

change_game_state :: proc(game: ^Game, new_state: Game_State) -> (ok: bool) {
    if !is_valid_state_transition(game.state, new_state) {
        fmt.println("Error: Invalid game state transition from", game.state, "to", new_state)
        return false
    }
    game.state = new_state
    return true
}

Game :: struct {
    state: Game_State,
    ball: Ball,
    sound_manager: Sound_Manager,
    paddle_left: Paddle,
    paddle_right: Paddle,
    score_left: i32,
    score_right: i32,
}

// Constants
SCREEN_WIDTH :: 1600
SCREEN_HEIGHT :: 900
PADDLE_WIDTH :: 20
PADDLE_HEIGHT :: 200
WINNING_SCORE :: 5
BALL_INITIAL_SPEED :: 3.0
BALL_SPEED_INCREASE :: 1.4
BALL_RADIUS :: 10.0
PADDLE_SPEED :: 4.0

new_game :: proc() -> (game: Game, ok: bool) {
    ball, ball_ok := create_ball()
    if !ball_ok {
        fmt.println("Error:Failed to create ball")
        return game, false
    }

    paddle_left, paddle_left_ok := create_paddle(f32(PADDLE_HEIGHT/2), rl.BLUE)
    if !paddle_left_ok {
        fmt.println("Error:Failed to create left paddle")
        return game, false
    }
// 1480
    paddle_right, paddle_right_ok := create_paddle(f32(SCREEN_WIDTH - PADDLE_HEIGHT/2 - PADDLE_WIDTH), rl.YELLOW)
    if !paddle_right_ok {
        fmt.println("Error:Failed to create right paddle")
        return game, false
    }
    
    game = Game{
        state = .MENU,
        ball = ball,
        sound_manager = create_sound_manager(),
        paddle_left = paddle_left,
        paddle_right = paddle_right,
        score_left = 0,
        score_right = 0,
    }

    return game, true
}

start_game :: proc() -> (game: Game, ok: bool) {
    // Seed the random number generator
    rand.reset(u64(rl.GetTime() *1000))

    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Pong")
    rl.SetTargetFPS(60)
    rl.InitAudioDevice()

    game, ok = new_game()
    if !ok {
        fmt.println("Error: Failed to create new game")
        return game, false
    }

    if !load_sound(&game.sound_manager, "start", "assets/sounds/start.mp3") {
        fmt.println("Failed to load start sound")
        return game, false
    }

    if !load_sound(&game.sound_manager, "hit", "assets/sounds/hit.wav") {
        fmt.println("Failed to load hit sound")
        return game, false
    }

    if !load_sound(&game.sound_manager, "goal", "assets/sounds/goal.wav") {
        fmt.println("Failed to load goal sound")
        return game, false
    }

    if !load_sound(&game.sound_manager, "game_over", "assets/sounds/game_over.mp3") {
        fmt.println("Failed to load game over sound")
        return game, false
    }

    return game, true
}

restart_game :: proc(game: ^Game) -> (ok:bool) {
    // Create new new ball
    new_ball, ball_ok := create_ball()
    if !ball_ok {
        fmt.println("Error: Failed to create new ball")
        return false
    }

    // Create new paddles
    new_paddle_left, paddle_left_ok := create_paddle(100, rl.BLUE)
    if !paddle_left_ok {
        fmt.println("Error: Failed to create new left paddle")
        return false
    }

    new_paddle_right, paddle_right_ok := create_paddle(1480, rl.YELLOW)
    if !paddle_right_ok {
        fmt.println("Error: Failed to create new right paddle")
        return false
    }

    // Reset scores
    game.score_left = 0
    game.score_right = 0

    // Update game state
    game.ball = new_ball
    game.paddle_left = new_paddle_left
    game.paddle_right = new_paddle_right

    // Play start sound
    if !play_sound(&game.sound_manager, "start") {
        fmt.println("Failed to play start sound")
        return false
    }

    return true  
}

update_game :: proc(game: ^Game) {
    # partial switch game.state {
        case .MENU:
            if rl.IsKeyPressed(.P) {
                if change_game_state(game, .PLAYING) {
                    if !play_sound(&game.sound_manager, "start") {
                        fmt.println("Failed to play start sound")
                    }
                } else {
                    fmt.println("Error: Failed to start the game")
                    return
                }  
            }

        case .PLAYING:
            update_ball(&game.ball, &game.sound_manager)

            colliding_with_paddle(&game.ball, &game.paddle_left, &game.sound_manager)
            colliding_with_paddle(&game.ball, &game.paddle_right, &game.sound_manager)

            update_paddle(&game.paddle_left, rl.KeyboardKey.W, rl.KeyboardKey.S)
            update_paddle(&game.paddle_right, rl.KeyboardKey.UP, rl.KeyboardKey.DOWN)

            if game.ball.position.x < 0 {
                if !play_sound(&game.sound_manager, "goal") {
                    fmt.println("Error:Failed to play goal sound")
                }
                game.score_right += 1
                reset_ball(&game.ball)
            }

            if game.ball.position.x > f32(rl.GetScreenWidth()) {
                if !play_sound(&game.sound_manager, "goal") {
                    fmt.println("Error: Failed to play goal sound")
                }
                game.score_left += 1
                reset_ball(&game.ball)
            }

            if game.score_left >= WINNING_SCORE || game.score_right >= WINNING_SCORE {
                if !play_sound(&game.sound_manager, "game_over") {
                    fmt.println("Error: Failed to play game over sound")
                }
                if !change_game_state(game, .GAME_OVER) {
                    fmt.println("Error: Failed to transition to game over state")
                    return
                }
            }
        case .GAME_OVER:
            if rl.IsKeyPressed(.R) { 
                if restart_game(game) {
                    if !change_game_state(game, .PLAYING) {
                        fmt.println("Error: Failed to transition to playing state")
                        return
                    }
                } else {
                    fmt.println("Error: Failed to restart game")
                    return
                }
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
        ball.velocity.x = -ball.velocity.x * BALL_SPEED_INCREASE
        ball.velocity.y *= BALL_SPEED_INCREASE
    }
}

cleanup_game :: proc(game: ^Game) {
    if game == nil {
        fmt.println("Error: Attempting to cleanup nil game")
        return
    }

    unload_sound(&game.sound_manager)
    fmt.println("Game cleanup complete")
}
