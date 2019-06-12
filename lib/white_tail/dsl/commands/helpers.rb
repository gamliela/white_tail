module WhiteTail
  module DSL
    module Commands
      module Helpers
        def self.validate_required_option!(option_key, option_value)
          raise "Required option is missing: #{option_key}" if option_value.nil?
        end

        def self.validate_options!(options, allowed_options, required_options = {})
          illegal_options = options.keys - allowed_options
          raise "Illegal options were found: #{illegal_options}" if illegal_options.any?
          required_options.each do |option_key|
            validate_required_option!(option_key, options[option_key])
          end
        end

        def self.extract_script!(node_class)
          raise "#{node_class} has no script defined" unless node_class.respond_to?('script') && node_class.script&.commands
          node_class.script
        end

        def self.find_elements(execution_context, locator, options)
          return [execution_context.element] if locator.nil?

          elements = execution_context.element.find_all(locator)

          raise "Element not found" if elements.empty? && options[:required]
          raise "Ambiguous match, found #{elements.size} elements" if elements.size > 1 && options[:unique]

          elements
        end

        def self.find_element(execution_context, locator, options)
          elements = self.find_elements(execution_context, locator, options.merge(:unique => true))
          elements.first
        end

        def self.with_element(execution_context, locator, default = nil, options)
          element = Helpers.find_element(execution_context, locator, options)
          if element && block_given?
            yield element
          end
          Nodes::Field.new(default)
        end

        def self.execute_script(script, execution_context)
          script.commands.each do |command|
            command.execute(execution_context)
          end
          nil
        end
      end
    end
  end
end
