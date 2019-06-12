* Rename commands:
- assignment -> assign
- validation -> wait_for

* Add param validations on all command classes (e.g. assignment)

* make extraction of `:page_class` or `:section_class` from options more generic/robust.

* multiple anonymous classes are not supported (e.g. multiple "within" command in same section) might conflict. we need a separate class to each one.

* use Helpers.with_element where possible

__Can wait until we have more commands/experience__

* remove duplications in list commands in script_builder.rb

* remove duplications in command files

* too many node classes: text and attribute can be just field, section can be script or even record (more genereic)