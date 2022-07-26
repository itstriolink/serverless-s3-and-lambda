#!/bin/bash

rm -f pdfmaker.zip

# create pdfmaker.zip
zip -9 --recurse-paths pdfmaker.zip fonts pdfmaker.js

md5sum pdfmaker.zip
