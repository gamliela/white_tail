module WhiteTail
  module DSL
    module Nodes
      class Record < DelegateClass(Hash)
        def initialize(base = Hash.new)
          super(base)
        end
      end
    end
  end
end
