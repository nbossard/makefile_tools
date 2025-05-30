# Sample usage :
#
# Makefile_common_help.mk:
#	@echo "retrieving latest version of $@"
#	curl -s https://raw.githubusercontent.com/nbossard/makefile_tools/refs/heads/main/$@ -o $@
#
# include Makefile_common_help.mk


# extract from provided files list lines with double ## markers
# like :
# check_health: ## Checks programs used by makefile are available
define extract_help_lines
	$(eval @_files_to_consider := $(1))

	@awk '/^[a-zA-Z_\-\.]+:/ { \
		if (line ~ /##/) print line; \
		line=$$0; \
		next; \
	} \
	/^ *##/ { \
		line = line " " $$0; \
	} \
	END { \
		if (line ~ /##/) print line; \
	}' $(@_files_to_consider)
endef

# To colorise output of extract_help_lines
define colorise_lines
	awk 'BEGIN {FS = ":.*?## "}; { \
		printf "    \033[36m%-20s\033[0m %s\n", $$1, $$2; \
	}'
endef

.PHONY: help check_health

# Will display a list of main targets with a quick description.
help:
	@echo "Usage : make"
	@echo "$(MAKEFILE_LIST)"
	@# Extract lines with targets and their comments, then format with colors
	@# supported target names : "help:" "check_health:"  "taggage-user-mada.png:"
	$(call extract_help_lines, $(MAKEFILE_LIST))| $(call colorise_lines)
	@printf "\n"

check_health: ## Checks programs used by makefile are available
	$(call .cecho,"Checks programs used by makefile are available")
	@if command -v jq >/dev/null 2>&1; then echo "✅ jq is installed"; else echo "❌ jq is not installed"; fi
	@if command -v sed >/dev/null 2>&1; then echo "✅ sed is installed"; else echo "❌ sed is not installed"; fi
	@if command -v egrep >/dev/null 2>&1; then echo "✅ egrep is installed"; else echo "❌ egrep is not installed"; fi
	@if command -v curl >/dev/null 2>&1; then echo "✅ curl is installed"; else echo "❌ curl is not installed"; fi
	@if command -v cat >/dev/null 2>&1; then echo "✅ cat is installed"; else echo "❌ cat is not installed"; fi
	@if command -v docker-compose >/dev/null 2>&1; then echo "✅ docker-compose is installed"; else echo "❌ docker-compose is not installed"; fi
	$(call .cechodark,"🏁 Finished")

# Returns true if the stem is a non-empty
# environment variable, or else raises an error.
guard-%:
	@#$(or ${$*}, $(error $* is not set))
