module WhiteTail
  class ScriptError < StandardError
  end

  class ValidationFailed < StandardError
    attr_reader :node_name

    def initialize(msg = nil, node_name = nil)
      @node_name = node_name
      node_name ||= "element"
      msg ||= "#{node_name} not found"
      super(msg)
    end
  end
end
