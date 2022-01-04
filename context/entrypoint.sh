#!/bin/bash -e
make help | cut -d ' ' -f 2- | grep test_ | xargs -n 1 -I FOOBAR find . -type f -name FOOBAR -exec '{}' \;
