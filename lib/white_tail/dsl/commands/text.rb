module WhiteTail
  module DSL
    module Commands
      class Text < Elements
        def execute(execution_scope)
          elements = find_elements(execution_scope)
          value = elements.map(&:text).join(' ') if elements.any?
          DSL::Components::Field.new(value)
        end
      end
    end
  end
end
