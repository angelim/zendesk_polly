require 'zendesk_polly/config'
require 'command_line_reporter'

module ZendeskPolly
  class Client
    include CommandLineReporter
    
    ZendeskPollyError  = Class.new(ArgumentError)
    
    attr_reader :polly, :zendesk, :config
    
    def initialize
      @config = Config.new(self)
      yield config if block_given?
    end

    # Call when config is dirty
    def reset!
      @polly_client   = nil
      @zendesk_client = nil
    end

    def polly
      check_polly_configuration
      @polly_client ||= begin
        Aws::Polly::Client.new(
          access_key_id:      config.aws_key,
          secret_access_key:  config.aws_secret,
          region:             config.aws_region
        )
      end
    end

    def zendesk
      check_zendesk_configuration
      @zendesk_client ||= begin
        ZendeskAPI::Client.new do |z|
          z.token     = config.zendesk_token
          z.username  = config.zendesk_username
          z.url       = config.zendesk_url
        end
      end
    end

    def check_configurations
      check_zendesk_configuration
      check_polly_configuration
    end

    def check_zendesk_configuration
      if attr = config.zendesk_configuration.find{ |_, v| v.nil? }
        raise ZendeskPollyError.new("missing #{attr}")
      end
    end

    def check_polly_configuration
      if attr = config.polly_configuration.find{ |_, v| v.nil? }
        raise ZendeskPollyError.new("missing #{attr}")
      end
    end

    def poly_greeting(options = {})
      Greeting.new(self, options)   
    end

    def voice_names
      polly.describe_voices.voices.map(&:id)
    end

    def voices(code)
      code = nil if code == "all"
      table border: true do
        row do
          column 'Voice'
          column 'Language'
          column 'Gender'
        end
        polly.describe_voices({language_code: code}).voices.each do |voice|
          row do
            column voice.id
            column voice.language_name
            column voice.gender
          end
        end
      end
    end
  end
end