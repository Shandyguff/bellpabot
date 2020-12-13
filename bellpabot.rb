require 'twitter'
require 'open-uri'
require 'json'

File.open("keys.json") do |f|
    key = JSON.load(f)
    CONSUMER_KEY = key["keys"]["CONSUMER_KEY"]
    CONSUMER_SECRET = key["keys"]["CONSUMER_SECRET"]
    ACCESS_TOKEN_KEY = key["keys"]["ACCESS_TOKEN_KEY"]
    ACCESS_SECRET = key["keys"]["ACCESS_SECRET"]
end

begin
    twitter_client = Twitter::REST::Client.new do |config|
        config.consumer_key = CONSUMER_KEY
        config.consumer_secret = CONSUMER_SECRET
        config.access_token = ACCESS_TOKEN_KEY
        config.access_token_secret = ACCESS_SECRET
    end

    t = Time.now
    if t.hour <= 12
        content = "costume.json"
    else
        content = "adult_item.json"
    end

    text = String.new
    img = Array.new

    File.open(content) do |file|
        hash = JSON.load(file)
        #imgs = hash["day19morning"].values
        #img = hash["day#{t.day}#{timing}"].values
        img = hash[rand(1..24).to_s].values
    end

    text = img[0]

    img_urls = Array.new
    if img[2] == ""
        img_urls = img[1]
    elsif img[3] == ""
        img_urls = img[1..2]
    elsif img[4] == ""
        img_urls = img[1..3]
    else
        img_urls = img[1..4]
    end
    imgs = img_urls.map { |img_url| URI.open(img_url) }
    twitter_client.update_with_media(text, imgs)
    rescue => exception
        STDERR.puts "[EXCEPTION] " + exception.to_s
        exit 1
end