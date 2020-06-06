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
      text = event.message['text']
      userId = event['source']['userId']
      # nowHash = {}


      if PseudoSession.getStatus(userId).blank?
        PseudoSession.putStatus(userId, "0", "")
        # nowHash = PseudoSession.getStatus(userId)
      # else
      #   # nowHash = PseudoSession.getStatus(userId)
      end

      if PseudoSession.readContext(userId) == "0"
        if text.eql?('アルバム')
          PseudoSession.updateContext(userId, "1")
          client.reply_message(event['replyToken'], template)
        end
      elsif PseudoSession.readContext(userId) == "1"
        if text.eql?('アルバムを作成する')
          PseudoSession.updateContext(userId, '2')
          reply_text(event, "アルバム名を教えてください！中止するときは「中止」と言ってください。")
        elsif text.eql?('アルバムを作成しない')
          PseudoSession.updateContext(userId, '0')
          reply_text(event, "またの機会に〜")
        end
      elsif PseudoSession.readContext(userId) == "2"
        if text.eql?('中止')
          PseudoSession.updateContext(userId, '0')
          reply_text(event, "またの機会に〜")
        elsif text
          PseudoSession.updateContext(userId, '3')
          PseudoSession.updateAlbumName(userId, text)
          reply_text(event, "#{text}ですね！アルバムに入れる写真を送ってください！")
        end
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
