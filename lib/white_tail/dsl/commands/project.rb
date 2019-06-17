module WhiteTail
  module DSL
    module Commands
      class Project < Base
        prepend ScriptExecuter

        REQUIRED_OPTIONS = [:node_class]
        ALLOWED_OPTIONS = []

        def execute
          session = Capybara::Session.new(Capybara.default_driver)
          project_node = options[:node_class].new
          project_execution_context = ExecutionContext.new(session, project_node)
          Helpers.execute_script(script, project_execution_context)
          project_node
        end
      end
    end
  end
end
