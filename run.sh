#!/bin/bash


IFS=$'\n';

DEBUG="1"

HOME_DIR=`pwd`

WORKING_DIR="/tmp"

REQUIRED_MIMES=("gif" "png" "jpg" "jpeg" "flv" "mp3" "macromedia" "text" "gzip")

OPEN_BROWSER="0"

debug "browse feed is disabled"


function openbrowser(){



dir=$WORKING_DIR/cache-reverse/feed/;
cd $dir;
var=$(echo "var photos=["; for i in `ls . | egrep "jpg|gif|png" |  sort `; do echo '"'$dir/$i'",\n'; done; echo '""]'; );

cp $HOME_DIR/feed.html  $WORKING_DIR/cache-reverse/feed/;
echo -e $var >  $WORKING_DIR/cache-reverse/feed/photos.js;
echo ";" >> $WORKING_DIR/cache-reverse/feed/photos.js;
chromium  $WORKING_DIR/cache-reverse/feed/feed.html &



}



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
    mime=$(echo ${ArrayMime[4]} | tr '[:upper:]' '[:lower:]')

    IFS=$'\n';



    debug "mime $mime file ${Array[@]}"

    if [ $(contains "${REQUIRED_MIMES[@]}" "$mime") == "y" ]; then
      mimex=$(echo $mime | sed  's/macromedia/flv/'| sed 's/text/html/')



      if [ "$mime" == "gzip" ]; then

        FILE_NAME="$WORKING_DIR/cache-reverse/feed/${Array[1]}"
        zcat "$dirname/${Array[0]}" > $FILE_NAME
#        xmimer=$(file --mime-type $FILE_NAME | awk '{print $2}');

#        if [ "$xmimer" == "text/html" ]; then
#        html2text $FILE_NAME > $FILE_NAME.txt;
#        cat $FILE_NAME | data-freq --limit 100;
#        fi

      else
        cp "$dirname/${Array[0]}" "$WORKING_DIR/cache-reverse/feed/${Array[1]}.$mimex"
      fi


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



if [ $OPEN_BROWSER == "1" ]; then
  openbrowser
fi

debug "browse feed is disabled"

exit 0;
 
