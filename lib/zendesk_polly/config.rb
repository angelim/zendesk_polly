require 'fileutils'
require 'yaml'

module ZendeskPolly
  class Config
    attr_accessor :zendesk_token, :zendesk_username, :zendesk_url
    attr_accessor :aws_key, :aws_secret, :aws_region
    attr_reader   :client

    def initialize(client = nil)
      @client = client # retrieves the client to allow reseting when changing attributes
      deserialize_from_file if File.exist?(config_file)
      @aws_region ||= 'us-east-1'
    end

    def config_file
      @config_file ||= File.join(File.expand_path('~'), '.zendesk_polly')
    end

    def deserialize_from_file
      self.attributes = YAML.load_file(config_file)
    end

    def serialize_to_file
      File.write(config_file, attributes.to_yaml)
    end

    def attributes=(options)
      self.zendesk_token      = options[:zendesk_token]
      self.zendesk_username   = options[:zendesk_username]
      self.zendesk_url        = options[:zendesk_url]
      self.aws_region         = options[:aws_region]
      self.aws_key            = options[:aws_key]
      self.aws_secret         = options[:aws_secret]
    end

    def attributes
      {
        zendesk_token:          zendesk_token,
        zendesk_username:       zendesk_username,
        zendesk_url:            zendesk_url,
        aws_key:                aws_key,
        aws_secret:             aws_secret,
        aws_region:             aws_region
      }
    end

    def zendesk_configuration
      attributes.select{ |k, _| k =~ /\Azendesk/ }
    end

    def polly_configuration
      attributes.select{ |k, _| k =~ /\Aaws/ }
    end
  end
end