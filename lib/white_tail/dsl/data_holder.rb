module WhiteTail
  module DSL
    module DataHolder
      def data
        @data ||= DataObject.new
      end
    end
  end
end
