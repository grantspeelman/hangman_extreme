require 'faraday'
require 'singleton'

class FreshDeskConnection
  include Singleton

  def freshdesk_api_key
    ENV['FRESHDESK_API_KEY']
  end

  def method_missing(m, *args, &block)
    connection.respond_to?(m) ? connection.send(m,*args,&block) : super(m, *args, &block)
  end

  def respond_to?(m, *args, &block)
    connection.respond_to?(m,*args, &block) || super(m, *args, &block)
  end

  private

  def connection
    return @_connection if @_connection
    @_connection = Faraday.new(url: 'http://ubxdmxitapps.freshdesk.com/') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      # faraday.response :logger
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    @_connection.basic_auth(freshdesk_api_key, 'X')
    @_connection
  end
end
