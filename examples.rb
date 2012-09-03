#!/usr/bin/env ruby

=begin

   This file is provided to you under the Apache License,
   Version 2.0 (the "License"); you may not use this file
   except in compliance with the License.  You may obtain
   a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing,
   software distributed under the License is distributed on an
   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
   KIND, either express or implied.  See the License for the
   specific language governing permissions and limitations
   under the License.

=end

# Requires the multi_json gem. Gem options, in most to least recommended
# order: oj, yajl, json, json_pure. Will fallback to okjson if necessary.

# Use of a websocket connection also requires the web-socket-ruby gem.

require './size'


# Initialize a new proxy client
client = Size::Client.new :connector=>:proxy, :interface=>:udp, :host=>'localhost', :port=>6120

# :interface may be 'tcp' or 'udp' (or as symbols: :tcp and :udp)
client = Size::Client.new :connector=>:proxy, :interface=>'tcp', :host=>'localhost', :port=>6120

# There's also a shortcut initializer
client = Size::Client.proxy :interface=>'tcp', :host=>"127.0.0.1", :port=>6120

# :interface defaults to 'tcp' and may be left out
client = Size::Client.proxy :host=>'localhost', :port=>6120

# Initialize a new websocket client
client = Size::Client.new :connector=>:websocket, :url=>'wss://api.size.io/v1.0'

# This too has a shortcut
client = Size::Client.websocket :url=>'wss://api.size.io/v1.0'

# The access token can be provided as a param
client = Size::Client.proxy :host=>'localhost', :port=>6120, :access_token=>'00000000-0000-0000-0000-000000000000'
client = Size::Client.websocket :url=>'wss://api.size.io/v1.0', :access_token=>'00000000-0000-0000-0000-000000000000'

# If it's left out, it will be automatically read from the SIZE_PUBLISHER_TOKEN environment variable.
# These are functionally identical.
client = Size::Client.proxy :host=>'localhost', :port=>6120, :access_token=>ENV['SIZE_PUBLISHER_TOKEN']
client = Size::Client.proxy :host=>'localhost', :port=>6120


# Publish an event
client.publish "api.get", 1

# You can also use a symbol for the key
client.publish :some_key, 5

# The time defaults to the now() [based on the server's clock]. You can override it though:
client.publish "api.get", 1, Time.now

# Or send the time as an epoch in milliseconds
client.publish "api.get", 1, 1341619112013


# If you need global access to the Size client, use a global variable
$size = Size::Client.proxy :host=>'localhost', :port=>6120
$size.publish "api.get", 1

