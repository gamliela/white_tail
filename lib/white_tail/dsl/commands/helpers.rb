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

        def self.validate_script_commands(node_class)
          raise "#{node_class} has no script defined" unless node_class.respond_to?('script') && node_class.script&.commands
        end

        def self.validate_record_type(node_class)
          raise "#{node_class} is not a Record node" unless node_class <= DSL::Nodes::Record
        end

        def self.validate_list_type(node_class)
          raise "#{node_class} is not a List node" unless node_class <= DSL::Nodes::List
        end

        def self.find_elements(execution_scope, locator, options)
          elements = execution_scope.find_all(locator)

          raise "Element not found" if elements.empty? && options[:required]
          raise "Ambiguous match, found #{elements.size} elements" if elements.size > 1 && !options[:multiple]

          elements
        end

        def self.execute_script(execution_scope)
          script = execution_scope.node.class.script
          script.commands.each do |command|
            command.execute(execution_scope)
          end
          execution_scope.node
        end
      end
    end
  end
end
