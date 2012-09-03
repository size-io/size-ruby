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

require 'socket'
require 'size/abstract_connector'

module Size
	class ProxyConnector < AbstractConnector

		attr_reader :interface, :host, :port

		def initialize(options={})
			super
			@interface = (options[:interface] || 'tcp').to_s
			@host = options[:host]
			@port = options[:port]
		end


		def publish_event(key, val, time)
			message = json_message(:event, key, val, time)
			socket.send message, 0
		end

		def close_connection
			@socket.close if @socket
			@socket = nil
		end


		private

		def socket
			@socket ||= begin
				case interface
				when 'tcp'
					TCPSocket.new host, port
				when 'udp'
					s = UDPSocket.new
					s.connect host, port
					s
				when 'redis'
					raise NotImplementedError, 'Redis client not yet implemented'
				else
					raise ArgumentError, "Unrecognized Proxy Interface: '#{interface}'"
				end
			end
		end

	end
end
