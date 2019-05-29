module WhiteTail
  module DSL
    module Commands
      module Helpers
        def self.validate_options(options, allowed_options)
          illegal_options = options.keys - allowed_options
          raise "Illegal options were found: #{illegal_options}" if illegal_options.any?
        end

        def self.validate_script_commands(node_class)
          raise "#{node_class} has no script defined" unless node_class.script&.commands
        end

        def self.validate_record_type(node_class)
          raise "#{node_class} is not a Record node" unless node_class <= DSL::Nodes::Record
        end

        def self.find_elements(execution_scope, locator, options)
          elements = execution_scope.find_all(locator)

          raise "Element not found" if elements.empty? && options[:required]
          raise "Ambiguous match, found #{elements.size} elements" if elements.size > 1 && !options[:multiple]

          elements
        end

        def self.execute_script(execution_scope)
          execution_scope.node.class.script&.commands.each do |command|
            command.execute(execution_scope)
          end
        end
      end
    end
  end
end
