module WhiteTail
  module DSL
    module ScriptBuilder
      def script
        @script ||= Script.new
      end

      def page(page_name, url, **options, &block)
        page_class = Nodes.def_node_class(self, Nodes::Page, page_name, &block)
        script << Commands::Page.new(self, page_class, page_name, url, options)
      end

      def validation(validation_name, locator, **options)
        script << Commands::Validation.new(validation_name, locator, options)
      end

      def section(section_name, locator, **options, &block)
        section_class = Nodes.def_node_class(self, Nodes::Section, section_name, &block)
        script << Commands::Section.new(self, section_class, section_name, locator, options)
      end

      def text(text_name, locator, **options)
        text_class = Nodes.def_node_class(self, Nodes::Text, text_name)
        script << Commands::Text.new(self, text_class, text_name, locator, options)
      end

      def attribute(attribute_name, locator, attribute, **options)
        attribute_class = Nodes.def_node_class(self, Nodes::Attribute, attribute_name)
        script << Commands::Attribute.new(self, attribute_class, attribute_name, locator, attribute, options)
      end
    end
  end
end
