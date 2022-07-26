.DEFAULT: help

# HELP
# ----
help:
	@echo "Available targets/commands:"
	@echo "========================================================="
	@echo "package"
	@echo "    Packages pdfmaker.js and font files into pdfmaker.zip"
	@echo "    that can be uploaded to lambda function."
	@echo "clean"
	@echo "    Removes any previously packaged pdfmaker.zip file"
	@echo "---------------------------------------------------------"
	@echo ""


# Package lambda function
package:
	zip -9 pdfmaker.zip --recurse-paths pdfmaker.zip fonts pdfmaker.js
	md5sum pdfmaker.zip

clean:
	rm -f pdfmaker.zip
