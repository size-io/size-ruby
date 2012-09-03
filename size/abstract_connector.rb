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

require 'multi_json'

module Size
	class AbstractConnector

		attr_accessor :publisher_access_token

		def initialize(options={})
			self.publisher_access_token = options[:access_token] || ENV['SIZE_PUBLISHER_TOKEN'] || raise(ArgumentError, "Missing :access_token")
		end

		def publish(key, val, time=nil)
			key  = normalize_key key
			val  = normalize_val val
			time = normalize_time time
			publish_event key, val, time
		end


		private

		def publish_event(key, val, time)
			raise NotImplementedError
		end

		def close_connection
			raise NotImplementedError
		end

		def normalize_key(key)
			key = key.to_s
			if key =~ /[^a-zA-Z0-9_.-]/
				raise ArgumentError, "Invalid key: '#{key}'. Valid values are [a-zA-Z0-9_.-]"
			end
			key
		end

		def normalize_val(val)
			val = val.to_s
			if val =~ /[^0-9.]/
				raise ArgumentError, "Invalid val: '#{val}'. Valid values are [0-9.]"
			end
			val
		end

		def normalize_time(time)
			case time
			when NilClass
				nil
			when Time
				(time.to_f * 1_000).to_i
			when Numeric
				time.to_i
			else
				raise ArgumentError, "Unsupported time value; expected Time or Numeric, got a #{time.class}"
			end
		end

		def json_message(type, key, val, time=nil)
			case type
			when :event
				vals = {:k=>key, :v=>val}
				vals[:t] = time if time
				MultiJson.dump(vals)
			else
				raise SizeClient::Error, "Unrecognized message type: #{type.inspect}"
			end
		end

	end
end
