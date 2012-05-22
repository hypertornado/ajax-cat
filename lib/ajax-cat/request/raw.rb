

module AjaxCat

	module Request

		class Raw

			attr_accessor :sentence, :lock, :processed

			def initialize(sentence)
				@sentence = sentence
				@lines = []
				@lock = Mutex.new
				@processed = false
			end

			def prepare_moses_request
				@sentence
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

			def tokenize(str)
				str.strip.split(/[\t\n ]+/)
			end

		end

	end


end