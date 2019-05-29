module WhiteTail
  module DSL
    module Commands
      module Helpers
        def self.validate_options(options, allowed_options)
          illegal_options = options.keys - allowed_options
          raise "Illegal options were found: #{illegal_options}" if illegal_options.any?
        end

        def self.find_elements(execution_scope, locator, options)
          elements = execution_scope.find_all(locator)

          raise "Element not found" if elements.empty? && options[:required]
          raise "Ambiguous match, found #{elements.size} elements" if elements.size > 1 && !options[:multiple]

          elements
        end
      end
    end
  end
end
