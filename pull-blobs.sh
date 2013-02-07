#!/bin/bash
#
# By Jameson Williams, modifications by Ben Weigand
# 
blob_list_file=$ANDROID_BUILD_TOP/device/lge/mako/proprietary-blobs.txt

# If we've got one, use the local version instead.
if [ -f ./proprietary-blobs.txt ]; then
    blob_list_file=./proprietary-blobs.txt
fi

tmp_dir=$(mktemp -d)
 
function die_on_err() {
    $@  
    if [ $? -ne 0 ]; then
        echo "Failure at $@"

        [ -d $tmp_dir ] && rm -r -f $tmp_dir

        exit 1
    fi 
}
 
while read item; do
    [ -z "$item" ] && continue # skip blank lines
    [[ "$item" == \#* ]] && continue # skip comments
 
    mkdir -p ${tmp_dir}$(dirname $item)
    die_on_err adb pull $item ${tmp_dir}$item
done < $blob_list_file

rsync -av --delete $tmp_dir/system/ proprietary/

exit 0
