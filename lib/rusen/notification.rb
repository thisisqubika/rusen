module Rusen

  class Notification

    attr_reader :exception, :request, :environment, :session

    def initialize(exception, request = nil, environment = nil, session = nil)
      @exception = exception
      @request = request || {}
      @environment = environment  || {}
      @session = session || {}
    end

  end

end