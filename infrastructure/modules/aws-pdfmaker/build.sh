#!/bin/bash

# Use this bash script to (re)package pdfmaker function and fonts
# after updating them.

rm -f pdfmaker.zip

# create pdfmaker.zip
zip -9 --recurse-paths pdfmaker.zip fonts pdfmaker.js

md5sum pdfmaker.zip