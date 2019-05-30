module WhiteTail
  module DSL
    module Commands
      class Section
        ALLOWED_OPTIONS = %i[required]

        attr_reader :parent_class, :section_class, :node_name, :locator, :options

        def initialize(parent_class, section_class, node_name, locator, **options)
          @parent_class = parent_class
          @section_class = section_class
          @node_name = node_name
          @locator = locator
          @options = options

          Helpers.validate_options(options, ALLOWED_OPTIONS)
          Helpers.validate_record_type(parent_class)
          Helpers.validate_script_commands(section_class)
        end

        def execute(execution_scope)
          execution_scope.node[node_name] = build_section_node(execution_scope)
        end

        private

        def build_section_node(execution_scope)
          element = Helpers.find_elements(execution_scope, locator, options).first
          if element
            section_node = section_class.new
            section_execution_scope = execution_scope.extend_instance(section_node, locator, 0, element.text)
            Helpers.execute_script(section_execution_scope)
            section_node
          else
            Nodes::Field.new(nil)
          end
        end
      end
    end
  end
end
