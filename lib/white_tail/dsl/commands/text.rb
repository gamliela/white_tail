module WhiteTail
  module DSL
    module Commands
      class Text < Base
        attr_reader :component, :locator, :block

        def initialize(component, element_name, locator, **options, &block)
          super(element_name, options)
          @component = component
          @locator = locator
          @block = block
        end

        def execute(execution_scope)
          value = nil
          if locator
            elements = execution_scope.session.find_all(locator)
            raise "Element not found" if elements.empty? && options[:required]
            raise "Ambiguous match, found #{elements.size} elements" if elements.size > 1 && !options[:multiple]
            value = elements.map(&:text).join(' ') if elements.any?
          end
          # block need to run in execution_scope, maybe create action_executor service
          #value = instance_exec(value, &block) if block
          DSL::Components::Field.new(value)
        rescue StandardError => error
          DSL::Components::Error.new(error)
        end
      end
    end
  end
end
