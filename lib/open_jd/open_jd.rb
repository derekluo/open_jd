module OpenJd
  REQUEST_TIMEOUT = 10
  API_VERSION = '2.0'
  USER_AGENT = "open_jd-v#{VERSION}"
  PRODUCT_LINK = 'http://item.jd.com'
  ENDPOINT = 'https://api.jd.com/routerjson'

  class Error < StandardError; end

  class << self
    attr_accessor :config, :session

    def jd_link(id)
      "#{PRODUCT_LINK}/#{id}.html"
    end

    # Load a yml config, and initialize http session
    # yml config file content should be:
    #
    #   app_key:    "YOUR APP KEY"
    #   secret_key: "YOUR SECRET KEY"
    #   access_token: "YOUR ACCESS TOKEN"
    #
    def load(config_file)
      @config = YAML.load_file(config_file)
      @config = config[Rails.env] if defined? Rails
      check_config

      initialize_session
    end

    # check config
    #
    # raise exception if config key missed in YAML file
    def check_config
      list = []
      %w(app_key secret_key access_token).map do |k|
        list << k unless config.key? k
      end

      raise "[#{list.join(', ')}] not included in your yaml file." unless list.empty?
    end

    # Initialize http sesison
    def initialize_session
      @session = Faraday.new url: ENDPOINT do |builder|
        begin
          require 'patron'
          builder.adapter :patron
        rescue LoadError
          builder.adapter :net_http
        end
      end
    end

    # Return request signature with MD5 signature method
    def sign(params)
      Digest::MD5.hexdigest(wrap_with_secret sorted_option_string(params)).upcase
    end

    # wrapped with secret_key
    def wrap_with_secret(s)
      "#{config['secret_key']}#{s}#{config['secret_key']}"
    end

    # Return sorted request parameter by request key
    def sorted_option_string(options, mark = '', inner_sep = '', outer_sep = '')
      options.map {|k, v| "#{mark}#{k}#{mark}#{inner_sep}#{mark}#{v}#{mark}" }.sort.join(outer_sep)
    end

    # Merge custom parameters with JD system parameters.
    #
    # System paramters below will be merged.
    #
    #   timestamp
    #   v
    #   format
    #   sign_method
    #   app_key
    #   method
    #   params_key
    #
    # Current JD API Version is '2.0'.
    # <tt>format</tt> should be json.
    # Only <tt>sign_method</tt> MD5 is supported so far.
    def full_options(params)
      {
        v:                   API_VERSION,
        method:              params[:method],
        app_key:             config['app_key'],
        access_token:        config['access_token'],
        '360buy_param_json' => "{" + sorted_option_string(params[:fields], '"', ':', ',') + "}",
        timestamp:           Time.now.strftime('%F %T')
      }
    end

    def query_hash(params)
      params = full_options params
      params[:sign] = sign params
      params
    end

    # Return query string with signature.
    def query_string(params)
      '?' + sorted_option_string(query_hash(params), '', '=', '&')
    end

    # Return full url with signature.
    def url(params)
      format('%s%s', ENDPOINT, query_string(params))
    end

    # Return a parsed JSON object.
    def parse_result(data)
      MultiJson.decode(data)
    end

    # Request by get method and return result in JSON format
    def get(params)
      path = query_string(params)
      parse_result session.get(path).body
    end

    # Request by get method and return result in JSON format
    # Raise OpenTaobao::Error if returned with error_response
    def get!(params)
      response = get params
      raise Error.new(MultiJson.encode response['error_response']) if response.has_key?('error_response')
      response
    end

    # Request by post method and return result in JSON format
    def post(params)
      parse_result session.post('',  sorted_option_string(query_hash(params), '', '=', '&')).body
    end

    # Request by post method and return result in JSON format
    # Raise OpenTaobao::Error if returned with error_response
    def post!(params)
      response = post params
      raise Error.new(MultiJson.encode response['error_response']) if response.has_key?('error_response')
      response
    end
  end
end
