module WhiteTail
  module DSL
    module ScriptBuilder
      def script
        @script ||= Script.new
      end

      def page(page_name, url, **options, &block)
        component = Components.def_component(self, Components::Page, page_name, &block)

        script << Commands::PageCommand.new(component, page_name, url, options)
      end

      def text(text_name, locator, **options, &block)
        component = Components.def_component(self, Components::Text, text_name)

        script << Commands::TextCommand.new(component, text_name, locator, options, &block)
      end
    end
  end
end
