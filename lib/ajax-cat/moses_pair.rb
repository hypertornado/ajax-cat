

module AjaxCat
  class MosesPair

  	def initialize(name, moses_path, moses_ini_path)
      @request_queue = []
  		@name = name
      @queue_lock = Mutex.new
  		Dir.chdir(Dir.home + "/.ajax-cat")
      system("rm #{name}_fifo.fifo; mkfifo #{name}_fifo.fifo")
      @pipe = IO.popen("#{moses_path} -f #{moses_ini_path} -n-best-list - 300 distinct > #{name}_fifo.fifo 2>/dev/null", "w")
      t1 = Thread.new{reader()}
  	end

  	def process_string(str)
  		@pipe.write("#{str}\nxxxxnonsensestringxxx\n")
  		@pipe.flush
  	end

    def process_request(request)
      @queue_lock.synchronize do
        request.lock.lock
        @request_queue.push(request)
        process_string(request.sentence)
      end
      #TODO: avoid active waiting somehow
      until request.processed 
        sleep 0.001
      end
      request.result
    end

  	def reader
      f = open "#{@name}_fifo.fifo", File::RDWR|File::NONBLOCK
      last_position = -1

      while l = f.readline
        position = Request::Raw.parse_position(l)
        if position != last_position
          if (last_position % 2 == 0)
            @current_request.processed = true
            @current_request = nil
          else
            @queue_lock.synchronize do
              @current_request = @request_queue.shift
            end
          end
        end
        @current_request.process_line(l) if @current_request
        last_position = position
      end
  	end


  end
end