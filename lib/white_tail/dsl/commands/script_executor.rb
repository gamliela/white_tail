module WhiteTail
  module DSL
    module Commands
      class ScriptExecutor
        attr_reader :node

        def initialize(node)
          @node = node

          raise "#{node.class} is not scriptable" unless commands
          raise "#{node.class} is not a Record node" unless node.class < DSL::Nodes::Record
        end

        def execute(execution_scope)
          commands.each do |command|
            node[command.node_name] = execute_command(command, execution_scope)
          end
          node
        end

        def execute_command(command, execution_scope)
          command.execute(execution_scope)
        end

        def self.execute_for(node_class, execution_scope)
          node = node_class.new
          ScriptExecutor.new(node).execute(execution_scope)
        end

        private

        def commands
          node.class.script&.commands
        end
      end
    end
  end
end
