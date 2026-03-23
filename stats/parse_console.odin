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
        return true 
    }
    
    return false 
}

print_help :: proc() {
    fmt.println("usage: stats <file> [-q:int][-f:bool]")
    fmt.printf("options: \n\tc, category\tSpecify a category to print.\n\tf, failed\tShow failed exercises.\n")
}
