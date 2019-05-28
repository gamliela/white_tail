module WhiteTail
  class ExecutionScope
    class IndexedLocator
      attr_reader :locator, :index

      def initialize(locator, index)
        @locator = locator
        @index = index
      end
    end

    def initialize(session)
      @session = session
      @url = session.current_url
      @locators = []
      @text = nil
    end

    def new_instance
      ExecutionScope.new(session)
    end

    def extend_instance(locator = nil, locator_index = nil, text = nil)
      instance = new_instance
      instance.locators += locators
      instance.locators <<= IndexedLocator.new(locator, locator_index) if locator
      instance.text = text
      instance
    end

    # wrap Capybara DSL with scope checks
    # if scope is defined on page it will be validated,
    # and the DSL command will be performed within the scope.
    Capybara::Session::DSL_METHODS.each do |method|
      define_method method do |*args, &block|
        scoped_element = locate_scoped_element!
        if scoped_element == session
          session.send method, *args, &block
        else
          session.within scoped_element do
            session.send method, *args, &block
          end
        end
      end
    end

    protected

    attr_accessor :session, :url, :locators, :text

    private

    def locate_scoped_element!
      scoped_element = locators.reduce(session) do |base_element, indexed_locator|
        scoped_elements = base_element.all(indexed_locator.locator)
        if !indexed_locator.index.nil?
          scoped_elements[indexed_locator.index]
        elsif scoped_elements.size == 1
          scoped_elements[0]
        else
          raise UnexpectedBrowserState, 'locator_index mismatch'
        end
      end

      raise UnexpectedBrowserState, 'url mismatch' if url && url != session.current_url
      raise UnexpectedBrowserState, 'text mismatch' if text && text != scoped_element.text

      scoped_element
    end
  end
end
