#!/bin/bash

IFS=$'\n';


WORKING_DIR="/tmp"

REQUIRED_MIMES=("gif" "png" "jpg" "jpeg" "flv" "mp3")

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



    if [ $(contains "${REQUIRED_MIMES[@]}" "$mime") == "y" ]; then

      cp "$dirname/${Array[0]}" "$WORKING_DIR/cache-reverse/feed/${Array[1]}.$mime"

    fi



#    echo "${Array[@]}"
#    echo "${Array[1]}"
#    echo "${ArrayMime[@]}"
#    echo "${ArrayMime[0]}"


    done

}


if [ ! -d $WORKING_DIR/cache-reverse/feed ]; then
  mkdir -p $WORKING_DIR/cache-reverse/feed
fi


for i in Cache Media\ Cache; do

   if [ ! -d $WORKING_DIR/cache-reverse/$i ]; then
      mkdir -p $WORKING_DIR/cache-reverse/
      ln -s ~/.cache/chromium/Default/$i/ $WORKING_DIR/cache-reverse/$i
      newhash  $WORKING_DIR/cache-reverse/$i
   else
      newhash  $WORKING_DIR/cache-reverse/$i
   fi
done

exit 0;
