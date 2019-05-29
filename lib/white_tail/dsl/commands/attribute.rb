module WhiteTail
  module DSL
    module Commands
      class Attribute
        ALLOWED_OPTIONS = %i[required]

        attr_reader :attribute_class, :node_name, :locator, :attribute, :options

        def initialize(attribute_class, node_name, locator, attribute, **options)
          @attribute_class = attribute_class
          @node_name = node_name
          @locator = locator
          @attribute = attribute
          @options = options

          Helpers.validate_options(options, ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          Helpers.validate_record_type(execution_scope.node.class)
          execution_scope.node[node_name] = build_attribute_node(execution_scope)
        end

        private

        def build_attribute_node(execution_scope)
          element = Helpers.find_elements(execution_scope, locator, options)
          value = element.first&.[](attribute)

          raise "Attribute #{node_name} not found" if value.nil? && options[:required]

          attribute_class.new(value)
        end
      end
    end
  end
end
