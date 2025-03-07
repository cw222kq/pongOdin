package main

import rl "vendor:raylib"
import strings "core:strings"
Sound_Manager :: struct {
    sounds: map[string]rl.Sound,
}

create_sound_manager :: proc() -> Sound_Manager {
    return Sound_Manager {
        sounds = make(map[string]rl.Sound),
    }
}

load_sound :: proc(manager: ^Sound_Manager,  name: string, path: string) {
    manager.sounds[name] = rl.LoadSound(strings.clone_to_cstring(path))
}

play_sound :: proc(manager: ^Sound_Manager, name: string) {
    if sound, ok := manager.sounds[name]; ok {
        rl.PlaySound(sound)
    }
}

unload_sound :: proc(manager: ^Sound_Manager) {
    for _, sound in manager.sounds {
        rl.UnloadSound(sound)
    }
    delete(manager.sounds)
}

