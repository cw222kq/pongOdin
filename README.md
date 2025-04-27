# pongOdin

A classic Pong game implementation written in the Odin programming language using the Raylib library.

## Description

This project is a simple clone of the classic arcade game Pong. It features two paddles controlled by the player (or potentially AI in the future), a ball that bounces off walls and paddles, a scoring system, and basic sound effects. The game includes different states like a main menu, active gameplay, and a game over screen.

## Features

*   **Classic Pong Gameplay**: Two paddles, one ball.
*   **Two Player Controls**: Left paddle controlled by W/S, right paddle by Up/Down arrows.
*   **Scoring System**: Score increments when the opponent misses the ball. The first player to reach 5 points wins.
*   **Ball Physics**: Ball bounces off paddles and top/bottom walls. Speed increases upon hitting a paddle.
*   **Randomized Ball Start**: The ball starts in a random direction at the beginning of each round.
*   **Sound Effects**: Sounds for paddle hits, scoring goals, game start, and game over.
*   **Game States**: Includes a Menu, Playing, and Game Over state with appropriate UI and logic.
*   **State Management**: Implements a basic state transition system to ensure valid game flow.
*   **Constants for Configuration**: Game parameters like screen size, paddle speed, winning score, etc., are defined as constants for easy modification.

## Building the Project

### Prerequisites

*   Odin Compiler ([Installation Guide](https://odin-lang.org/docs/install/))
*   Raylib library (This project uses the Raylib bindings included via `vendor:raylib`)