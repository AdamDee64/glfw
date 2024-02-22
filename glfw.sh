export _DIR_=./bin/
if test -d $_DIR_; then continue; else mkdir -p $_DIR_; fi

export _OUT_=glfw

odin run . -out:$_DIR_$_OUT_