module WhiteTail
  module DSL
    module Commands
      class Text
        include Helpers
        include ElementsLocator

        ALLOWED_OPTIONS = %i[required multiple]

        attr_reader :text_component, :element_name, :locator, :options

        def initialize(text_component, element_name, locator, **options)
          @text_component = text_component
          @element_name = element_name
          @locator = locator
          @options = options

          validate_options(ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          elements = find_elements(execution_scope)
          if elements.any?
            value = elements.map(&:text).join(' ')
          else
            value = nil
          end
          text_component.new(value)
        end
      end
    end
  end
end
