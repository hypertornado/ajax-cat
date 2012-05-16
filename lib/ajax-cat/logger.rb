

module AjaxCat
	class Logger

		def initialize(prefix)
			@prefix = prefix
		end

		def log(message)
			puts compose_message(message)
		end

		def compose_message(message)
			t = Time.now
			ret = t.strftime("%Y-%d-%m %H:%M:%S") + " "
			if @prefix
				ret = "#{ret}#{@prefix}: #{message}"
			else
				ret = "#{ret} #{message}"
			end
			ret
		end

	end
end