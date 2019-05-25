module WhiteTail
  module DSL
    module Commands
      # TODO: consider convert to mixin
      class Elements < Base
        attr_reader :component, :locator, :block

        def initialize(component, element_name, locator, **options, &block)
          super(element_name, options)
          @component = component
          @locator = locator
          @block = block
        end

        def find_elements(execution_scope)
          elements = execution_scope.session.find_all(locator)
          raise "Element not found" if elements.empty? && options[:required]
          raise "Ambiguous match, found #{elements.size} elements" if elements.size > 1 && !options[:multiple]
          elements
        end
      end
    end
  end
end
