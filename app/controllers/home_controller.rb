class HomeController < ApplicationController
  require 'api_rate_limiter'
  include ApiRateLimiter

  def index
    flash[:alert] = call_api(params[:times]) if params[:times]
  end

  def call_api(times)
    time_before = Time.now.to_f

    with_rate_limiting(:facebook, times.to_i) do
      FbGraph::Page.search('Ruby on Rails')
    end

    time_after = Time.now.to_f
    time_taken = (time_after - time_before).round(2)

    "Time: #{time_taken} seconds | Calls made: #{times}"
  end
end