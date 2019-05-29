module WhiteTail
  module DSL
    module Commands
      class Project
        include Helpers

        ALLOWED_OPTIONS = []

        attr_reader :project_class, :node_name, :options

        def initialize(project_class, node_name, **options)
          @project_class = project_class
          @node_name = node_name
          @options = options

          validate_options(ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          execution_scope = execution_scope.new_instance
          ScriptExecutor.execute_for(project_class, execution_scope)
        rescue StandardError => error
          DSL::Nodes::Error.new(error)
        end
      end
    end
  end
end
