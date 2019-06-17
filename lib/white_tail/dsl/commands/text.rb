module WhiteTail
  module DSL
    module Commands
      class Text < Base
        REQUIRED_OPTIONS = [:node_class]
        ALLOWED_OPTIONS = [:locator, :required, :unique]

        def execute(execution_context)
          elements = Helpers.find_elements(execution_context, options)
          if elements.any?
            value = elements.map(&:text).join(' ')
          else
            value = nil
          end
          options[:node_class].new(value)
        end
      end
    end
  end
end
