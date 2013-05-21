module ApiRateLimiter
  class ApiNotFoundError < StandardError; end

  def rate_limiters
    # set global rate limiters variable that is only called once if with_rate_limiting is needed
    $rate_limiters ||= initialize_rate_limiters
  end

  def with_rate_limiting(api_name, times)
    raise ApiNotFoundError unless rate_limiters[api_name]

    times.times do
      rate_limiters[api_name].within_constraints do
        yield
      end
    end
  end

  private

  def initialize_rate_limiters
    rate_limiters = {}
    API_INFO.each do |api_name, constraints|
      rate_limiters.merge!({ api_name => RateLimitedScheduler.new("#{api_name}_api_requests", constraints) })
    end

    rate_limiters
  end
end
