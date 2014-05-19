# external module 
require 'net/http'
require 'net/https'
require 'uri'

# Liliflora_Talker is Ruby library for talking to the Senser of Arduino Processing API.
#
# Please see the README for usage docs.
module Liliflora
  module LilifloraTalker

    VERSION = '0.1.0'

    # Creating a new Instance of LilifloraTalker::Engine.
    #
    # lf_talker = LilifloraTalker.new()
    def self.new(*args) 
      Engine.new(*args)
    end 
    
    class Engine
      # lab computer.
      SERVER = '192.168.0.10'
      PORT = 80
      SECURE = true
      # TODO: Think about that Default args or options.
      DEFAULT_OPTIONS = { arduino_serial_key: nil, arduino_kit_version: nil, debug:false, headers: {}}

      def initialize(options={})
        @options = DEFAULT_OPTIONS.merge(options)
        
        @headers = {}.merge(@options[:headers])

        proxy_host = nil
        proxy_port = nil
        proxy_var = SECURE ? 'https' : 'http'
        [proxy_var, proxy_var.upcase].each do |proxy|
          if ENV[proxy]
            uri = URI::parse(ENV[proxy])
            proxy_host = uri.host
            proxy_port = uri.port
          end
        end  
        @http  = Net::HTTP::Proxy(proxy_host, proxy_port).new(SERVER,PORT)
        @http.use_ssl = SECURE
        @http.set_debug_output $stdout if @options[:debug]

        # authentication.
      end 

      def accounts
        # TODO if you need to additive authenticate process, add it.

      end
      
      # This is the method that send the actual request to get data.
      # 
      # usage.
      # lf = LilifloraTalker.new({ arduino_serial_key: 10493056, arduino_kit_version: :temperature_light})
      # lf.get({ type: 'retrive',
      #          place: 'inside',
      #          datatype: 'all'})
      #
      # lf.get({ type: 'retrive',
      #          place: 'outside',
      #          datatype: 'latest'})
      #
      # input
      # You can specify what is your purpose, where get the data and the data-type whether all of data or latest.
      def get(args={})
        return results(args)
      end

      # Does the request using Http and then test the response data is valid or not.
      # TODO : Processing 
      def do_http_get(url)
        response, data = @http.get(url, @headers)

        unless response.code == '200'
          case response.code
          when '400'
            data = {
              error: "status code : #{response.code}, message : #{response.body}"
            } 
          else
            data = {
              error: "You have Internal Error. status code : #{response.code}, message: #{response.body}"
            }
          end
        end

        return data
      end

      private 

      def results(args={})
        header = 0
        results = nil

        result_url = build_url(args)

        data = do_http_get(result_url)

        return data unless data.nil?
      end

      # Create a valid URL for Sensor data processing API.
      def build_url(args)
        url_type = args[type]
        url_place = args[place]
        url_datatype = args[datatype]

        complete_url = "/#{url_type}/#{url_place}/#{url_datatype}"

        return complete_url
      end
    end

  end
end