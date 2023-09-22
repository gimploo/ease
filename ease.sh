#!/bin/bash

HELPER_PROMPT="
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

"

function setup_symlink_for_win {

    if [ "$USER" == "simploo" ]
    then
        echo "[!] OWNER RECOGNIZED!"
        cmd.exe /c mklink /j lib E:\\dev\\lib
    fi
}

function print_helper_prompt {
    printf %s "$HELPER_PROMPT" 
}

function download_forge {

    if [ "$1" == "unix" ] 
    then
        wget https://raw.githubusercontent.com/gimploo/forge/main/build.sh 2> /dev/null 
        chmod +x build.sh
        return 0
    elif [ "$1" == "win64" ] 
    then
        wget https://raw.githubusercontent.com/gimploo/forge/main/build.bat 2> /dev/null 
        return 0
    fi
}

function main {

    if [ "$1" == "--init" ]
    then
        if [ ! -d "$2" ] 
        then
            mkdir $2 
            mkdir $2/src && cd $2
            create_main_c_file $2
            if [ "$3" == "--target" ]
            then
                download_forge $4
            else
                download_forge "win64"
                setup_symlink_for_win
            fi
            cd - > /dev/null
        else
            echo "[EASE] Folder \`$2\` exist"
            return 0
        fi
    elif [ "$1" == "--kill" ]
    then
        if [ -d "$2" ]
        then
            cd $2 &&
            if [ -f "build.sh" ]
            then
                ./build.sh deepclean || { echo [EASE] something went wrong; return 1; }
            elif [ -f "build.bat" ]
            then
                if [ -L "lib" ]
                then
                    rm lib && echo [EASE] SYMLINK FOUND, SAFELY REMOVED!
                fi
                cmd.exe /c build.bat deepclean || { echo [EASE] something went wrong; return 1; }
            else
                echo "[EASE] Build script not found"
                return 0
            fi
            cd - > /dev/null
            rm -rf $2
            echo "[EASE] Project \`$2\` successfully deleted"
            return 0
        else
            echo "[EASE] Project \`$2\` doesnot exist" 
            return 0
        fi
    else
        print_helper_prompt
        return 00
    fi

    echo "[EASE] Project \`$2\` successfully created"
    return 0
}

function create_main_c_file {
echo -e "#define WINDOW_SDL
#include <poglib/application.h>

typedef struct content_t {

    const char *text;

} content_t ;

void $1_init(application_t *app) 
{
    content_t c = {
        .text = \"Hello world\\\n\" 
    };

    application_pass_content(app, &c);
}

void $1_update(application_t *app) 
{
    window_t *win = application_get_window(app);
    content_t *c = application_get_content(app);

    window_update_user_input(win);
}

void $1_render(application_t *app) 
{
    window_t *win = application_get_window(app);
    content_t *c = application_get_content(app);
}

void $1_destroy(application_t *app) 
{
    window_t *win = application_get_window(app);
    content_t *c = application_get_content(app);
}

int main(void)
{
    application_t app = {
        .window = {
            .title              = \"$1\",
            .width              = 1080,
            .height             = 920,
            .aspect_ratio       = 1080.f / 920.f,
            .fps_limit          = 60,
            .background_color   = COLOR_GREEN
        },   
        .content = {
            .size = sizeof(content_t )
        },
        .init       = $1_init,
        .update     = $1_update,
        .render     = $1_render,
        .destroy    = $1_destroy
    };

    application_run(&app);

    return 0;
}
" > src/main.c
}



main $1 $2 $3 $4
