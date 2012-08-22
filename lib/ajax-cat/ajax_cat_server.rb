module AjaxCat

	class AjaxCatServer < Sinatra::Base

		before do
			#puts request.inspect
			#puts "====="
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
			task = Task.new(pair: params[:pair], name: params[:name])
			task.save
			params[:users].to_i.times do |i|
				puts "USER #{i}"
				options = []
				params[:sentences].length.times do |j|
					if j % 2 == i % 2
						type = 'a'
					else
						type = 'b'
					end
					sentence_options = {}
					sentence_options["type"] = type
					sentence_options["suggestion"] = (params["suggestion-#{type}"] == "on")
					options.push(sentence_options)
				end
				Log.new(task_id: task.id, options: options.to_json, sentences: params[:sentences].to_json).save
			end
			redirect '/admin'
		end

		post '/admin/remove_task' do
			Log.where(task_id: params[:id]).delete_all
			Task.find(params[:id]).destroy
			redirect '/admin'
		end

		get '/admin/get_experiment' do
			email = params["email"]
			pair = params["pair"]

			tasks = Task.where(pair: pair)
      tasks = tasks.map {|el| el.id}

      free_task_ids = Log.where(email: nil).map {|el| el.task_id}

      completed = Log.where(email: email)
      completed = completed.map {|el| el.task_id}

      pool = (tasks | free_task_ids) - completed

      puts email
      puts "t: #{tasks.inspect}, f: #{free_task_ids.inspect}, c: #{completed.inspect}, p: #{pool.inspect}"

				@task = Log.where(task_id: pool.first).first
				@task.email = email
				@task.save
				ret = {
					task_id: @task.id,
					pair: @task.task.pair,
					sentences: @task.sentences,
					options: @task.options,
					email: email
				}.to_json
			ret
		end

		post '/admin/save_experiment' do
			@log = Log.find(params[:log_id])
			data = JSON.parse(params[:log])
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