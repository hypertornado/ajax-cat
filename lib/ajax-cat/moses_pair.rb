

module AjaxCat
  class MosesPair

  	def initialize(name, moses_path, moses_ini_path)
      @results
  		@name = name
  		Dir.chdir(Dir.home)
      system("rm #{name}_fifo.fifo; mkfifo #{name}_fifo.fifo")
      #t2 = Thread.new do
        @pipe = IO.popen("#{moses_path} -f #{moses_ini_path} -n-best-list - 300 distinct > #{name}_fifo.fifo", "w")
  		#end
      t1 = Thread.new{reader()}
  	end

  	def process_string(str)
  		@pipe.write("#{str}\nxxxxnonsensestringxxx\n")
  		@pipe.flush
  	end

    def process_request(request)
      @current_request = request
      process_string(request.sentence)
      "CCC"
    end

  	def reader
  		puts "IN READER"

      f = open "#{@name}_fifo.fifo", File::RDWR|File::NONBLOCK

      while l = f.readline
        puts l
      end

      puts "END READER"
  	end


  end
end