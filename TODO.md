* add within_window, within_element helper methods. use `ensure` to ensure the window is closed on errors.

* in `navigaion.rb`, try to replace `open :result_link` with `click`

* multiple anonymous classes are not supported (e.g. multiple "within" command in same section) might conflict. we need a separate class to each one.

__Can wait until we have more commands/experience__

* replace Nodes::Field.new(nil) with Nodes::NIL

* Revisit param validations on all command classes (e.g. assign)

* remove duplications in list commands in script_builder.rb

* too many node classes: text and attribute can be just field, section can be script or even record (more genereic)

* remove duplications in commands code: for example `open` can call `visit` internally, once the url is resolved
