module WhiteTail
  module DSL
    module Components
      class Record < DelegateClass(Hash)
        def initialize(base = Hash.new)
          super(base)
        end
      end
    end
  end
end
