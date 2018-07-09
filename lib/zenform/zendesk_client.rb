require 'zendesk_api'

module Zenform
  module ZendeskClient
    API_URL = "https://%{domain}/api/v2"

    def self.create(domain: nil, username: nil, token: nil)
      ZendeskAPI::Client.new do |config|
        config.url      = format API_URL, domain: domain
        config.username = username
        config.token    = token
      end
    end
  end
end
