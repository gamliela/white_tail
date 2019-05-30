module WhiteTail
  module DSL
    module Commands
      class Text
        ALLOWED_OPTIONS = %i[required multiple]

        attr_reader :parent_class, :text_class, :node_name, :locator, :options

        def initialize(parent_class, text_class, node_name, locator, **options)
          @parent_class = parent_class
          @text_class = text_class
          @node_name = node_name
          @locator = locator
          @options = options

          Helpers.validate_options(options, ALLOWED_OPTIONS)
          Helpers.validate_record_type(parent_class)
        end

        def execute(execution_scope)
          execution_scope.node[node_name] = build_text_node(execution_scope)
        end

        private

        def build_text_node(execution_scope)
          elements = Helpers.find_elements(execution_scope, locator, options)
          if elements.any?
            value = elements.map(&:text).join(' ')
          else
            value = nil
          end
          text_class.new(value)
        end
      end
    end
  end
end
