package stats

import "core:fmt"
import "core:os"
import "core:strings"

print_all :: proc(categories: [dynamic]Category) {
    fmt.printf("[% 4i / % 4i (% 3i) = % 5.2f %%]: %s - %1.2f / %i\n",
        variables[VARIABLES.FINISHED],
        variables[VARIABLES.TOTAL],
        variables[VARIABLES.TRIES],
        f32(variables[VARIABLES.FINISHED]) / f32(variables[VARIABLES.TOTAL]) * 100,
        os.args[1],
        f32(variables[VARIABLES.TOTAL_SCORE]) / f32(variables[VARIABLES.BEGAN]) / 100,
        variables[VARIABLES.BEGAN],
    )

    i := 0
    for category in categories {
        if i == len(categories) - 1 {
            fmt.printf("└──  ")
        } else {
            fmt.printf("├──  ")
        }

        print_category(category)

        i += 1
    }
}

print_single :: proc(category: Category) {
    // Print the category like a TOTAL
    percentage: f32
    if category.total_exercises == 0 {
        percentage = 100
    } else {
        percentage = f32(category.finished_exercises) / f32(category.total_exercises) * 100
    }

    average_score: f32
    if category.began_exercises == 0 {
        average_score = 0
    } else {
        average_score = category.total_score / f32(category.began_exercises)
    }

    fmt.printf("[% 4i / % 4i (% 3i) = % 5.2f %%]: % 2i - %s - %1.2f / %i\n",
        category.finished_exercises,
        category.total_exercises,
        category.total_tries,
        percentage,
        category.index,
        category.name,
        average_score,
        category.began_exercises
    )

    subcategory_count := count_subcategories(category.subcategories)
    for i := 0; i < subcategory_count; i += 1 {
        if i == subcategory_count - 1 {
            fmt.printf("\r└──  ")
        } else {
            fmt.printf("\r├──  ")
        }

        // 'print_subcategory' returns a boolean for early break
        print_subcategory(category.subcategories[i])
    }
}

print_category :: proc(category: Category) {
    // Get completion percentage
    percentage: f32
    if category.total_exercises == 0 {
        //fmt.println(category.name)
        percentage = 100
    } else {
        percentage = f32(category.finished_exercises) / f32(category.total_exercises) * 100
    }

    // Print star for finished exercises
    if percentage == 100 && u16(category.total_score) == category.total_exercises { fmt.printf("\b*") }

    // Print '>' to show that the category contains a link
    if category.contains_copy { fmt.printf("\b^") }

    // Get average score
    average_score: f32
    if category.began_exercises == 0 {
        average_score = 0
    } else {
        average_score = category.total_score / f32(category.began_exercises)
    }

    // Print
    fmt.printf("% 4.0f%% - % 0.2f [% 3i / % 3i (% 3i)]: % 2i - %s\n",
        percentage,
        average_score,
        category.finished_exercises,
        category.total_exercises,
        category.total_tries,
        category.index,
        category.name,
    )
}

print_subcategory :: proc(subcategory: Subcategory) {
    if subcategory.is_copy {
        //fmt.printf("\bl")
    }

    percentage: f32
    if subcategory.total_exercises == 0 {
        percentage = 100
    } else {
        percentage = f32(subcategory.finished_exercises) / f32(subcategory.total_exercises) * 100
    }

    average_score: f32

    fmt.printf("% 4.0f%% - % 0.2f [% 3i / % 3i (% 3i)]: % 0.2f - %s\n",
        percentage,
        average_score,
        subcategory.finished_exercises,
        subcategory.total_exercises,
        subcategory.total_tries,
        subcategory.index,
        subcategory.name,
    )
}

count_subcategories :: proc(subcategories: [64]Subcategory) -> int {
    i := 0
    for subcategory in subcategories {
        if subcategory.name == "" {
            return i
        }
        i += 1
    }
    return 64
}
