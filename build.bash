#!/bin/bash -e


function adjust_captions {
    # BSD-style
    #find $LOCAL/_site/photos -name "index.html" -exec sed -i '' 's:"caption">.._:"caption">:' {} +
    #find $LOCAL/_site/photos -name "index.html" -exec sed -i '' 's:.jpg</p>:</p>:' {} +

    # GNU-style
    find $LOCAL/_site/photos -name "index.html" -exec sed -i 's:"caption">.._:"caption">:' {} +
    find $LOCAL/_site/photos -name "index.html" -exec sed -i 's:.jpg</p>:</p>:' {} +

}


function split_all {
    #
    # Normally, jekyll-gallery-generator creates one index.html page per gallery.
    # We use a hack to create two html pages per gallery: index.html and slideshow.html
    #

    rm _site/photos/index.html
    OIFS="$IFS"
    IFS=$'\n'
    for file in $(find $LOCAL/_site/photos -name "index.html")
    do
        cd $(dirname $file)
        echo $PWD
        awk '{print >out}; /<!--/{out="slideshow.html"}' out="/dev/null" "index.html"
    done
    IFS="$OIFS"
}


LOCAL="/Volumes/Data/Documents/workspace/web/photogalleries/naturalist"
REMOTE="photogalleries/naturalist"

SRC='/Volumes/Data/Pictures'
DST='photos'

source /Volumes/Data/Documents/workspace/web/functions


cd $LOCAL


setup
ln -s $SRC/pictures-1/* $DST
ln -s $SRC/pictures-2/* $DST
build $LOCAL $REMOTE
adjust_captions
split_all


if [ ${PUSH:-1} -ne 0 ]; then
    push $LOCAL $REMOTE
fi


