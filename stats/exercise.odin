package stats 

import "core:fmt"
import "core:strings"
import "core:strconv"

get_exercise :: proc(line: string) -> (Exercise, bool) {
    exercise: Exercise
    tokens := strings.split(line, " ")

    index, ok := strconv.parse_uint(tokens[0])
    score_ok, tries_ok: bool
    if ok {
        exercise.score, score_ok = get_score(line)
        exercise.tries, tries_ok = get_tries(line)
        return exercise, score_ok && tries_ok
    }

    return exercise, false
}

get_score :: proc(line: string) -> (f32, bool) {
    tokens := strings.split(line, " ")

    score, ok := strconv.parse_f32(tokens[len(tokens) - 1])
    if !ok {
        return 0, false
    }

    if score > 1 {
        return 0, false
    }

    return score, true
}

get_tries :: proc(line: string) -> (u8, bool) {
    tokens := strings.split(line, " ")
    return u8(len(tokens) - 1), true
}
