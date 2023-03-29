# frozen_string_literal: true

class Chat
  attr_accessor :prompt

  END_POINT = 'https://api.openai.com/v1/chat/completions'

  def initialize(prompt)
    @prompt = prompt
  end

  def post(text)
    HTTParty.post(END_POINT,
                  headers: { 'Content-Type' => 'application/json',
                             'Authorization' => "Bearer #{ENV['API_KEY']}" },
                  'Accept' => 'application/json',
                  body: { model: 'gpt-3.5-turbo',
                          messages: [{ role: 'user', content: text }] }.to_json, max_tokens: 3000, timeout: 3000)
  end

  def split
    text_blocks = split_string(@prompt)

    Rails.logger.debug text_blocks

    header_prompt = I18n.t('chat_prompt')

    p header_prompt

    # ブロックごとの結果を蓄積するための配列を用意
    clean_text_blocks = []
    text_blocks.each do |text|
      prompt = "#{header_prompt}\n#{text}"

      response = HTTParty.post(END_POINT,
                               headers: { 'Content-Type' => 'application/json',
                                          'Authorization' => "Bearer #{ENV['API_KEY']}" },
                               'Accept' => 'application/json',
                               body: { model: 'gpt-3.5-turbo',
                                       messages: [{ role: 'user', content: prompt }] }.to_json, timeout: 3000)

      Rails.logger.debug '------- Response is... -------'
      Rails.logger.debug response

      answer = response['choices'][0]['message']['content']
      clean_text_blocks << answer
    end

    clean_text_blocks.join("\n")
  end

  def split_string(string, chunk_size = 2000)
    string.scan(/.{1,#{chunk_size}}/)
  end
end
