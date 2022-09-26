#!/usr/bin/env bash

download_asset() {
  local url="$1"
  local filename="assets/${url##*/}"
  if [ "$2" == "--nocomment" ]; then
    local comment=""
  else
    local comment="/* downloaded from ${url} using bin/download_assets.sh script $(date -uI) */"
  fi
  (
    echo "$comment" && curl -L "$url"
  ) > "$filename"
}

download_asset "https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" &&\
download_asset "https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css.map" --nocomment &&\
download_asset "https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js" &&\
download_asset "https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js.map" --nocomment &&\
download_asset "https://cdn.jsdelivr.net/npm/jquery@3.6.1/dist/jquery.min.js" &&\
echo OK
