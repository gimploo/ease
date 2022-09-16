# ease
An easy one line C project setup for multi platform desktop development

 Usage: ./ease [options]
    Initialize a C project for both windows and unix
    Types of options
    -------------
        --init <project_name>   := creates a project with the given name
        --help                  := prints the helper prompt
        --target <platform>     := win64(default) and unix
        --kill <project_name>   := deletes the given project safely
    Examples
    --------
        * For windows
            ease --init foo
        * For unix
            ease --init foo --target unix
