module WhiteTail
  module DSL
    module Commands
      class TextCommand < BaseCommand
        attr_reader :component, :locator, :block

        def initialize(component, element_name, locator, **options, &block)
          super(element_name, options)
          @component = component
          @locator = locator
          @block = block
        end

        def execute
          # TODO: implement this
          DSL::DataObject.new
        end
      end
    end
  end
end
