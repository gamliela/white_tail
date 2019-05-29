require "capybara/dsl"
require "white_tail/default_config"
require "white_tail/version"
require "white_tail/exceptions"
require "white_tail/utils"
require "white_tail/projects"
require "white_tail/dsl"
require "white_tail/execution_scope"

module WhiteTail
  def self.project(project_name, &block)
    DSL::Nodes.def_project_class(project_name, &block)
  end

  def self.execute(project_name)
    project_class = DSL::Nodes::resolve_project_class(project_name)
    project_command = DSL::Commands::Project.new(project_class, project_name)
    session = Capybara::Session.new(:selenium_chrome)
    execution_scope = ExecutionScope.new(session)
    project_command.execute(execution_scope)
  rescue StandardError => error
    DSL::Nodes::Error.new(error)
  end

  def self.configure(config)
    Capybara.configure do |capybara_config|
      config.each do |key, value|
        capybara_config.send("#{key}=", value)
      end
    end
  end
end

WhiteTail.configure(WhiteTail::DEFAULT_CONFIG)
