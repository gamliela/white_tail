module WhiteTail
  class ScriptExecutor
    attr_reader :element

    def initialize(element)
      @element = element

      raise "#{element.class} is not scriptable" unless commands
      raise "#{element.class} is not a Record component" unless element.class < DSL::Components::Record
    end

    def execute(execution_scope)
      commands.each do |command|
        element[command.element_name] = execute_command(command, execution_scope)
      end
      element
    rescue StandardError => error
      DSL::Components::Error.new(error)
    end

    def execute_command(command, execution_scope)
      command.execute(execution_scope)
    end

    def self.execute_for(component, execution_scope)
      element = component.new
      ScriptExecutor.new(element).execute(execution_scope)
    end

    private

    def commands
      element.class.script&.commands
    end
  end
end
