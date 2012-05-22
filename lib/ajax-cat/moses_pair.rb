module AjaxCat
  class MosesPair

  	def initialize(name, moses_path, moses_ini_path)
      @logger = Logger.new(name)
      @logger.log "starting pair".green
      @request_queue = []
      @name = name
      @queue_lock = Mutex.new
  		@fifo_path = "#{Dir.home}/.ajax-cat/#{name}_fifo.fifo"
      system("rm -f #{@fifo_path}; mkfifo #{@fifo_path}")
      t1 = Thread.new{reader()}
      @pipe = IO.popen("#{moses_path} -f #{moses_ini_path} -n-best-list - 300 distinct -include-alignment-in-n-best true -continue-partial-translation true > #{@fifo_path} 2>#{Dir.home}/.ajax-cat/#{name}_moses.log", "w")
      process_request(Request::Raw.new("start_test"))
      @logger.log "pair started".green
    end

  	def process_string(str)
  		@pipe.write("#{str}\nxxxxnonsensestringxxx\n")
  		@pipe.flush
  	end

    def process_request(request)
      @logger.log "processing #{request.class.name} '#{request.sentence.blue}'"
      @queue_lock.synchronize do
        request.lock.lock
        @request_queue.push(request)
        process_string(request.prepare_moses_request)
      end
      #TODO: avoid active waiting somehow
      until request.processed 
        sleep 0.001
      end
      @logger.log "processed #{request.class.name} '#{request.sentence.blue}'"
      request.result
    end

  	def reader
      f = open @fifo_path, File::RDWR|File::NONBLOCK
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