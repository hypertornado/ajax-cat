

module AjaxCat
  class MosesPair

  	def initialize(name, moses_path, moses_ini_path)
      @request_queue = []
      @current_position = -1
  		@name = name
      @lock = Mutex.new
  		Dir.chdir(Dir.home)
      system("rm #{name}_fifo.fifo; mkfifo #{name}_fifo.fifo")
      @pipe = IO.popen("#{moses_path} -f #{moses_ini_path} -n-best-list - 300 distinct > #{name}_fifo.fifo", "w")
      t1 = Thread.new{reader()}
  	end

  	def process_string(str)
  		@pipe.write("#{str}\nxxxxnonsensestringxxx\n")
  		@pipe.flush
  	end

    def process_request(request)
      @lock.synchronize do
        request.lock.lock
        @request_queue.push(request)
        process_string(request.sentence)
      end
      #while request.lock.locked?
      while request.result.length == 0 do
        sleep 0.001
      end
      request.result
    end

  	def reader
      f = open "#{@name}_fifo.fifo", File::RDWR|File::NONBLOCK

      while l = f.readline
        position = Request::Raw.parse_position(l)
        if position != @current_position
          if (position % 2 == 0)
            @current_request = @request_queue.shift
          else
            if @current_request
              puts "UNLOCKING"
              @current_request.lock.unlock
            end
            @current_request = nil
          end
        end
        @current_request.process_line(l) if @current_request
        #@current_request.lock.unlock
        puts l
      end

  	end


  end
end