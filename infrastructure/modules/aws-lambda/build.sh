#!/bin/bash

rm -f lambda.zip

# create pdfmaker.zip
zip -r lambda.zip src/.* *

md5sum lambda.zip
