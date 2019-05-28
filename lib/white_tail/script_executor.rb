module WhiteTail
  class ScriptExecutor
    attr_reader :node

    def initialize(node)
      @node = node

      raise "#{node.class} is not scriptable" unless commands
      raise "#{node.class} is not a Record component" unless node.class < DSL::Components::Record
    end

    def execute(execution_scope)
      commands.each do |command|
        node[command.node_name] = execute_command(command, execution_scope)
      end
      node
    rescue StandardError => error
      DSL::Components::Error.new(error)
    end

    def execute_command(command, execution_scope)
      command.execute(execution_scope)
    end

    def self.execute_for(component, execution_scope)
      node = component.new
      ScriptExecutor.new(node).execute(execution_scope)
    end

    private

    def commands
      node.class.script&.commands
    end
  end
end
