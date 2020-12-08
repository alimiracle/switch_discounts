require 'net/http'
require 'uri'
require 'json'
require 'rufus-scheduler'

def post_msg(bot_token, chat_id, txt)
uri = URI.parse("https://api.telegram.org/bot"+bot_token+"/sendMessage")
request = Net::HTTP::Post.new(uri)
request.set_form_data(
  "chat_id" => chat_id,
  "text" => txt,
)

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end
end
bot_token = ENV["BOT_TOKEN"]
chat_id = ENV["CHAT_ID"]
scheduler = Rufus::Scheduler.new

scheduler.every '1m' do



arr = File.readlines("name")
list=arr.inspect


uri = URI.parse("https://ec.nintendo.com/api/US/en/search/sales?count=30&offset=0")
response = Net::HTTP.get_response(uri)

# response.code
#puts(response.body)
parse=JSON.parse(response.body)
file=File.open("name","w")

$i=0
while $i < 30 do
if list.include?(parse['contents'][$i]['formal_name'])==false then
post_msg(bot_token, chat_id, parse['contents'][$i]['formal_name'])
end
    file.write parse['contents'][$i]['formal_name'] + "\n"

$i=$i+1

end
file.close
end
scheduler.join
