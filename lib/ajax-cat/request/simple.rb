

module AjaxCat

	module Request

		class Simple < Raw

			def initialize
				@best_translation = false
			end

			def result
				@best_translation
			end

			def process_line(line)
				@best_translation = line.split(" ||| ")[1] unless @best_translation
			end

		end

	end


end