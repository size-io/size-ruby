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
