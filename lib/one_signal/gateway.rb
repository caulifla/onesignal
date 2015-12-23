require 'faraday'
require 'faraday_middleware'

module OneSignal
  class Gateway
    URL = 'https://onesignal.com'.freeze
    DEVICES_ENDPOINT = 'api/v1/players'.freeze

    def initialize(configuration = OneSignal.configuration)
      @http_client = create_http_client
      @configuration = configuration
    end

    def create_device(params = {})
      response = @http_client.post(DEVICES_ENDPOINT, params.merge(app_id: @configuration.app_id))
      symbolize_keys(response.body)
    end

    private

    def create_http_client
      Faraday.new(url: URL) do |faraday|
        faraday.request :json
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
    end

    def symbolize_keys(hash)
      hash.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
    end
  end
end