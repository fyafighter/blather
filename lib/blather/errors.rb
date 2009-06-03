module Blather
  # Main error class
  class BlatherError < StandardError
    class_inheritable_array :handler_heirarchy

    self.handler_heirarchy ||= []
    self.handler_heirarchy << :error

    def self.register(handler)
      self.handler_heirarchy.unshift handler
    end

    # HACK!! until I can refactor the entire Error object model
    def id
      nil
    end
  end

  ##
  # Used in cases where a stanza only allows specific values for its attributes
  # and an invalid value is attempted.
  class ArgumentError < BlatherError
    register :argument_error
  end

  ##
  # The stream handler received a response it didn't know how to handle
  class UnknownResponse < BlatherError
    register :unknown_response_error
    attr_reader :node

    def initialize(node)
      @node = node
    end
  end

  ##
  # Something bad happened while parsing the incoming stream
  class ParseError < BlatherError
    register :parse_error
    attr_reader :message

    def initialize(msg)
      @message = msg.to_s
    end
  end
end
