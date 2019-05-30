module WhiteTail
  module DSL
    module Commands
      class Project
        ALLOWED_OPTIONS = []

        attr_reader :parent_class, :project_class, :node_name, :options

        def initialize(parent_class, project_class, node_name, **options)
          @parent_class = parent_class
          @project_class = project_class
          @node_name = node_name
          @options = options

          Helpers.validate_options(options, ALLOWED_OPTIONS)
          Helpers.validate_record_type(parent_class)
          Helpers.validate_script_commands(project_class)
        end

        def execute(execution_scope)
          execution_scope.node[node_name] = build_project_node(execution_scope)
        end

        private

        def build_project_node(execution_scope)
          project_node = project_class.new
          project_execution_scope = execution_scope.new_instance(project_node)
          Helpers.execute_script(project_execution_scope)
          project_node
        end
      end
    end
  end
end
