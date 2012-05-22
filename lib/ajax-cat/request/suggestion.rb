module AjaxCat

	module Request

		class Suggestion < Raw

			@@rows = 5
			@@suggestion_length = 3

			def initialize(sentence, covered, translated)
				super(sentence)
				@covered = covered
				@translated = translated
				@translated_length = tokenize(translated).length
				@suggestions = []
			end

			def prepare_moses_request
				"#{@translated} ||| #{@covered} ||| #{@sentence}"
			end

			def result
				{
					"suggestions" => @suggestions
				}
			end

			def process_line(line)
				words = line.split(" ||| ")[1].strip.split(" ")
				if @suggestions.length < @@rows
					suggestion = words[@translated_length, @@suggestion_length].join(" ")
					@suggestions.push(suggestion) unless @suggestions.member?(suggestion)
				end
			end

		end

	end

end