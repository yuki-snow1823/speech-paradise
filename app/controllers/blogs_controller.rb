# frozen_string_literal: true

class BlogsController < ApplicationController
  def show
    @blog = Blog.find(params[:id])
  end

  def create
    audio_file = params[:audio_file].tempfile

    speech = Speech.new(audio_file)

    Rails.logger.debug '--------- Start converting audio... ---------'

    response = speech.post

    speech_text = response.parsed_response['text']

    chat = Chat.new(speech_text)

    text = chat.split

    prompt = I18n.t('chat_prompt') + text

    Rails.logger.debug '--------- Start converting chat... ---------'

    response = chat.post(prompt)
    Rails.logger.debug response

    Rails.logger.debug '--------- Finish! ---------'

    blog = Blog.new(text: response['choices'][0]['message']['content'])
    blog.save

    redirect_to blog_path(blog)
  end
end
