
module AjaxCat

	class AjaxCatServer < Sinatra::Base

		get '/' do 
			"hello world"		
		end

		get '/api/raw' do
			req = Request::Raw.new(params[:q])
			Runner.pairs.process_request(req, params[:pair])
		end

	end

end