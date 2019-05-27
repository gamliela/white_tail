module WhiteTail
  module DSL
    module Commands
      module ElementsLocator
        def find_elements(execution_scope)
          elements = execution_scope.find_all(locator)

          raise "Element not found" if elements.empty? && options[:required]
          raise "Ambiguous match, found #{elements.size} elements" if elements.size > 1 && !options[:multiple]

          elements
        end
      end
    end
  end
end
