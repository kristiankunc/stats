package stats

import "core:fmt"
import "core:os"
import "core:strings"
//import "core:sys/linux"
//import "core:sys/darwin"

print_all :: proc(categories: [dynamic]Category) {
    fmt.printf("[% 4i / % 4i (% 3i) = % 5.2f %%]:  0 %s - %1.2f / %i\n",
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

    for subcategory in category.subcategories {
        // 'print_subcategory' returns a boolean for early break
        if print_subcategory(subcategory) {
            break
        }
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

print_subcategory :: proc(subcategory: Subcategory) -> bool {
    // Don't print empty subcategories, return true for early break
    if subcategory.name == "" {
        return true
    }

    if subcategory.is_copy {
        //fmt.printf("\bl")
    }

    fmt.printf("[%03i/%03i] %s - %1.2f\n",
        subcategory.total_tries,
        subcategory.total_exercises,
        subcategory.name,
        subcategory.total_score / f32(subcategory.total_exercises),
    )
    return false
}
