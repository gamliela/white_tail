module WhiteTail
  module DSL
    module Commands
      class Section
        ALLOWED_OPTIONS = %i[required]

        attr_reader :section_class, :node_name, :locator, :options

        def initialize(section_class, node_name, locator, **options)
          @section_class = section_class
          @node_name = node_name
          @locator = locator
          @options = options

          Helpers.validate_options(options, ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          element = Helpers.find_elements(execution_scope, locator, options).first
          if element
            execution_scope = execution_scope.extend_instance(locator, 0, element.text)
            ScriptExecutor.execute_for(section_class, execution_scope)
          else
            Nodes::Field.new(nil)
          end
        end
      end
    end
  end
end
