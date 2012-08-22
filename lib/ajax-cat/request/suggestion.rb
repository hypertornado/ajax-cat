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
				@suggested_phrases = []
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
					alignment = line.split(" ||| ")[4].strip.split(" ").first
					phrase = Phrase.new(words, alignment)
					suggestion = {
						"text" => phrase.words,
						"from" => phrase.from,
						"to" => phrase.to
					}
					if not @suggested_phrases.member?(suggestion['text'])
						@suggested_phrases.push(suggestion['text'])
						@suggestions.push(suggestion)
					end
				end
			end

		end

	end

end