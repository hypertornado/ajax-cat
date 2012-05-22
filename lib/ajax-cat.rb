require 'sinatra/base'
require 'thin'
require 'json'
require 'thread'
require 'colorize'
require 'sqlite3'
require 'active_record'
require_relative 'ajax-cat/moses_pair.rb'
require_relative 'ajax-cat/pairs.rb'
require_relative 'ajax-cat/request/raw.rb'
require_relative 'ajax-cat/request/simple.rb'
require_relative 'ajax-cat/request/table.rb'
require_relative 'ajax-cat/request/suggestion.rb'
require_relative 'ajax-cat/ajax_cat_server.rb'
require_relative 'ajax-cat/logger.rb'
require_relative 'ajax-cat/log.rb'
require_relative 'ajax-cat/task.rb'

VERSION = File.read(File.dirname(__FILE__) + "/../VERSION")
DEFAULT_PORT = 8585

module AjaxCat

  class Runner
    def self.pairs
      @@pairs
    end

  	def initialize(port = DEFAULT_PORT, silent = true)
      logger = Logger.new
      logger.log "starting ajax-cat"
      #Thin::Logging.silent = silent
      system("mkdir #{Dir.home}/.ajax-cat 2>/dev/null")
      @settings = JSON.parse(File.read("ajax-cat.ini.json"))
      port = @settings["port"] if port == DEFAULT_PORT
      @@pairs = Pairs.new(@settings)
      Dir.chdir(Dir.home)
      Dir.mkdir('.ajax-cat') unless Dir.exist?('.ajax-cat')
      builder = Rack::Builder.new do
        map('/'){ run AjaxCatServer }
      end
      logger.log "starting server on port #{port}"
      @server = builder
      Rack::Handler::Thin.run builder, :Port => port
      logger.log "ajax-cat server shutted down"
    end

    def self.example
      self.create_sample_moses_ini()
      ret = <<-END.gsub(/^ {8}/, '')
        {
          "port": #{DEFAULT_PORT},
          "pairs": [
            {
              "name": "de-en",
              "moses_path": "moses",
              "moses_ini_path": "#{File.dirname(__FILE__) + "/../test/fixtures/moses.ini"}"
            }
          ]
        }
      END
      ret
    end

    def self.create_sample_moses_ini
      path = File.dirname(__FILE__) + "/../test/fixtures/"
      @moses_ini = <<-END.gsub(/^ {6}/, '')
      #########################
      ### MOSES CONFIG FILE ###
      #########################

      # input factors
      [input-factors]
      0

      # mapping steps, either (T) translation or (G) generation
      [mapping]
      T 0

      # translation tables: source-factors, target-factors, number of scores, file
      [ttable-file]
      0 0 0 1 #{path}phrase-table

      # language models: type(srilm/irstlm/kenlm), factors, order, file
      [lmodel-file]
      8 0 3 #{path}europarl.srilm.gz

      # limit on how many phrase translations e for each phrase f are loaded
      [ttable-limit]
      10

      # distortion (reordering) weight
      [weight-d]
      1

      # language model weights
      [weight-l]
      1

      # translation model weights
      [weight-t]
      1

      # word penalty
      [weight-w]
      0

      [n-best-list]
      nbest.txt
      100



      END
      f = File.new(File.dirname(__FILE__) + "/../test/fixtures/moses.ini", "w")
      f.write(@moses_ini)
      f.close


    end

  end

end

