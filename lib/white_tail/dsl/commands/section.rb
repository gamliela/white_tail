module WhiteTail
  module DSL
    module Commands
      class Section
        include Helpers
        include ElementsLocator

        ALLOWED_OPTIONS = %i[required]

        attr_reader :section_component, :element_name, :locator, :options

        def initialize(section_component, element_name, locator, **options)
          @section_component = section_component
          @element_name = element_name
          @locator = locator
          @options = options

          validate_options(ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          element = find_elements(execution_scope).first
          if element
            execution_scope = execution_scope.extend_instance(locator, 0, element.text)
            ScriptExecutor.execute_for(section_component, execution_scope)
          else
            Components::Field.new(nil)
          end
        end
      end
    end
  end
end
