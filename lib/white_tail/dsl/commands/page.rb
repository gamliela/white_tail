module WhiteTail
  module DSL
    module Commands
      class Page
        ALLOWED_OPTIONS = []

        attr_reader :parent_class, :page_class, :node_name, :url, :options

        def initialize(parent_class, page_class, node_name, url, **options)
          @parent_class = parent_class
          @page_class = page_class
          @node_name = node_name
          @url = url
          @options = options

          Helpers.validate_options(options, ALLOWED_OPTIONS)
          Helpers.validate_record_type(parent_class)
          Helpers.validate_script_commands(page_class)
        end

        def execute(execution_scope)
          execution_scope.node[node_name] = build_page_node(execution_scope)
        end

        private

        def build_page_node(execution_scope)
          page_node = page_class.new
          execution_scope.visit(url) if url
          page_execution_scope = execution_scope.new_instance(page_node)
          Helpers.execute_script(page_execution_scope)
          page_node
        end
      end
    end
  end
end
