module WhiteTail
  module DSL
    module Commands
      module Helpers
        def self.validate_options(options, allowed_options, required_options = {})
          illegal_options = options.keys - allowed_options
          raise "Illegal options were found: #{illegal_options}" if illegal_options.any?
          required_options.each do |required_key|
            raise "Required option is missing: #{required_key}" if options[required_key].nil?
          end
        end

        def self.extract_script!(node_class)
          raise "#{node_class} has no script defined" unless node_class.respond_to?('script') && node_class.script&.commands
          node_class.script
        end

        def self.find_elements(execution_scope, locator, options)
          elements = execution_scope.find_all(locator)

          raise "Element not found" if elements.empty? && options[:required]
          raise "Ambiguous match, found #{elements.size} elements" if elements.size > 1 && !options[:multiple]

          elements
        end

        def self.find_element(execution_scope, locator, locator_index = nil, options)
          return execution_scope.scoped_element if locator.nil?

          elements = execution_scope.find_all(locator)

          if locator_index
            element = elements[locator_index]
          else
            raise "Ambiguous match, found #{elements.size} elements" if elements.size > 1
            element = elements.first
          end

          raise "Element not found" if element.nil? && options[:required]

          element
        end

        def self.execute_script(script, execution_scope)
          script.commands.each do |command|
            command.execute(execution_scope)
          end
          nil
        end
      end
    end
  end
end
