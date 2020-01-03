class ChecksController < ApplicationController
  layout 'frontend'

  def index
    @checks = Check.where.not(jsonb: nil)
  end
end

# require "uri"
# require "net/http"

# url = URI("https://api.einvoice.nat.gov.tw/PB2CAPIVAN/invapp/InvApp")

# https = Net::HTTP.new(url.host, url.port);
# https.use_ssl = true

# request = Net::HTTP::Post.new(url)
# request["Content-Type"] = "application/x-www-form-urlencoded"
# request.body = "version=0.2&action=QryWinningList&invTerm=10808&appID=EINV4201912114063"

# check = JSON.parse(https.request(request).read_body)
