

module AjaxCat

	module Request

		class Raw

			attr_accessor :sentence, :lock

			def initialize(sentence)
				@sentence = sentence
				@lines = []
				@lock = Mutex.new
				#@lock.lock
			end

			def result
				@lines.join("\n")
			end

			def process_line(line)
				@lines << line.chomp
			end

			def Raw.parse_position(line)
				Integer(line.split(" ||| ").first)
			end

		end

	end


end