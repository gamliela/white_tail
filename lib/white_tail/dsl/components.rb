require_relative "components/error"
require_relative "components/field"
require_relative "components/record"
require_relative "components/project"
require_relative "components/page"
require_relative "components/section"
require_relative "components/text"
require_relative "components/attribute"

module WhiteTail
  module DSL
    module Components
      def self.def_component(namespace, super_class, element_name, &block)
        klass = self.resolve_component(namespace, super_class, element_name)
        klass.class_eval(&block) if block_given?
        klass
      end

      def self.resolve_component(namespace, super_class, element_name)
        prefix = WhiteTail::Utils::camel_case(element_name.to_s)
        suffix = super_class.name.split("::").last
        local_class_name = prefix + suffix

        unless namespace.const_defined?(local_class_name, false)
          namespace.const_set(local_class_name, Class.new(super_class))
        end

        namespace.const_get(local_class_name, false)
      end

      def self.def_project(project_name, &block)
        def_component(Projects, DSL::Components::Project, project_name, &block)
      end

      def self.resolve_project_component(project_name)
        resolve_component(Projects, DSL::Components::Project, project_name)
      end
    end
  end
end
