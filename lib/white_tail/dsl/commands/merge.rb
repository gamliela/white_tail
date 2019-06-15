module WhiteTail
  module DSL
    module Commands
      class Merge
        attr_reader :command

        def initialize(command)
          @command = command
        end

        def execute(execution_context)
          value = command.execute(execution_context)
          execution_context.node.merge!(value)
        end

        def locate(execution_context)
          command.locate(execution_context)
        end
      end
    end
  end
end
