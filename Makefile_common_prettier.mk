# Improve readability of makefile log execution by adding clearly visible colored section markers easily.
#
# This file is aimed to be used in multiple projects.
# You can retrieve latest version at https://github.com/nbossard/makefile_tools/Makefile_common_puml.mk
#
# Sample usage :
#
# Makefile_common_prettier.mk:
#	@echo "retrieving latest version of $@"
#	curl -s https://raw.githubusercontent.com/nbossard/makefile_tools/refs/heads/main/$@ -o $@
#
# include Makefile_common_prettier.mk
#
# Usage :
# 	$(call .cecho,"Cleaning all temporary files")

# }}}

# -------------------------- improved display ------------------
# {{{

.ECHO_COLOR_LIGHT_GREEN=\033[1;32m
.ECHO_COLOR_DARK_GREEN=\033[0;32m
.ECHO_COLOR_RED=\033[1;31m
.ECHO_COLOR_PRIMARY=$(.ECHO_COLOR_LIGHT_GREEN)
.ECHO_COLOR_SECONDARY=$(.ECHO_COLOR_DARK_GREEN)
.ECHO_COLOR_ERROR=$(.ECHO_COLOR_RED)
.NO_COLOR=\033[0m


# Function to replace @echo and display in color
.cecho = @echo "\n$(.ECHO_COLOR_PRIMARY)==> $@ : $(1)$(.NO_COLOR)"
.cechoseparator = @echo "\n\n\n$(.ECHO_COLOR_PRIMARY)================================================================================\n                                        $(1)\n ================================================================================\n\n$(.NO_COLOR)"
.cechodark = @echo "$(.ECHO_COLOR_SECONDARY)--> $(1)$(.NO_COLOR)"
# bash version without @
.cechodarkbash = echo "$(.ECHO_COLOR_SECONDARY)--> $(1)$(.NO_COLOR)"
.cechoerror = @echo "$(.ECHO_COLOR_ERROR)❌❌❌ $(1)$(.NO_COLOR)"
# bash version without @
.cechoerrorbash = echo "$(.ECHO_COLOR_ERROR)❌❌❌ $(1)$(.NO_COLOR)"



