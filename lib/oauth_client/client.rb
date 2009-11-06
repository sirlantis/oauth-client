module OAuthClient
  class Client

    # class method for setting/getting the base uri for API
    def self.site(site = nil)
      @@site = site if site
      @@site
    end

    # class method for setting/getting the http method for API
    def self.http_method(http_method = nil)
      @@http_method = http_method if http_method
      @@http_method
    end

    # class method for setting/getting the http method for API
    def self.scheme(scheme = nil)
      @@scheme = scheme if scheme
      @@scheme
    end

    def self.request_scheme(scheme = nil)
      @@request_scheme = scheme if scheme
      @@request_scheme
    end
  
    # constructor
    def initialize(options = {})
      @consumer_key = options[:consumer_key]
      @consumer_secret = options[:consumer_secret]
      @token = options[:token] || ""
      @secret = options[:secret]
      @adapters = {}
    end

    # authorization
    def authorize(token, secret, options = {})
      request_token = OAuth::RequestToken.new(
        consumer, token, secret
      )
      @access_token = request_token.get_access_token(options)
      @token = @access_token.token
      @secret = @access_token.secret
      @access_token
    end
  
    # get the request token
    def request_token(options = {})
      consumer(:scheme => (@@request_scheme || :header)).get_request_token(options)
    end
    
    # make a GET request and return raw response
    def get(url)
      raise OAuthUnauthorized if !access_token
      access_token.get(url)
    end
  
    # make a POST request and return raw response
    def post(url, params = {})
      raise OAuthUnauthorized if !access_token
      access_token.post(url, params)
    end
  
    # json adapter, allowing json.get and json.post methods
    def json
      return @adapters[:json] if @adapters[:json]
      require 'oauth_client/adapters/json'
      @adapters[:json] = OAuthClient::Adapters::Json.new(self)
    end

    # xml adapter, allowing xml.get and xml.post methods
    def xml
      return @adapters[:xml] if @adapters[:xml]
      require 'oauth_client/adapters/xml'
      @adapters[:xml] = OAuthClient::Adapters::Xml.new(self)
    end
  
    private
  
    # get the consumer object, with site specified by class variable
    def consumer(options = nil)
      if @consumer and !options
        return @consumer
      end

      consumer_options = {
        :site=> @@site,
        :http_method => @@http_method || :post,
        :scheme => @@scheme || :header
      }
      consumer_options.merge(options) if options

      consumer = OAuth::Consumer.new(
        @consumer_key,
        @consumer_secret,
        consumer_options
      )

      @consumer = consumer unless options
      consumer
    end

    # get access token used for API access
    def access_token
      @access_token ||= OAuth::AccessToken.new(consumer, @token, @secret)
    end

  end

end
