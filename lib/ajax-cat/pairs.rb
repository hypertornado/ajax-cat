module AjaxCat

  class Pairs

    attr_reader :db

  	def initialize(configuration)
  		@pairs = {}
      unless File.exist?("#{Dir.home}/.ajax-cat/admin.db")
        @db = SQLite3::Database.new("#{Dir.home}/.ajax-cat/admin.db")
        @db.execute(

          <<-SQL
         create table tasks (
            id integer primary key,
            pair varchar (30),
            sentence text
          )
        SQL
        )
        @db.execute(
          <<-SQL
         create table logs (
            id integer primary key,
            task_id integer,
            email varchar (60),
            time current_timestamp,
            log text
          )
        SQL
        )
        #Task.new(id: 1, pair: "de-en", sentence: "Das ist ein kleines haus").save
        #Task.new(id: 2, pair: "de-en", sentence: "Das ist ein kleines haus 2").save

        #Log.new(task_id: 1, email: "hypertornado@gmail.com", time: Time.now, log: "some log").save
      else
        @db = SQLite3::Database.new "#{Dir.home}/.ajax-cat/admin.db"
      end
      ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "#{Dir.home}/.ajax-cat/admin.db")
  		configuration['pairs'].each do |pair|
  			@pairs[pair['name']] = MosesPair.new(pair['name'], pair['moses_path'], pair['moses_ini_path'])
  		end
  	end

  	def process_request(request, pair_name)
      pair = @pairs[pair_name]
  		pair.process_request(request)
  	end

  	def list
  		@pairs.keys
  	end

  end

end