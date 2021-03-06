require_relative 'Models'

class QueueUrlParams
    KEY_VALUE_SEPARATOR_GROUP_CHAR = '~';
    KEY_VALUE_SEPARATOR_CHAR = '_';
	TIMESTAMP_KEY = "ts"
    COOKIE_VALIDITY_MINUTE_KEY = "cv";
    EVENT_ID_KEY = "e";
	EXTENDABLE_COOKIE_KEY = "ce";
    HASH_KEY = "h";
    QUEUE_ID_KEY = "q";

	attr_accessor :timeStamp
	attr_accessor :eventId
	attr_accessor :hashCode
	attr_accessor :extendableCookie
	attr_accessor :cookieValidityMinute
	attr_accessor :queueITToken
	attr_accessor :queueITTokenWithoutHash
	attr_accessor :queueId

	def initialize
		@timeStamp = 0
		@eventId = ""
		@hashCode = ""
		@extendableCookie = false
		@cookieValidityMinute = nil
		@queueITToken = ""
		@queueITTokenWithoutHash = ""
		@queueId = ""
	end

	def self.extractQueueParams(queueitToken)
		begin
			if(Utils.isNilOrEmpty(queueitToken))
				return nil
			end
			result = QueueUrlParams.new
			result.queueITToken = queueitToken
			paramsNameValueList = result.queueITToken.split(KEY_VALUE_SEPARATOR_GROUP_CHAR)

			paramsNameValueList.each do |pNameValue|
				paramNameValueArr = pNameValue.split(KEY_VALUE_SEPARATOR_CHAR)
			
				case paramNameValueArr[0]
					when TIMESTAMP_KEY 
						begin
							result.timeStamp = Integer(paramNameValueArr[1])
						rescue
							result.timeStamp = 0					
						end
					when COOKIE_VALIDITY_MINUTE_KEY
						begin
							result.cookieValidityMinute = Integer(paramNameValueArr[1])
						rescue
							result.cookieValidityMinute = nil
						end
					when EVENT_ID_KEY
						result.eventId = paramNameValueArr[1]
					when EXTENDABLE_COOKIE_KEY
						if paramNameValueArr[1].upcase.eql? 'TRUE'
							result.extendableCookie = true
						end
					when HASH_KEY
						result.hashCode = paramNameValueArr[1]
					when QUEUE_ID_KEY
						result.queueId = paramNameValueArr[1]
				end		
			end
			result.queueITTokenWithoutHash = result.queueITToken.gsub((KEY_VALUE_SEPARATOR_GROUP_CHAR + HASH_KEY + KEY_VALUE_SEPARATOR_CHAR + result.hashCode), "")		
			return result
		rescue 
			return nil
		end
	end
end