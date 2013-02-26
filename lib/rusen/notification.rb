module Rusen

  # Class for holding all the information that can be sent in a notification.
  class Notification

    attr_reader :exception, :request, :environment, :session

    def initialize(exception, request = {} , environment = {}, session = {})
      @exception = exception
      @request = request
      @environment = environment
      @session = session
    end

  end

end
