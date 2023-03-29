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

    pdf_file = params[:pdf_file].tempfile
    pdf = Pdf.new(pdf_file)

    pdf_response = pdf.post

    text = chat.split

    content = params[:content]

    prompt = I18n.t('blog_prompt', arg: content) + text + pdf_response['choices'][0]['message']['content']

    Rails.logger.debug '--------- Start converting chat... ---------'

    response = chat.post(prompt)
    Rails.logger.debug response

    Rails.logger.debug '--------- Finish! ---------'

    blog = Blog.new(text: response['choices'][0]['message']['content'])
    blog.save

    redirect_to blog_path(blog)
  end
end
