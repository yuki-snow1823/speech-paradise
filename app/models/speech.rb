# frozen_string_literal: true

class Speech
  END_POINT = 'https://api.openai.com/v1/audio/transcriptions'
  attr_accessor :audio_file

  def initialize(audio_file)
    @audio_file = audio_file
  end

  def post
    HTTParty.post(
      END_POINT,
      headers: {
        'Authorization' => "Bearer #{ENV['API_KEY']}",
        "Content-Type": 'multipart/form-data'
      },
      body: {
        model: 'whisper-1',
        file: @audio_file
      }
    )
  end
end
