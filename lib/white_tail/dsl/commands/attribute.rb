module WhiteTail
  module DSL
    module Commands
      class Attribute
        include Helpers
        include ElementsLocator

        ALLOWED_OPTIONS = []

        attr_reader :attribute_component, :node_name, :locator, :attribute, :options

        def initialize(attribute_component, node_name, locator, attribute, **options)
          @attribute_component = attribute_component
          @node_name = node_name
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
        rescue StandardError => error
          DSL::Components::Error.new(error)
        end
      end
    end
  end
end
