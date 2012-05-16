require 'helper'

module AjaxCat

	class TestLogger < Test::Unit::TestCase
	  context "run app" do

	  	setup do
	  		@logger = Logger.new("prefix")
	  	end

	  	should "log message" do	  
	  		res = @logger.compose_message("message")		
	  		puts "COMPOSE #{res}"
	  		assert (res =~ /prefix: message/), "not match"
	  	end

	  end
	end

end