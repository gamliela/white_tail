module WhiteTail
  module DSL
    module Commands
      class PageCommand < BaseCommand
        attr_reader :page_class, :url

        def initialize(page_class, element_name, url, **options)
          super(element_name, options)
          @page_class = page_class
          @url = url
        end

        def execute
          # TODO: implement this
          DSL::DataObject.new
        end
      end
    end
  end
end
