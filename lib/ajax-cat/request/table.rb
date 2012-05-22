module AjaxCat

	module Request

		class Table < Raw

			@@rows = 5

			def initialize(sentence)
				super(sentence)
				@ret = {}
				@ret["source"] = @sentence.strip.split(" ")
				@buckets = []
				@ret["source"].size.times {@buckets.push([])}
			end

			def result
				@ret["table"] = []
				@@rows.times do |row_number|
					i = 0
					free_space = 0
					row = []
					while i < @buckets.size
						el = @buckets[i].shift
						if el
							if free_space > 0
								row.push({"w" => free_space})
							end
							this_space = el.to - el.from + 1
							row.push({
								"str" => el.words,
								"w" => this_space
							})
							free_space = 0
							i += this_space
						else
							free_space += 1
							i += 1
						end
					end
					@ret["table"].push(row) if row.size > 0
				end
				return @ret
			end

			def process_line(line)
				splited = line.split(" ||| ")
				words = splited[1].strip.split(" ")
				alignment = splited[4].strip.split(" ")
				alignment.each do |al|
					phrase = Phrase.new(words, al)
					finded = @buckets[phrase.from].find do |el|
						el.words == phrase.words and el.to == phrase.to
					end
					@buckets[phrase.from].push(phrase) if finded == nil
				end
			end

		end

		class Phrase

			attr_reader :from, :to, :words

			def initialize(words_list, alignment)
				alignment = alignment.split("=")
				source_alignment = parse(alignment[0])
				target_alignment = parse(alignment[1])
				@from = source_alignment[:from]
				@to = source_alignment[:to]
				@words = ""
				target_alignment[:from].upto(target_alignment[:to]) do |position|
					@words += " #{words_list[position]}"
				end
				@words.strip!
			end

			def parse(alignment)
				if alignment.include?("-")
					alignment = alignment.split("-")
					from = alignment[0].to_i
					to = alignment[1].to_i
				else
					from = alignment.to_i
					to = from
				end
				return {from: from, to: to}
			end

		end

	end

end