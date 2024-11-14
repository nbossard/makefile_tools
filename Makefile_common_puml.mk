#
# This functions are aimed to extract lines starting by :
# // puml:
# And generate a valid plantuml source files with them.
# So that we can mix source code and plantuml activity diagram.
#
# This file is aimed to be used in multiple projects.
# You can retrieve latest version at https://github.com/nbossard/makefile_tools/Makefile_common_puml.mk
#
# Sample usage :
#
# Makefile_common_puml.mk:
#	@echo "retrieving latest version of $@"
#	curl -s https://raw.githubusercontent.com/nbossard/makefile_tools/refs/heads/main/$@ -o $@
#
# include Makefile_common_puml.mk

# taggageuser/taggage.png: taggageuser/taggage.go ## generate PNG diagram from source annotations
# 	$(call puml_extract_lines,$<,taggageuser/tmp/taggage_raw.puml)
# 	$(call puml_reorder_content,taggageuser/tmp/taggage_raw.puml,taggageuser/tmp/taggage_reordered.puml)
# 	$(call puml_add_wrapper,taggageuser/tmp/taggage_reordered.puml,taggageuser/taggage.puml)
# 	plantuml taggageuser/taggage.puml -tpng



# private function
define puml_reorder_content
	$(eval @_source_file := $(1))
	$(eval @_target_file := $(2))
	@echo "Re-ordering content. (to put procedures first)"
	@awk '/^!procedure/{p=1} p; /^!endprocedure/{p=0}' $(@_source_file) > $(@_target_file)
	@awk '/^!procedure/{in_procedure=1} /^!endprocedure/{in_procedure=0; next} !in_procedure' $(@_source_file) >> $(@_target_file)
endef

# private function
define puml_extract_lines
	$(eval @_source_file := $(1))
	$(eval @_target_file := $(2))
	@echo "Extraction des lignes commençant par des tabulations et contenant // puml:"
	@grep -E '^\t*// puml.?:' $(@_source_file) | sed 's/^.*\/\/ puml: //' > $(@_target_file)
endef

# optional parameter 3 : title on top of diagram
define puml_add_wrapper
	$(eval @_source_file := $(1))
	$(eval @_target_file := $(2))
	$(eval @_title := $(3))
	@echo "Adding wrappers."
	@echo "@startuml" > $(@_target_file)
	@echo "' ⚠️ ⚠️ ⚠️ DO NOT EDIT, generated from go source code, see makefile." >> $(@_target_file)
	@if [ ! -z "$(@_title)" ]; then echo "title $(@_title)" >> $(@_target_file); fi
	@echo "start" >> $(@_target_file)
	@cat $(@_source_file) >> $(@_target_file)
	@echo "stop" >> $(@_target_file)
	@echo "@enduml" >> $(@_target_file)
endef


