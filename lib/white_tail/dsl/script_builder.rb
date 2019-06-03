module WhiteTail
  module DSL
    module ScriptBuilder
      def script
        @script ||= Script.new
      end

      def page(page_name, url, **options, &block)
        page_class = Nodes.def_node_class(self, Nodes::Page, page_name, &block)
        page_command = Commands::Page.new(page_class, url, options)
        script << Commands::Assignment.new(page_name, page_command)
      end

      def validation(validation_name, locator, **options)
        script << Commands::Validation.new(validation_name, locator, options)
      end

      def section(section_name, locator, **options, &block)
        section_class = Nodes.def_node_class(self, Nodes::Section, section_name, &block)
        section_command = Commands::Section.new(section_class, locator, options)
        script << Commands::Assignment.new(section_name, section_command)
      end

      def sections(list_name, locator, **options, &block)
        list_class = Nodes.def_node_class(self, Nodes::List, list_name)
        section_class = Nodes.def_node_class(list_class, Nodes::Section, nil, &block)
        section_command = Commands::Section.new(section_class, nil, options)
        list_command = Commands::List.new(list_class, locator, section_command, { :required => options[:required] })
        script << Commands::Assignment.new(list_name, list_command)
      end

      def text(text_name, locator, **options)
        text_class = Nodes.def_node_class(self, Nodes::Text, text_name)
        text_command = Commands::Text.new(text_class, locator, options)
        script << Commands::Assignment.new(text_name, text_command)
      end

      def attribute(attribute_name, locator, attribute, **options)
        attribute_class = Nodes.def_node_class(self, Nodes::Attribute, attribute_name)
        attribute_command = Commands::Attribute.new(attribute_class, locator, attribute, options)
        script << Commands::Assignment.new(attribute_name, attribute_command)
      end

      def attributes(list_name, locator, attribute, **options)
        list_class = Nodes.def_node_class(self, Nodes::List, list_name)
        attribute_class = Nodes.def_node_class(list_class, Nodes::Attribute, nil)
        attribute_command = Commands::Attribute.new(attribute_class, locator, attribute, options)
        list_command = Commands::List.new(list_class, locator, attribute_command, { :required => options[:required] })
        script << Commands::Assignment.new(list_name, list_command)
      end
    end
  end
end
