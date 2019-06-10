module WhiteTail

  # TODO: ideas for improvements
  # - This class has too much responsibilities:
  #   - Stack of location scopes
  #   - Global holder for session object
  #   - An executor for browser commands
  #   - Holder of Node object (used by Assignment class)
  #   - In the future, will hold stack of nodes (that can be used to trace errors)
  # - The implementation of immutable objects prevent us to utilize cache benefits
  # - Instead of passing text into constructor, pass element and populate cache
  # - The name "execution_scope" is misleading. "execution_context" is more appropriate.
  class ExecutionScope
    class IndexedLocator
      attr_reader :locator, :index

      def initialize(locator, index)
        @locator = locator
        @index = index
      end

      def locate(base_element)
        # puts "IndexedLocator.locate! #{locator}   #{index}"
        scoped_elements = base_element.all(locator)
        if !index.nil?
          scoped_elements[index]
        elsif scoped_elements.size == 1
          scoped_elements[0]
        else
          raise UnexpectedBrowserState, 'locator_index mismatch'
        end
      end
    end

    attr_reader :node

    def initialize(session, node)
      @session = session
      @node = node
      @url = nil
      @locators = []
      @text = nil

      raise ArgumentError, "session argument cannot be nil" if session.nil?
    end

    def new_instance(node)
      ExecutionScope.new(session, node)
    end

    def extend_instance(node, locator = nil, locator_index = nil, text = nil)
      instance = new_instance(node)
      instance.url ||= session.current_url
      instance.locators += locators
      instance.locators <<= IndexedLocator.new(locator, locator_index) if locator
      instance.text = text
      instance
    end

    def scoped_element
      @scoped_element ||= locate_scoped_element!
    end

    # wrap Capybara DSL with scope checks
    # if scope is defined on page it will be validated,
    # and the DSL command will be performed within the scope.
    Capybara::Session::DSL_METHODS.each do |method|
      define_method method do |*args, &block|
        # puts "*** DSL_METHOD: #{method} #{args}"
        if scoped_element == session
          # puts "DSL_METHOD: #{method} #{args}"
          session.send method, *args, &block
        else
          session.within scoped_element do
            # puts "DSL_METHOD (scoped): #{method} #{args}"
            session.send method, *args, &block
          end
        end
      end
    end

    protected

    attr_accessor :session, :url, :locators, :text
    attr_writer :node

    private

    def locate_scoped_element!
      # puts "locate_scoped_element!"
      scoped_element = locators.reduce(session) do |base_element, indexed_locator|
        indexed_locator.locate(base_element)
      end

      raise UnexpectedBrowserState, 'url mismatch' if url && url != session.current_url
      raise UnexpectedBrowserState, 'text mismatch' if text && text != scoped_element.text

      scoped_element
    end
  end
end
