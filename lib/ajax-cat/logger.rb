module AjaxCat
	class Logger

		@@print = true

		def self.print_log(val)
			@@print = val
		end

		def initialize(prefix = false)
			@prefix = prefix
		end

		def log(message)
			return unless @@print
			puts compose_message(message)
		end

		def compose_message(message)
			t = Time.now
			milliseconds = (t.to_f * 1000 % 1000).to_i
			ret = (t.strftime("%Y-%d-%m %H:%M:%S.#{milliseconds}") + " ")
			(3 - milliseconds.to_s.length).times {ret += " "}
			if @prefix
				ret = "#{ret}#{@prefix.red}: #{message}"
			else
				ret = "#{ret}#{message.green}"
			end
			ret
		end

	end
end