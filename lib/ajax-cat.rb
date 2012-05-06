#echo "i think that this house is small" | ./moses -f en-cs/moses.ini  -n-best-list - 10 distinct -include-alignment-in-n-best true 2>/dev/null

#require 'sinatra.rb'
require 'sinatra/base'
require 'json'
require_relative 'ajax-cat/moses_pair.rb'
require_relative 'ajax-cat/request/raw.rb'
require_relative 'ajax-cat/request/simple.rb'

#fork do
  require_relative 'ajax-cat/ajax_cat_server.rb'
#end

module AjaxCat

  class Starter

    def self.pair
      @@pair
    end

  	def self.start()
      fork do
        @@pair = MosesPair.new('cs-en',"/Users/ondrejodchazel/projects/ajax-cat/models/moses","/Users/ondrejodchazel/projects/ajax-cat/sample-models/phrase-model/moses.ini")
        Dir.chdir(Dir.home)
        Dir.mkdir('.ajax-cat') unless Dir.exist?('.ajax-cat')
        File.open('.ajax-cat/server.pid', 'w') {|f| f.write Process.pid }
        
        builder = Rack::Builder.new do
          map('/'){ run AjaxCatServer }
        end
        Rack::Handler::Thin.run builder, :Port => 8888, :Host => "0.0.0.0"

      end
    end

    def self.stop
      Dir.chdir(Dir.home)
      Process.kill 'TERM', File.read('.daftos/server.pid').to_i
    end

  end

end