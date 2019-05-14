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
    end
  end
end
