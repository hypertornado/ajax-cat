module AjaxCat

	class AjaxCatServer < Sinatra::Base

		before do
			puts request.inspect
			puts "====="
		end

		get '/' do 
			redirect "/index.html"
		end

		get '/api/raw' do
			req = Request::Raw.new(params[:q])
			halt 404 unless Runner.pairs.list.member?(params[:pair])
			Runner.pairs.process_request(req, params[:pair])
		end

		get '/api/table' do
			req = Request::Table.new(params[:q])
			halt 404 unless Runner.pairs.list.member?(params[:pair])
			Runner.pairs.process_request(req, params[:pair]).to_json
		end

		get '/api/suggestion' do
			req = Request::Suggestion.new(params[:q], params[:covered], params[:translated])
			halt 404 unless Runner.pairs.list.member?(params[:pair])
			#TODO: better response
			halt 404 unless params[:covered].include?("0")
			Runner.pairs.process_request(req, params[:pair]).to_json
		end

		get '/api/info' do
			{
				"pairs" => Runner.pairs.list
			}.to_json
		end

		get '/admin' do
			@pairs = Runner.pairs.list
			erb :admin, locals: {pairs: @pairs}
		end

		post '/admin/add_task' do
			Task.new(pair: params[:pair], sentence: params[:sentence]).save
			redirect '/admin'
		end

		post '/admin/remove_task' do
			Task.find(params[:id]).destroy
			redirect '/admin'
		end

		get '/admin/get_experiment' do
			email = params["email"]
			pair = params["pair"]

			tasks = Task.where(pair: pair)
      tasks = tasks.map {|el| el.id}
      completed = Log.where(email: email)
      completed = completed.map {|el| el.task_id}

      pool = tasks - completed

      #puts "tasks: #{tasks.inspect}, completed: #{completed.inspect}, pool: #{pool.inspect}"

			@task = Task.find(pool.first)
			{
				task_id: @task.id,
				pair: @task.pair,
				sentence: @task.sentence,
				email: email
			}.to_json
		end

		post '/admin/save_experiment' do
			data = JSON.parse(params[:log])
			@task = Task.find(data["task_id"])
			@log = Log.new()
			@log.task_id = @task.id
			@log.email = data["email"]
			@log.time = Time.now
			@log.log = data.to_json
			@log.save
		end

		get '/experiment/:id' do
			@task = Task.find(params[:id])
			erb :experiment, locals: {task: @task}
		end

	end

end