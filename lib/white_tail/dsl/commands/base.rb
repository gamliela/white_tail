module WhiteTail
  module DSL
    module Commands
      class Base
        attr_reader :element_name, :options

        def initialize(element_name, **options)
          @element_name = element_name
          @options = options
        end
      end
    end
  end
end
