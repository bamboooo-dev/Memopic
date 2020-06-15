require 'line/bot'
require 'pseudo_session'

class LinebotController < ApplicationController

  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def reply_text(event, texts)
    texts = [texts] if texts.is_a?(String)
    client.reply_message(
      event['replyToken'],
      texts.map { |text| {type: 'text', text: text} }
    )
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      halt 400, {'Content-Type' => 'text/plain'}, 'Bad Request'
    end

    events = client.parse_events_from(body)


    events.each { |event|
      text = event['message']['text']
      userId = event['source']['userId']

      if PseudoSession.getStatus(userId).nil?
        PseudoSession.putStatus(userId, '0', '')
      end

      if PseudoSession.readContext(userId) == '0'
        if text.eql?('アルバム')
          PseudoSession.updateContext(userId, '1')
          client.reply_message(event['replyToken'], template)
        else
          PseudoSession.deleteStatus(userId)
        end
      elsif PseudoSession.readContext(userId) == '1'
        if text.eql?('アルバムを作成する')
          PseudoSession.updateContext(userId, '2')
          reply_text(event, 'アルバム名を教えてください！中止するときは「中止」と言ってください。')
        elsif text.eql?('アルバムを作成しない')
          reply_text(event, 'またの機会に〜')
          PseudoSession.deleteStatus(userId)
        else
          PseudoSession.deleteStatus(userId)
        end
      elsif PseudoSession.readContext(userId) == '2'
        if text.eql?('中止')
          PseudoSession.deleteStatus(userId)
          reply_text(event, 'またの機会に〜')
        elsif text
          PseudoSession.updateContext(userId, '3')
          PseudoSession.updateAlbumName(userId, text)
          Album.create(name: text, album_hash: SecureRandom.alphanumeric(20))
          reply_text(event, "#{text}ですね！アルバムに入れる写真を送ってください！全て送信が完了したら「終わり」と送信してください！")
        else
          PseudoSession.deleteStatus(userId)
        end
      elsif PseudoSession.readContext(userId) == '3'
        if event['message']['type'] == 'image'
          messageId = event["message"]["id"]
          response = client.get_message_content(messageId)
          album = Album.find_by(name: PseudoSession.getStatus(userId)['album_name'])
          output_path = Rails.root.to_s + '/tmp/albums/file.jpg'

          File.open(output_path, 'w+b') do |fp|
            fp.write(response.body)
          end

          picture = ActionDispatch::Http::UploadedFile.new(
            filename: SecureRandom.alphanumeric(10) + ".jpg",
            type: 'image/jpeg',
            tempfile: File.open(output_path)
          )
          album.pictures.create(picture_name: picture)

        elsif text.eql?('終わり')
          album = Album.find_by(name: PseudoSession.getStatus(userId)['album_name'])
          reply_text(event, "アルバム完成！ => hhttps://memopic.herokuapp.com/albums/#{album.album_hash}")
          PseudoSession.deleteStatus(userId)
        end
      else
        PseudoSession.deleteStatus(userId)
      end
    }

  end


    private

  def template
    {
      "type": "template",
      "altText": "this is a confirm template",
      "template": {
          "type": "confirm",
          "text": "アルバムを新規作成しますか？",
          "actions": [
              {
                "type": "message",
                "label": "作成する",
                "text": "アルバムを作成する"
              },
              {
                "type": "message",
                "label": "作成しない",
                "text": "アルバムを作成しない"
              }
          ]
      }
    }
  end

end
