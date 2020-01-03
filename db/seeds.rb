# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require "uri"
require "net/http"

url = URI("https://api.einvoice.nat.gov.tw/PB2CAPIVAN/invapp/InvApp")

https = Net::HTTP.new(url.host, url.port);
https.use_ssl = true

request = Net::HTTP::Post.new(url)
request["Content-Type"] = "application/x-www-form-urlencoded"
request.body = "version=0.2&action=QryWinningList&invTerm=10808&appID=EINV4201912114063"

check = JSON.parse(https.request(request).read_body)
a = Check.new
a.jsonb = {a: 124}
a.save

a.jsonb = check
a.save