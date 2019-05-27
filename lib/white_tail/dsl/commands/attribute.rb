module WhiteTail
  module DSL
    module Commands
      class Attribute
        include Helpers
        include ElementsLocator

        ALLOWED_OPTIONS = []

        attr_reader :attribute_component, :element_name, :locator, :attribute, :options

        def initialize(attribute_component, element_name, locator, attribute, **options)
          @attribute_component = attribute_component
          @element_name = element_name
          @locator = locator
          @attribute = attribute
          @options = options

          validate_options(ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          element = find_elements(execution_scope)
          value = element.first&.[](attribute)

          raise "Attribute not found" if value.nil? && options[:required]

          attribute_component.new(value)
        end
      end
    end
  end
end
