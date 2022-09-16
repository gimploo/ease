# ease
An easy one line C project setup for multi platform 
desktop development.

```bash
    ./ease.sh [options]
```

Types of options
-------------
        --init <project_name>   := creates a project with the given name
        --help                  := prints the helper prompt
        --target <platform>     := win64(default) and unix
        --kill <project_name>   := deletes the given project safely

Examples
--------
* For windows
    ```bash
        ./ease.sh --init foo
    ```
* For unix
    ```bash
        ./ease.sh --init foo --target unix
    ```
