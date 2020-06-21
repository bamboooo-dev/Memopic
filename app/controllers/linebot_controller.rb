require 'line/bot'
require 'pseudo_session'

class LinebotController < ApplicationController

  UNDO    = 0
  CREATE  = 1
  NAME    = 2
  PICTURE = 3

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
        PseudoSession.putStatus(userId, UNDO, nil)
      end

      case PseudoSession.readContext(userId)
      when UNDO
        if text.eql?('アルバム')
          PseudoSession.updateContext(userId, CREATE)
          client.reply_message(event['replyToken'], template)
        end
      when CREATE
        if text.eql?('アルバムを作成する')
          PseudoSession.updateContext(userId, NAME)
          reply_text(event, 'アルバム名を教えてください！中止するときは「中止」と言ってください。')
        elsif text.eql?('アルバムを作成しない')
          reply_text(event, 'またの機会に〜')
          PseudoSession.deleteStatus(userId)
        end
      when NAME
        if text.eql?('中止')
          PseudoSession.deleteStatus(userId)
          reply_text(event, 'またの機会に〜')
        elsif text
          PseudoSession.updateContext(userId, PICTURE)
          album = Album.create(name: text, album_hash: SecureRandom.alphanumeric(20))
          PseudoSession.updateAlbumID(userId, album.id)
          reply_text(event, "#{text}ですね！アルバムに入れる写真を送ってください！")
        end
      when PICTURE
        if event['message']['type'] == 'image'
          PseudoSession.incrementPictureCount(userId)
          messageId = event["message"]["id"]
          response = client.get_message_content(messageId)
          album = Album.find( PseudoSession.readAlbumID(userId) )
          output_path = Rails.root.join('tmp', 'albums', SecureRandom.alphanumeric(10) + ".jpg")
          File.open(output_path, 'w+b') do |fp|
            fp.write(response.body)
          end

          picture = ActionDispatch::Http::UploadedFile.new(
            filename: SecureRandom.alphanumeric(10) + ".jpg",
            type: 'image/jpeg',
            tempfile: File.open(output_path)
          )
          album.pictures.create(picture_name: picture)
          PseudoSession.decrementPictureCount(userId)
          if PseudoSession.readPictureCount(userId) == 0
            reply_text(event, "画像をアップロードしました！さらに写真を追加するか、「終わり」と送信してアルバムの作成を完了してください")
          end
        elsif text.eql?('終わり')
          album = Album.find( PseudoSession.readAlbumID(userId) )
          reply_text(event, "アルバム完成！ => " + ENV["URL"] + "/albums/#{album.album_hash}")
          PseudoSession.deleteStatus(userId)
        end
      end
    }
    response_success(:linebot, :callback)
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
