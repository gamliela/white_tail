require "ostruct"

module WhiteTail
  class ScriptExecutor
    attr_accessor :script, :data

    def initialize(script)
      @script = script
      @data = DSL::DataObject.new([OpenStruct.new])
    end

    def execute
      script.commands.each do |command|
        record[command.element_name] = execute_command(command)
      end
      data
    end

    def execute_command(command)
      command.execute
    rescue StandardError => error
      DSL::DataObject.new([], error)
    end

    private

    def record
      data.records.first
    end
  end
end
