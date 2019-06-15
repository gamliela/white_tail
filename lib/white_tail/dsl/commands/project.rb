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

          Helpers.validate_options!(options, ALLOWED_OPTIONS)
        end

        def execute
          session = Capybara::Session.new(Capybara.default_driver)
          project_node = project_class.new
          project_execution_context = ExecutionContext.new(session, project_node)
          Helpers.execute_script(script, project_execution_context)
          project_node
        end

        def locate(*)
          nil
        end
      end
    end
  end
end
