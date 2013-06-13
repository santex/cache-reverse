cache-reverse
=============

cache-reverse is code which revers engineers your browser cache in ~/.cache and creates a feed from it

to customise the script you can specify


```

DEBUG="1"

show overhead STDOUT default "1" to check if mime's are matched ok


```

```

HOME_DIR=`pwd`

this directory

```

```

WORKING_DIR="/tmp"

that is where the output will be created

```


```

REQUIRED_MIMES=("gif" "png" "jpg" "jpeg" "flv" "mp3")

the mime types you need


```


```

OPEN_BROWSER="0"

if set to "1" chromeium opens a html file showing extracted images


```


cheers have fun
$ bash run.sh
