# Copyright (c) 2013 tsuru authors
# Use of this source code is governed by a BSD-style license that can be found
# in the LICENSE file.

require "json"
require "net/http"
require "duration"

tsuru_server = ENV["TSURU_SERVER"]
tsuru_port = ENV["TSURU_PORT"]
tsuru_token = ENV["TSURU_TOKEN"]

SCHEDULER.every '10s' do
	deploy_dates = Array.new
  http = Net::HTTP.new tsuru_server, tsuru_port
  if tsuru_port == "443"
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  end
	req = Net::HTTP::Get.new("/deploys")
	req.add_field "Authorization", "bearer #{tsuru_token}"
	response = http.request(req)
	deploys = JSON.parse response.body
  deploys.each do |deploy|
    time = DateTime.parse deploy["Timestamp"]
    elapsed = Duration.new((deploy["Duration"]/1000000000))
  	deploy_dates.push({label: deploy["App"], value: time.strftime("%d/%m/%y  %H:%M:%S") << " - " << elapsed.format("%mm%ss")})
  end
  send_event('deploys', { items: deploy_dates })
end
