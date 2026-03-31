package stats

import "core:fmt"
import "core:flags"
import "core:os"

Options :: struct{
    _: string `args:"pos=0"`,
    file: ^os.File `args:"pos=1,required,file=r" usage:"Input file."`,
    c, category: int `usage:"Print a specific category."`,
    f, failed: bool `usage:"Show failed exercises."`
    // overflow: [dynamic]string
}

parse_console :: proc(options: ^Options) -> bool {
    // Parse input arguments:
    error := flags.parse(options, os.args)

    switch err in error {
    case flags.Parse_Error:
        fmt.print("error: failed to parse.")

        switch err.reason {
        case .Extra_Positional:
            fmt.println(" Invalid argument.")
        case .Missing_Flag:
            fmt.println(" Invalid option.")
        case .Bad_Value:
            fmt.println(" Invalid value.")
        case .No_Value, .Unsupported_Type:
            fmt.println(" Value expected.")
        }

    case flags.Open_File_Error:
        fmt.printf("error: failed to open file `%s`.", err.filename)

        // Print more descriptive error info
        if (err.errno == .Not_Exist) {
            fmt.println(" Does not exist.")
        } else {
            fmt.println(" Invalid file.")
        }
    case flags.Help_Request:
        print_help()
    case flags.Validation_Error:
        fmt.println("error: failed to validate input.", err.message)
    case:
        return verify(options)
    }
    
    return false 
}

// Input verification
verify :: proc(options: ^Options) -> bool {
    // Incorrect file extension
    _, extension := os.split_filename(os.name(options.file))
    if extension != "stat" {
        fmt.printf("error: incorrect file extension: `.%s`.\n", extension)
        return false
    }

    return true
}

print_help :: proc() {
    fmt.println("usage: stats <file> [-c:int][-f:bool]")

    fmt.printf("options: \n\tc, category\tspecify a category to print.\n\tf, failed\tshow failed exercises.\n")

    fmt.printf("output:\n")
    fmt.printf("└── ?")
    fmt.printf(" AAA%% - B.BB [CCC / DDD (EEE)]: FF - <name>\n")

    fmt.printf("legend:\n")
    fmt.printf("\t?\t\tsymbol: * = finished, ^ = linked\n")
    fmt.printf("\tAAA\t\tcompletion percentage\n")
    fmt.printf("\tB.BB\t\taverage score\n")
    fmt.printf("\tCCC\t\tfinished exercises\n")
    fmt.printf("\tDDD\t\ttotal exercises\n")
    fmt.printf("\tEEE\t\ttotal tries\n")
    fmt.printf("\tFF\t\tindex\n")
}
