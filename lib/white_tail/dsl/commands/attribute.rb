module WhiteTail
  module DSL
    module Commands
      class Attribute < Elements
        attr_reader :attribute

        def initialize(component, element_name, locator, attribute, **options, &block)
          super(component, element_name, locator, **options, &block)
          @attribute = attribute
        end

        def execute(execution_scope)
          element = find_elements(execution_scope)
          raise "Ambiguous match, found #{elements.size} elements" if element.size > 1
          value = element.first&.[](attribute)
          raise "Attribute not found" if value.nil? && options[:required]
          DSL::Components::Field.new(value)
        end
      end
    end
  end
end
