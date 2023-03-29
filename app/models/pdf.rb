# frozen_string_literal: true

class Pdf
  attr_accessor :text
  END_POINT = 'https://api.openai.com/v1/chat/completions'


  def initialize(pdf_file)
    text = []
    reader = PDF::Reader.new(pdf_file)

    reader.pages.each do |page|
      text << page.text.gsub(/\s+/, '')
    end
    @text = text.join()
  end

  def post
    HTTParty.post(END_POINT,
                  headers: { 'Content-Type' => 'application/json',
                            'Authorization' => "Bearer #{ENV['API_KEY']}" },
                            'Accept' => 'application/json',
                  body: { model: 'gpt-3.5-turbo',
                          messages: [{ role: 'user', content: I18n.t('chat_prompt') + "\n" + @text }]
                        }.to_json, max_tokens: 3000, timeout: 3000
                  )
  end
end