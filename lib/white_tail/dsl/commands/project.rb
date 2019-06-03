module WhiteTail
  module DSL
    module Commands
      class Project
        ALLOWED_OPTIONS = []

        attr_reader :project_class, :script, :options

        def initialize(project_class, **options)
          @project_class = project_class
          @script = Helpers.extract_script!(project_class)
          @options = options

          Helpers.validate_options(options, ALLOWED_OPTIONS)
        end

        def execute(execution_scope)
          project_node = project_class.new
          project_execution_scope = execution_scope.new_instance(project_node)
          Helpers.execute_script(script, project_execution_scope)
          project_node
        end
      end
    end
  end
end
