module AjaxCat

  class Pairs

  	def initialize(configuration)
  		@pairs = {}
  		configuration['pairs'].each do |pair|
  			@pairs[pair['name']] = MosesPair.new(pair['name'], pair['moses_path'], pair['moses_ini_path'])
  		end
  	end

  	def process_request(request, pair_name)
  		@pairs[pair_name].process_request(request)
  	end

  	def list
  		@pairs.keys
  	end

  end

end