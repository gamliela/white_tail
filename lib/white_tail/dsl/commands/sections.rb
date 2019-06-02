module WhiteTail
  module DSL
    module Commands
      class Sections
        REQUIRED_OPTIONS = %i[section_class]
        ALLOWED_OPTIONS = REQUIRED_OPTIONS + %i[required]

        attr_reader :parent_class, :sections_class, :node_name, :locator, :options

        def initialize(parent_class, sections_class, node_name, locator, **options)
          @parent_class = parent_class
          @sections_class = sections_class
          @node_name = node_name
          @locator = locator
          @options = options

          Helpers.validate_options(options, ALLOWED_OPTIONS, REQUIRED_OPTIONS)
          Helpers.validate_record_type(parent_class)
          Helpers.validate_list_type(sections_class)
          Helpers.validate_script_commands(section_class)
        end

        def execute(execution_scope)
          execution_scope.node[node_name] = build_sections_node(execution_scope)
        end

        private

        def section_class
          @section_class ||= options[:section_class]
        end

        def build_sections_node(execution_scope)
          elements = Helpers.find_elements(execution_scope, locator, options.merge(:multiple => true))

          # first, build execution scopes for all elements.
          # it's important to do that before executing any of them, so browser doesn't change state.
          section_execution_scopes = elements.each_with_index.map do |element, index|
            section_node = section_class.new
            execution_scope.extend_instance(section_node, locator, index, element.text)
          end

          # now, build array of nodes. each item is built with the same script, that is stored on sections_class.
          # note that errors do not
          sections_node = sections_class.new
          sections_node += section_execution_scopes.map do |section_execution_scope|
            Helpers.execute_script(section_execution_scope)
          rescue StandardError => error
            DSL::Nodes::Error.new(error)
          end
        end
      end
    end
  end
end
