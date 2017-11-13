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
            {type: 'text',text: "愚かなる人類よ\n貴様の汚れた言葉をここに繰り返そう"},
            {type: 'text',text: event.message['text']}
        ]
        client.reply_message(event['replyToken'], message)
      else
        message = {type: 'text',text: "愚かなる人類よ\n人間の言葉で喋れ"} 
        client.reply_message(event['replyToken'], message)
      end
    end
  }

  "OK"
end