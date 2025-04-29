# pongOdin

A classic Pong game implementation written in the Odin programming language using the Raylib library.

## Key Features

*   Classic 2-player Pong gameplay.
*   Scoring system (first to 5 points wins).
*   Ball color indicates direction (matches the target player's paddle color).
*   Ball speed increases on paddle hits.
*   Randomized ball direction on start/reset.
*   Menu, Playing, and Game Over states.
*   Sound effects for key events.

## Prerequisites

*   **Odin Compiler**: [Installation Guide](https://odin-lang.org/docs/install/)
*   **Raylib**: Included via `vendor:raylib`. Ensure Raylib system libraries are installed if required by your OS.

## Getting Started

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/cw222kq/pongOdin.git
    cd pongOdin 
    ```

2.  **Run the Game:**
    Navigate to the project directory (if you aren't already there) and run:
    ```bash
    odin run .
    ```

## Controls

*   **Start Game**: `P` (from menu)
*   **Left Paddle**: `W` (up) / `S` (down)
*   **Right Paddle**: `Up Arrow` (up) / `Down Arrow` (down)
*   **Restart Game**: `R` (on Game Over screen)
*   **Quit**: `ESC`