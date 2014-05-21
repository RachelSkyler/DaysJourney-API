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

    # Include sensor_type or data_collection_interval_type or retrieve_type
    #
    # SENSOR TYPE
    #
    # SENSOR_ALL = 'all', SENSOR_ANALOG_SOUND = 'analogsound', SENSOR_DUST = 'dust', SENSOR_FLAME = 'frame', SENSOR_HUMIDITY = 'humidity',
    # SENSOR_LIGHT_BRIGHTNESS = 'lightbrightness', SENSOR_RAINDROP = 'raindrop', SENSOR_TEMPERATURE_CELSIUS = 'temperaturecelsius',
    # SENSOR_TEMPERATURE_FAHRENHEIT = 'temperaturefahrenheit', SENSOR_ACCELEROMETER = 'accelerometer', SENSOR_TOUCH = 'touch',
    # SENSOR_DIGITAL_TILT = 'digitaltilt', SENSOR_DIGITAL_VIBRATION = 'digitalvibration', SENSOR_INFRARED_MOTION = 'infraredmotion', 
    #
    #
    # DATA CELLECTION INTERVAL TYPE
    #
    # DATA_COLLECTION_INTERVAL_REAL_TIME = 0, DATA_COLLECTION_INTERVAL_RAPID = 1, DATA_COLLECTION_INTERVAL_MEDIUM = 2
    # DATA_COLLECTION_INTERVAL_SLOW = 3, DATA_COLLECTION_INTERVAL_SINGLE = 4
    #
    # RETRIEVE TYPE
    # 
    # RETRIEVE_ALL = 'all', RETRIEVE_LATEST = 'latest'

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
      DEFAULT_OPTIONS = { arduino_serial_key: nil, arduino_kit_version: nil, debug:false,headers: {}}

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
      # lf = LilifloraTalker.new({ arduino_device_id: 10493056, password: 'dddsfs'})
      # lf.get({ type: 'retrive',
      #          device_id: 'potato',
      #          sensot_type: LilifloraTalker::TYPE_ALL,
      #          retrieve_type: LilifloraTalker::RETRIEVE_ALL })
      #
      # lf.get({ type: 'collect',
      #          device_id: 'rachel',
      #          sensot_type: LilifloraTalker::TYPE_ALL,
      #          data_collection_interval_type: LilifloraTalker::DATA_COLLECTION_INTERVAL_REAL_TIME})
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
        result_url = nil

        if args[type] == 'retrieve'
          result_url = build_retrieve_url(args)
        else
          result_url = build_collect_url(args)
        end
        
        data = do_http_get(result_url)

        return data unless data.nil?
      end

      # Create a valid URL for Sensor data processing API.:
      #
      # build_retrieve_url
      # build_collect_url

      def build_retrieve_url(args)
        url_type = args[type]
        url_device_id = args[device_id]
        url_sensor_type = args[sensot_type]
        url_retrieve_type = args[retrieve_type]

        complete_url = "/data/#{url_type}/#{url_device_id}/#{url_sensor_type}/#{url_retrieve_type}"

        return complete_url
      end

      def build_collect_url(args)
        url_type = args[type]
        url_device_id = args[device_id]
        url_sensor_type = args[sensot_type]
        url_data_collection_interval_type = args[data_collection_interval_type]

        complete_url = "/data/#{url_type}/#{url_device_id}/#{url_sensor_type}/#{url_data_collection_interval_type}"
        
        return complete_url
      end
    end

  end
end