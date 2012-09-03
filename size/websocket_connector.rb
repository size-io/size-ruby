require 'uri'
require 'size/abstract_connector'
require 'web_socket'

module Size
	class WebsocketConnector < AbstractConnector

		attr_reader :url

		def initialize(options={})
			super
			@url = full_url options[:url]
		end

		def publish_event(key, val, time)
			message = json_message(:event, key, val, time)
			socket.send message
		end

		def close_connection
			@socket.close if @socket
			@socket = nil
		end


		private

		def socket
			@socket ||= WebSocket.new url
		end

		def full_url(base_url)
			u = URI.parse base_url
			u.path << '/event/publish'
			if u.query
				u.query << "&access_token=#{publisher_access_token}"
			else
				u.query = "access_token=#{publisher_access_token}"
			end
			u.to_s
		end

	end
end
