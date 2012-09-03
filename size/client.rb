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

module Size
	class Error < RuntimeError ; end

	class Client

		attr_reader :connector

		def self.proxy(options={})
			new options.merge(:connector=>:proxy)
		end

		def self.websocket(options={})
			new options.merge(:connector=>:websocket)
		end

		def initialize(options={})
			case options[:connector]
			when :proxy
				require 'size/proxy_connector'
				@connector = Size::ProxyConnector.new options
			when :websocket
				require 'size/websocket_connector'
				@connector = Size::WebsocketConnector.new options
			else
				raise ArgumentError, "Unknown connector type: #{options[:connector].inspect}"
			end
		end

		# key - string or symbol
		# val - numeric (or string equivalent)
		# time - ruby Time class or numeric (epoch in ms)
		def publish(key, val, time=nil)
			@connector.publish(key, val, time)
		end

		def close_connection
			@connector.close_connection
		end

	end
end
