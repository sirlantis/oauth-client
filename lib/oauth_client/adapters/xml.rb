require 'nokogiri'
module OAuthClient
  module Adapters
    # Xml Adapter for OAuthClient
    class Xml
      attr_accessor :client
  
      # on creation, the adapter must be supplied with the client
      def initialize(client)
        self.client = client
      end
  
      # make a GET request and parse Xml response
      def get(url)
        oauth_response = self.client.get(url)
        Nokogiri::XML::Document.parse(oauth_response.body)
      end
  
      # make a GET request and parse Xml response
      def post(url, params = {})
        oauth_response = self.client.post(url, params)
        Nokogiri::XML::Document.parse(oauth_response.body)
      end
    end
  end
end
