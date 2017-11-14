require 'sinatra'
require 'line/bot'

get '/' do
    "hello world"
end

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each { |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = [
            {type: 'text',text: "愚かなる人類よ\n高貴な私が貴様の言葉を繰り返してやろう"},
            {type: 'text',text: event.message['text']},
            {type: 'text',text: "この喜びを魂に刻み込め"}
        ]
        client.reply_message(event['replyToken'], message)
      
      when Line::Bot::Event::MessageType::Image
        message = [
            {type: 'text',text: "この宇宙にあるものは皆等しく美しい"} ,
            {type: 'text',text: "その美しさを魂に刻み込め"}
        ]
        client.reply_message(event['replyToken'], message)
      
      when Line::Bot::Event::MessageType::Video
        message = [
            {type: 'text',text: "私は平面的な動きには興味がない"} ,
            {type: 'text',text: "愚かなる人類よ\n現実の風景を魂に刻み込め"}
        ]
        client.reply_message(event['replyToken'], message)
      
      when Line::Bot::Event::MessageType::Audio
        message = [
            {type: 'text',text: "宇宙は常に旋律を奏でている"} ,
            {type: 'text',text: "その音を魂に刻み込め"}
        ]
        client.reply_message(event['replyToken'], message)
        
      when Line::Bot::Event::MessageType::File
        message = [
            {type: 'text',text: "愚かなる人類よ\nデータの世界に囚われるな"} ,
            {type: 'text',text: "その魂を宇宙に解き放て"}
        ]
        client.reply_message(event['replyToken'], message)
      
      when Line::Bot::Event::MessageType::Location
        message = [
            {type: 'text',text: "そこが貴様が囚われている大地の座標か"} ,
            {type: 'text',text: "大地に囚われるとは、哀れなことよ"}
        ]
        client.reply_message(event['replyToken'], message)
        
      when Line::Bot::Event::MessageType::Sticker
        message = [
            {type: 'text',text: "愚かなる人類よ\n遂に言語を捨てたか"} ,
            {type: 'text',text: "言語を捨てるとは、哀れなことよ"}
        ]
        client.reply_message(event['replyToken'], message)
        
      　else
      　  message = [
            {type: 'text',text: "愚かなる人類よ\n遂に言語を捨てたか"} ,
            {type: 'text',text: "哀れなものよ"}
        ]
        client.reply_message(event['replyToken'], message)
        
      end
    end
  }

  "OK"
end