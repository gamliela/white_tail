module WhiteTail
  module DSL
    module Commands
      class Assignment
        attr_reader :node_name, :command

        def initialize(node_name, command)
          @node_name = node_name
          @command = command
        end

        def execute(execution_scope)
          value = command.execute(execution_scope)
          execution_scope.node[node_name] = value if node_name
        end
      end
    end
  end
end
