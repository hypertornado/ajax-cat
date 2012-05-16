#echo "i think that this house is small" | ./moses -f en-cs/moses.ini  -n-best-list - 10 distinct -include-alignment-in-n-best true 2>/dev/null

require 'sinatra/base'
require 'thin'
require 'json'
require 'thread'
require_relative 'ajax-cat/moses_pair.rb'
require_relative 'ajax-cat/request/raw.rb'
require_relative 'ajax-cat/request/simple.rb'
require_relative 'ajax-cat/ajax_cat_server.rb'
require_relative 'ajax-cat/logger.rb'

module AjaxCat

  class Starter

    def self.pair
      @@pair
    end

  	def self.start(port = 8585, silent = false)
      Thin::Logging.silent = silent
      @@pair = MosesPair.new('cs-en',"moses","/Users/ondrejodchazel/projects/ajax-cat/ajax-cat-new/test/fixtures/moses.ini")
      Dir.chdir(Dir.home)
      Dir.mkdir('.ajax-cat') unless Dir.exist?('.ajax-cat')
      builder = Rack::Builder.new do
        map('/'){ run AjaxCatServer }
      end
      Rack::Handler::Thin.run builder, :Port => port
    end
  end

end