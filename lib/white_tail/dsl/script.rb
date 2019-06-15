module WhiteTail
  module DSL
    class Script
      attr_accessor :commands

      def initialize
        @commands = []
      end

      def <<(item)
        commands << item
      end

      def find_command_by_name(node_name)
        commands.find { |command| command.options[:node_name] == node_name } if node_name
      end
    end
  end
end
