module WhiteTail
  class ExecutionScope
    attr_accessor :session, :url

    def initialize(session, url = nil)
      @session = session
      @url = url
    end
  end
end
