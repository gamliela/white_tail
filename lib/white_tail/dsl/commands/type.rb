module WhiteTail
  module DSL
    module Commands
      class Type < Base
        REQUIRED_OPTIONS = [:text]
        ALLOWED_OPTIONS = [:locator]

        def execute(execution_context)
          Helpers.with_element(execution_context, options) do |element|
            element.send_keys options[:text]
            Nodes::Field.new(element.value)
          end
        end
      end
    end
  end
end
