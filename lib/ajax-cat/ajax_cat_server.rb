
module AjaxCat

	class AjaxCatServer < Sinatra::Base

		get '/' do 
			"hello world"		
		end

		get '/api/raw' do
			req = Request::Raw.new(params[:q])
			Starter.pair.process_request(req)
		end

	end

end