#!/bin/bash

IFS=$'\n';

DEBUG="0"

WORKING_DIR="/tmp"

REQUIRED_MIMES=("gif" "png" "jpg" "jpeg" "flv" "mp3" "macromedia" "text" "data" "txt" "html" "text")

function contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "y"
            return 0
        fi
    }
    echo "n"
    return 1
}



lc(){
    case "$1" in
        [A-Z])
        n=$(printf "%d" "'$1")
        n=$((n+32))
        printf \\$(printf "%o" $n)
    esac
}

function debug(){

        if [ "$DEBUG" == "1" ]; then
          echo $1;

        fi


}

function newhash () {

    local dirname=$1

    cd $dirname;

    echo $dirname;

    x=$(file $(ls ) | egrep  -i "data|image|audio|png|jpeg|gif");


    for f in  $x; do


    IFS=$'\n';

    IN=$(echo $f | tr "[]{}/, " "_");

    arr=$(echo $IN | tr ":" "\n")

    set -- "$IN"
    IFS=":"; declare -a Array=($*)
    IN2="${Array[1]}"
    set -- "$IN2"
    IFS="_"; declare -a ArrayMime=($*)
    mime=$(echo ${ArrayMime[1]} | tr '[:upper:]' '[:lower:]')

    IFS=$'\n';



    debug "mime $mime file ${Array[@]}"

    if [ $(contains "${REQUIRED_MIMES[@]}" "$mime") == "y" ]; then
      mimex=$(echo $mime | sed  's/macromedia/flv/'| sed 's/text/html/')
      cp "$dirname/${Array[0]}" "$WORKING_DIR/cache-reverse/feed/${Array[1]}.$mimex"


    fi



    done

}


if [ ! -d $WORKING_DIR/cache-reverse/feed ]; then
  debug "making dir  $WORKING_DIR/cache-reverse/feed"
  mkdir -p $WORKING_DIR/cache-reverse/feed
  debug "created $WORKING_DIR/cache-reverse/feed"
fi


for i in Cache Media\ Cache; do

   if [ ! -d $WORKING_DIR/cache-reverse/$i ]; then
      mkdir -p $WORKING_DIR/cache-reverse/
      ln -s ~/.cache/chromium/Default/$i/ $WORKING_DIR/cache-reverse/$i
      newhash  $WORKING_DIR/cache-reverse/$i
      debug "checked  $WORKING_DIR/cache-reverse/$i"
   else
      newhash  $WORKING_DIR/cache-reverse/$i
      debug "checked  $WORKING_DIR/cache-reverse/$i"
   fi
done

exit 0;
