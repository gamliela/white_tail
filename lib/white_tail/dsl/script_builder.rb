module WhiteTail
  module DSL
    module ScriptBuilder
      def script
        @script ||= Script.new
      end

      def page(page_name, url, **options, &block)
        component = Components.def_component(self, Components::Page, page_name, &block)
        script << Commands::Page.new(component, page_name, url, options)
      end

      def validation(validation_name, locator, **options)
        script << Commands::Validation.new(validation_name, locator, options)
      end

      def section(section_name, locator, **options, &block)
        component = Components.def_component(self, Components::Section, section_name, &block)
        script << Commands::Section.new(component, section_name, locator, options)
      end

      def text(text_name, locator, **options)
        component = Components.def_component(self, Components::Text, text_name)
        script << Commands::Text.new(component, text_name, locator, options)
      end

      def attribute(attribute_name, locator, attribute, **options)
        component = Components.def_component(self, Components::Attribute, attribute_name)
        script << Commands::Attribute.new(component, attribute_name, locator, attribute, options)
      end
    end
  end
end
