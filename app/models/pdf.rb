# frozen_string_literal: true

class Pdf
  END_POINT = 'https://api.openai.com/v1/chat/completions'
  MAX_TOKENS = 2000
  TIMEOUT = 3000

  def initialize(pdf_file)
    @text = extract_text(pdf_file)
  end

  def post
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{ENV['API_KEY']}",
      'Accept' => 'application/json'
    }

    HTTParty.post(END_POINT,
                  headers: headers,
                  body: { model: 'gpt-3.5-turbo',
                          messages: [{ role: 'user', content: "#{I18n.t('chat_prompt')}\n#{@text}" }] }.to_json,
                  query: { max_tokens: MAX_TOKENS, timeout: TIMEOUT })
  end

  private

  def extract_text(pdf_file)
    reader = PDF::Reader.new(pdf_file)
    reader.pages.map { |page| page.text.gsub(/\s+/, '') }.join
  end
end
