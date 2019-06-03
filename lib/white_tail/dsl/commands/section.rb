module WhiteTail
  module DSL
    module Commands
      class Section
        ALLOWED_OPTIONS = %i[required]

        attr_reader :section_class, :script, :locator, :options

        def initialize(section_class, locator, **options)
          @section_class = section_class
          @script = Helpers.extract_script!(section_class)
          @locator = locator
          @options = options

          Helpers.validate_options(options, ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          element = Helpers.find_element(execution_scope, locator, options)
          if element
            section_node = section_class.new
            section_execution_scope = execution_scope.extend_instance(section_node, locator, 0, element.text)
            Helpers.execute_script(script, section_execution_scope)
            section_node
          else
            Nodes::Field.new(nil)
          end
        end
      end
    end
  end
end
