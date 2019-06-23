* add sleep between actions.

* add logger. indented. should display node path, node name, locator result (how many elements were found).

* better error handling. return node path and name, where error has been found!

* allow select values from forms.

* multiple anonymous classes are not supported (e.g. multiple "within" command in same section) might conflict. we need a separate class to each one.

__Can wait until we have more commands/experience__

* Revisit param validations on all command classes (e.g. assign)

* remove duplications in list commands in script_builder.rb

* too many node classes: text and attribute can be just field, section can be script or even record (more genereic)

* remove duplications in commands code: for example `open` can call `visit` internally, once the url is resolved

__Roadmap__

* Proxy support.

* Error recovery (re-run).