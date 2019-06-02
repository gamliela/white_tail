module WhiteTail
  module DSL
    module Nodes
      class List < DelegateClass(Array)
        def initialize(base = Array.new)
          super(base)
        end
      end
    end
  end
end
