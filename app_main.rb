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
      else
        message = [
            {type: 'text',text: "愚かなる人類よ\n言語すら自由に操れんのか"} ,
            {type: 'text',text: "あまりにも哀れだ"}
        ]
        client.reply_message(event['replyToken'], message)
      end
    end
  }

  "OK"
end