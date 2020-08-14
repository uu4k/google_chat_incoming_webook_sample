require 'dotenv/load'
require 'faraday'
require 'faraday_middleware'

connection = Faraday.new(
    url: ENV['google_chat_api_webhook_url'],
    headers: {'Content-Type': 'application/json; charset=UTF-8'}
) do |conn|
  conn.request :url_encoded
  conn.request :json
  conn.request :retry, {
      max: 5,
      interval: 1,
      interval_randomness: 0.5,
      backoff_factor: 2
  }
  conn.response :json, content_type: /\bjson$/, parser_options: {symbolize_names: true}

  conn.adapter :net_http
end

p connection.post("", {
    text: 'Hello World!'
})

p connection.post("", {
    text: '<users/all> mention sample'
})

p connection.post("", {
    cards: [
        {
            sections: [
                {
                    widgets: [
                        {
                            image: {
                                imageUrl: "https://example.com/kitten.png",
                                onClick: {
                                    openLink: {
                                        url: "https://example.com/"
                                    }
                                }
                            }
                        }
                    ]
                }
            ]
        }
    ]
})
