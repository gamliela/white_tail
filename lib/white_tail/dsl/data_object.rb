module WhiteTail
  module DSL
    class DataObject
      attr_accessor :records, :error

      def initialize(records = [], error = nil)
        @records = records
        @error = error
      end
    end
  end
end
