#!/bin/bash
#
# NOTE: You need to `brew install gnu-sed` on Mac
# 
# by @codecolorist
# http://github.com/chichou
# 
# fix some compilation error of headers generated by class-dump
#
# usage: fixheader.sh DIRECTORY


usage() {
  echo "Fix compilation error of headers generated by class-dump"
  echo
  echo "Usage: $0 {PATH}"
}

if [ ! -d "$1" ]; then
  echo "Invalid path $1"
  usage
  exit 1
fi

for filename in $1/*.h; do
  if [ 'Darwin' == $(uname) ]; then
    sed="gsed"
  else
    sed="sed"
  fi

  # remove "- (void).cxx_destruct;"
  # replace "CDUnknownBlockType" with "id"
  # fix missing NSObject.h

  $sed -i -e '/- (void).cxx_destruct;/d' -e "s/\bCDUnknownBlockType\b/id/g" \
    -e "s/#import \"NSObject.h\"/#import <Foundation\/NSObject.h>/" $flag $filename

  # remove -Protocol suffix
  if [[ $filename == *"-Protocol.h" ]]; then
    echo "rename $filename"
    mv "$filename" "${filename%-Protocol.h}.h";
  fi

done;