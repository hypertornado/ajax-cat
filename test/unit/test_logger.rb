require 'helper'

module AjaxCat

	class TestLogger < Test::Unit::TestCase
	  context "run app" do

	  	setup do
	  		@logger = Logger.new("prefix")
	  	end

	  	should "log message" do	  
	  		res = @logger.compose_message("message")		
	  		assert (res =~ /prefix/), "not match prefix"
	  		assert (res =~ /message/), "not match message"
	  	end

	  end
	end

end