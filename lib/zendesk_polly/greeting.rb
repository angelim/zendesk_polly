require 'forwardable'
require 'launchy'
require 'tempfile'
require 'digest'

module ZendeskPolly
  class Greeting
    extend Forwardable

    AUDIO_CONTENT_TYPE = 'audio/mpeg'
    OUTPUT_FORMAT      = 'mp3'

    CATEGORIES = {
                    voicemail:              1,
                    available:              2,
                    wait:                   3,
                    hold:                   4,
                    ivr:                    5,
                    callback:               6,
                    callback_confirmation:  7
                  }

    attr_accessor :name, :category, :text, :mp3_file, :voice
    attr_reader :client
    
    def initialize(client, options = {})
      @client     = client
      @text       = options[:text]
      raise ArgumentError.new("text is required") unless text
      
      @voice      = options[:voice] || 'Joanna'
      @name       = options[:name] || encoded_text
      @category   = options[:category] || :ivr
      @category   = category.to_sym
      @mp3_file = "/tmp/#{encoded_text}.mp3" if options[:text]
      synthesize_speech
    end

    def encoded_text
      @et ||= Digest::MD5.hexdigest(text)
    end

    def play
      Launchy.open("file://#{mp3_file}")
    end

    def save
      placeholder = client.zendesk.greetings.create!(name: name, category_id: CATEGORIES[category])
      upload(placeholder.id)
    end

    def synthesize_speech
      client.polly.synthesize_speech({
        voice_id: voice,
        text: text,
        output_format: OUTPUT_FORMAT,
        response_target: mp3_file
      })
    end

    def upload(greeting_id)
      raise ArgumentError.new("voice was not generated") unless mp3_file
      client.zendesk.greetings.update!(
        id: greeting_id,
        upload_attributes: { uploaded_data: Faraday::UploadIO.new(mp3_file, AUDIO_CONTENT_TYPE) }
      )
    end

  end
end