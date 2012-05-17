#echo "i think that this house is small" | ./moses -f en-cs/moses.ini  -n-best-list - 10 distinct -include-alignment-in-n-best true 2>/dev/null

require 'sinatra/base'
require 'thin'
require 'json'
require 'thread'
require 'colorize'
require_relative 'ajax-cat/moses_pair.rb'
require_relative 'ajax-cat/pairs.rb'
require_relative 'ajax-cat/request/raw.rb'
require_relative 'ajax-cat/request/simple.rb'
require_relative 'ajax-cat/ajax_cat_server.rb'
require_relative 'ajax-cat/logger.rb'

VERSION = File.read(File.dirname(__FILE__) + "/../VERSION")

module AjaxCat

  class Runner
    def self.pairs
      @@pairs
    end

  	def initialize(port = 8585, silent = true)
      logger = Logger.new
      logger.log "starting ajax-cat"
      Thin::Logging.silent = silent
      @settings = JSON.parse(File.read("ajax-cat.ini.json"))
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
      ret = <<-START.gsub(/^ {8}/, '')
        {
          "pairs": [
            {
              "name": "de-en",
              "moses_path": "moses",
              "moses_ini_path": "moses.ini"
            }
          ]
        }
      START
      ret
    end

  end

end

