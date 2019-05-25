module WhiteTail
  module DSL
    module Commands
      class Text < Elements
        def execute(execution_scope)
          value = find_elements(execution_scope)
          value = value.map(&:text).join(' ') if value.any?
          DSL::Components::Field.new(value)
        end
      end
    end
  end
end
