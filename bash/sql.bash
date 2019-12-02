vipsql() {
    nvim -c 'setlocal buftype=nofile | setlocal ft=sql | VipsqlOpenSession '"$*"
}
