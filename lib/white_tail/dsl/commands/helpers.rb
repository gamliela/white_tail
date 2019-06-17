module WhiteTail
  module DSL
    module Commands
      module Helpers
        def self.validate_required_option!(option_key, option_value)
          raise ScriptError, "Required option is missing: #{option_key}" if option_value.nil?
        end

        def self.validate_options!(options, allowed_options = [], required_options = [])
          illegal_options = options.keys - allowed_options - required_options
          raise ScriptError, "Illegal options were found: #{illegal_options}" if illegal_options.any?
          required_options.each do |option_key|
            validate_required_option!(option_key, options[option_key])
          end
        end

        def self.extract_script!(node_class:, **)
          raise ScriptError, "#{node_class} has no script defined" unless node_class.respond_to?('script') && node_class.script&.commands
          node_class.script
        end

        def self.find_elements(execution_context, locator: nil, required: nil, unique: nil, **)
          return [execution_context.element] unless locator

          elements = execution_context.element.find_all(locator)

          raise ValidationError, "Element not found" if elements.empty? && required
          raise ValidationError, "Ambiguous match, found #{elements.size} elements" if elements.size > 1 && unique

          elements
        end

        def self.find_element(execution_context, options = {})
          elements = self.find_elements(execution_context, options.merge(:unique => true))
          elements.first
        end

        def self.with_element(execution_context, default: nil, **options)
          element = Helpers.find_element(execution_context, options)
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
