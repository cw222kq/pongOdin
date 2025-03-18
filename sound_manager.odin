package main

import rl "vendor:raylib"
import strings "core:strings"
import fmt "core:fmt"

Sound_Manager :: struct {
    sounds: map[string]rl.Sound,
}

create_sound_manager :: proc() -> Sound_Manager {
    return Sound_Manager {
        sounds = make(map[string]rl.Sound),
    }
}

load_sound :: proc(manager: ^Sound_Manager,  name: string, path: string) -> (ok: bool) {
    if manager == nil {
        fmt.println("Error: Attempting to load sound into nil sound manager")
        return false
    }
    if len(path) == 0 {
        fmt.println("Error: Empty sound file path")
        return false
    }
    
    sound := rl.LoadSound(strings.clone_to_cstring(path))
    if sound.frameCount == 0 {
        fmt.println("Failed to load sound:", path)
        fmt.println("Please check if the file exists and is a valid sound format")
        return false
    }
    manager.sounds[name] = sound
    return true
}

play_sound :: proc(manager: ^Sound_Manager, name: string) -> (ok: bool) {
    if manager == nil {
        fmt.println("Error: Attempting to play sound with nil sound manager")
        return false
    }
    if sound, ok := manager.sounds[name]; ok {
        rl.PlaySound(sound)
        return true
    }
    fmt.println("Error:Sound not found in sound manager:", name)
    return false
}

unload_sound :: proc(manager: ^Sound_Manager) {
    if manager == nil {
        fmt.println("Error: Attempting to unload sound from nil sound manager")
        return
    }
    for _, sound in manager.sounds {
        rl.UnloadSound(sound)
        fmt.println("Unloaded sound:", sound)
    }
    delete(manager.sounds)
}

